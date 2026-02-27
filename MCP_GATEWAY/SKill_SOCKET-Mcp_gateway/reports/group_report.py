"""
Group Report Generator
======================
Utility module for generating standalone Markdown reports from
study-group formation results.
"""

from __future__ import annotations

from datetime import datetime


def generate_report(
    groups: list[list[dict]],
    subjects: list[str],
    method: str = "kmeans",
    target_size: int = 4,
) -> str:
    """Build a complete Markdown report for a set of study groups.

    Parameters
    ----------
    groups      : list of groups, each group is a list of student dicts.
    subjects    : ordered list of subject names.
    method      : clustering algorithm name.
    target_size : ideal group size.

    Returns
    -------
    A Markdown-formatted string.
    """
    from tools.clustering_tool import compute_group_stats  # type: ignore[import-not-found]

    total_students = sum(len(g) for g in groups)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    lines: list[str] = []
    lines.append("# 📊 Study Group Composition Report\n")
    lines.append(f"*Generated on {timestamp}*\n")
    lines.append(f"| Metric | Value |")
    lines.append(f"|--------|-------|")
    lines.append(f"| Algorithm | {method.title()} |")
    lines.append(f"| Total students | {total_students} |")
    lines.append(f"| Groups formed | {len(groups)} |")
    lines.append(f"| Target group size | {target_size} |")
    lines.append(f"| Subjects | {', '.join(subjects)} |")
    lines.append("")
    lines.append("---\n")

    diversity_scores: list[float] = []

    for i, group in enumerate(groups, 1):
        stats = compute_group_stats(group, subjects)
        diversity_scores.append(stats["diversity_score"])

        lines.append(f"## Group {i}  ({len(group)} members)")
        lines.append(f"**Diversity Score:** {stats['diversity_score']}/10\n")

        # Member table
        header = "| Student | " + " | ".join(subjects) + " | Strengths | Role |"
        sep = "|" + "---|" * (len(subjects) + 3)
        lines.append(header)
        lines.append(sep)

        for s in group:
            scores = [str(s["skills"].get(subj, "–")) for subj in subjects]
            strengths = [subj for subj in subjects if s["skills"].get(subj, 0) >= 7]
            weaknesses = [subj for subj in subjects if s["skills"].get(subj, 0) <= 3]
            role = f"Lead: {', '.join(strengths)}" if strengths else "General Support"
            lines.append(
                f"| {s['name']} | " + " | ".join(scores) +
                f" | {', '.join(strengths) or '–'} | {role} |"
            )

        lines.append("")

        # Coverage bars
        lines.append("### Skill Coverage\n")
        for subj, v in stats["subjects"].items():
            bar_filled = int(round(v["mean"]))
            bar = "█" * bar_filled + "░" * (10 - bar_filled)
            lines.append(
                f"- **{subj}**: `{bar}` avg **{v['mean']}** "
                f"(min {v['min']:.0f} → max {v['max']:.0f})"
            )
        lines.append("")

    # ── Overall analysis ──────────────────────────────────────────────
    avg_diversity = sum(diversity_scores) / len(diversity_scores) if diversity_scores else 0
    lines.append("---\n")
    lines.append(f"## 🏆 Overall Analysis\n")
    lines.append(f"- **Average Complementarity Score**: {avg_diversity:.2f}/10")
    lines.append(f"- **Most diverse group**: Group "
                 f"{diversity_scores.index(max(diversity_scores)) + 1 if diversity_scores else '–'} "
                 f"({max(diversity_scores) if diversity_scores else 0}/10)")
    lines.append(f"- **Least diverse group**: Group "
                 f"{diversity_scores.index(min(diversity_scores)) + 1 if diversity_scores else '–'} "
                 f"({min(diversity_scores) if diversity_scores else 0}/10)")
    lines.append("")

    if avg_diversity >= 6:
        lines.append("✅ **Excellent** — Groups are highly complementary. "
                      "Students will benefit from strong peer-to-peer learning.")
    elif avg_diversity >= 4:
        lines.append("👍 **Good** — Groups have solid diversity. "
                      "Consider minor adjustments for optimal balance.")
    else:
        lines.append("⚠️ **Fair** — Some groups lack diversity. "
                      "Try a smaller target group size or a different algorithm.")

    return "\n".join(lines)
