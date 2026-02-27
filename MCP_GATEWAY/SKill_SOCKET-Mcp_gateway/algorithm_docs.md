# Algorithm Documentation — Study Group Formation Agent

## Overview

The Study Group Formation Agent automatically creates balanced study groups
from a set of students, maximising **complementary skill coverage** so every
student can both teach and learn from their peers.

---

## 1. Student Skill Profiling

Each student is represented as a **skill vector** of length *S* (one dimension
per subject, e.g. Math, Science, English, Programming, Art, History).

| Student       | Math | Science | English | Programming | Art | History |
|---------------|------|---------|---------|-------------|-----|---------|
| Alice Chen    | 9    | 7       | 4       | 8           | 2   | 5       |
| David Kim     | 3    | 4       | 7       | 2           | 9   | 8       |

All vectors are **min-max normalised** to [0, 1] before clustering so that
no single subject dominates the distance metric.

---

## 2. Clustering Algorithms

### 2.1 K-Means Clustering

**How it works:**
1. Randomly initialise *k* cluster centroids (one per desired group).
2. Assign each student to the nearest centroid (Euclidean distance).
3. Recompute each centroid as the mean of its assigned students.
4. Repeat steps 2-3 until convergence (or max iterations).

**Strengths:** Fast (O(n·k·i)), deterministic with fixed seed, works well
for roughly equal-sized groups.

**Parameters used:**
- `n_clusters` = ceil(n_students / target_size)
- `n_init = 10` (best of 10 random starts)
- `random_state = 42` (reproducibility)

### 2.2 Agglomerative (Hierarchical) Clustering

**How it works:**
1. Start with each student as its own cluster.
2. Repeatedly merge the two closest clusters using **Ward's linkage**
   (minimises the total within-cluster variance at each merge).
3. Stop when exactly *k* clusters remain.

**Strengths:** Deterministic, produces a hierarchy (dendrogram) of groupings,
robust to outliers.

**Parameters used:**
- `n_clusters` = ceil(n_students / target_size)
- `linkage = "ward"` (variance minimisation)

---

## 3. Complementary Matching (Rebalancing)

Raw clustering tends to group **similar** students together (since K-Means
minimises intra-cluster distance). For study groups, we want the opposite:
**diverse** groups where each member's strengths compensate for others'
weaknesses.

### Greedy Complementary Assignment Algorithm

```
Input : students[], skill_vectors[], n_groups, target_size
Output: groups[][]

1. Sort students by polarisation = max(scores) − min(scores), descending.
   → Specialists (high polarisation) are placed first.

2. For each student in sorted order:
   a. Identify the student's strongest subject (argmax of their vector).
   b. For each group that is not yet full (< target_size + 1):
      – Compute the group's current aggregate score on the student's
        strongest subject.
      – Pick the group with the LOWEST aggregate on that subject.
   c. Assign the student to that group and update the group's aggregate.
```

**Intuition:** A math specialist is assigned to the group that currently
has the *least* math capability, ensuring their strength fills a gap.

### Why Specialists First?

Placing highly polarised students first gives them the widest choice of
groups. Well-rounded students (low polarisation) are more flexible and
can be placed later without compromising group quality.

---

## 4. Group Quality Metrics

### Diversity Score (per group)
For each subject, compute `range = max(score) − min(score)` within
the group. The **Diversity Score** is the mean of these ranges across
all subjects.

- **High score (>6):** Strong complementarity — members cover each
  other's weak spots.
- **Medium score (4-6):** Reasonable diversity.
- **Low score (<4):** Members are too similar; learning opportunities
  are limited.

### Overall Complementarity Score
Average of all groups' diversity scores. Used to compare different
algorithm/target-size configurations.

---

## 5. Configuration Guide

| Parameter        | Default        | Effect                                         |
|------------------|----------------|-------------------------------------------------|
| `method`         | `"kmeans"`     | `"kmeans"` or `"agglomerative"`                 |
| `target_size`    | `4`            | Ideal group size; actual may be ±1              |
| `n_groups`       | auto           | Defaults to ceil(n_students / target_size)      |
| `random_state`   | `42`           | K-Means seed for reproducibility                |

### Choosing Between Algorithms

| Scenario                         | Recommendation      |
|----------------------------------|----------------------|
| Large class (>50 students)       | K-Means (faster)     |
| Small class (<20 students)       | Agglomerative        |
| Need reproducibility             | K-Means (seeded)     |
| Want hierarchical view           | Agglomerative        |

---

## 6. Example Output

```
Group 1 (4 members) — Diversity Score: 7.33/10
| Student       | Math | Science | English | Programming | Art | History |
|---------------|------|---------|---------|-------------|-----|---------|
| Alice Chen    | 9    | 7       | 4       | 8           | 2   | 5       |
| David Kim     | 3    | 4       | 7       | 2           | 9   | 8       |
| Grace Patel   | 7    | 10      | 5       | 6           | 4   | 2       |
| Karen Singh   | 3    | 4       | 9       | 3           | 6   | 9       |
```

Every subject has at least one high scorer and at least one learner,
creating natural teacher–learner pairings within the group.
