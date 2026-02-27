"""
Clustering Tool for Study Group Formation
==========================================
Provides K-Means and Agglomerative clustering on student skill-profile vectors,
with a complementary-matching post-processing step that maximises skill diversity
within each group.
"""

from __future__ import annotations

import numpy as np  # type: ignore[import-untyped]
from sklearn.cluster import KMeans, AgglomerativeClustering  # type: ignore[import-untyped]
from sklearn.preprocessing import MinMaxScaler  # type: ignore[import-untyped]


# ── public API ────────────────────────────────────────────────────────────────

def build_skill_vectors(students: list[dict], subjects: list[str]) -> np.ndarray:
    """Convert a list of student dicts into an (n_students × n_subjects) matrix.

    Each student dict must have a ``skills`` sub-dict keyed by subject name,
    with numeric proficiency values (1-10).
    """
    matrix = []
    for s in students:
        row = [s.get("skills", {}).get(subj, 5) for subj in subjects]
        matrix.append(row)
    arr = np.array(matrix, dtype=float)
    return MinMaxScaler().fit_transform(arr)


def cluster_kmeans(
    vectors: np.ndarray,
    n_groups: int,
    random_state: int = 42,
) -> np.ndarray:
    """Run K-Means clustering and return label array."""
    km = KMeans(n_clusters=n_groups, random_state=random_state, n_init=10)
    return km.fit_predict(vectors)


def cluster_agglomerative(
    vectors: np.ndarray,
    n_groups: int,
) -> np.ndarray:
    """Run Agglomerative (Ward) clustering and return label array."""
    agg = AgglomerativeClustering(n_clusters=n_groups, linkage="ward")
    return agg.fit_predict(vectors)


def complementary_rebalance(
    students: list[dict],
    labels: np.ndarray,
    vectors: np.ndarray,
    subjects: list[str],
    n_groups: int,
    target_size: int = 4,
) -> list[list[dict]]:
    """Re-balance clustered groups so every group has maximum skill diversity.

    Algorithm
    ---------
    1. Sort students by their *specialisation gap* (max score − min score)
       so the most polarised students are placed first.
    2. Greedily assign each student to the group whose current aggregate
       skill vector has the *lowest* value on the student's strongest
       subject, ensuring complementary coverage.
    3. Respect ``target_size`` ±1 to keep groups roughly equal.
    """
    n = len(students)
    max_size = target_size + 1
    groups: list[list[int]] = [[] for _ in range(n_groups)]
    group_sums = np.zeros((n_groups, len(subjects)))

    # Sort by polarisation (descending) — place specialists first
    order = sorted(
        range(n),
        key=lambda i: float(vectors[i].max() - vectors[i].min()),
        reverse=True,
    )

    for idx in order:
        best_group = -1
        best_score = float("inf")
        strongest_subj = int(np.argmax(vectors[idx]))

        for g in range(n_groups):
            if len(groups[g]) >= max_size:
                continue
            # prefer the group that is weakest where this student is strongest
            score = float(group_sums[g][strongest_subj])
            if score < best_score:
                best_score = score
                best_group = g

        if best_group == -1:
            # overflow — pick the smallest group
            best_group = min(range(n_groups), key=lambda g: len(groups[g]))

        groups[best_group].append(idx)
        group_sums[best_group] += vectors[idx]

    # Build output
    result: list[list[dict]] = []
    for g in groups:
        result.append([students[i] for i in g])
    return result


def form_study_groups(
    students: list[dict],
    subjects: list[str],
    n_groups: int | None = None,
    target_size: int = 4,
    method: str = "kmeans",
) -> list[list[dict]]:
    """End-to-end pipeline: vectorise → cluster → rebalance → return groups.

    Parameters
    ----------
    students   : list of student dicts with ``name`` and ``skills`` keys.
    subjects   : ordered list of subject/skill names.
    n_groups   : desired number of groups (default: ceil(n / target_size)).
    target_size: ideal members per group.
    method     : ``"kmeans"`` or ``"agglomerative"``.

    Returns
    -------
    A list of groups, where each group is a list of student dicts.
    """
    n = len(students)
    if n_groups is None:
        n_groups = max(1, -(-n // target_size))   # ceiling division

    vectors = build_skill_vectors(students, subjects)

    if method == "agglomerative":
        labels = cluster_agglomerative(vectors, n_groups)
    else:
        labels = cluster_kmeans(vectors, n_groups)

    return complementary_rebalance(
        students, labels, vectors, subjects, n_groups, target_size
    )


def compute_group_stats(
    group: list[dict], subjects: list[str]
) -> dict:
    """Return per-subject mean, min, max and a diversity score for a group."""
    if not group:
        return {"subjects": {}, "diversity_score": 0.0}
    matrix = np.array(
        [[s.get("skills", {}).get(subj, 5) for subj in subjects] for s in group],
        dtype=float,
    )
    stats: dict = {}
    for j, subj in enumerate(subjects):
        col = matrix[:, j]
        stats[subj] = {
            "mean": round(float(col.mean()), 2),
            "min": float(col.min()),
            "max": float(col.max()),
            "range": float(col.max() - col.min()),
        }

    # Diversity score: average range across subjects (higher = more complementary)
    ranges = [stats[s]["range"] for s in subjects]
    diversity = round(float(np.mean(ranges)), 2) if ranges else 0.0

    return {"subjects": stats, "diversity_score": diversity}
