"""
Study Group Formation Agent
============================
Uses clustering algorithms (K-Means / Agglomerative) to automatically form
optimal study groups among students based on complementary academic strengths
and weaknesses.
"""

from __future__ import annotations

from tools.clustering_tool import form_study_groups, compute_group_stats  # type: ignore[import-not-found]


# Default academic subjects used for profiling
DEFAULT_SUBJECTS = ["Math", "Science", "English", "Programming", "Art", "History"]


class StudyGroupAgent:
    """Agent that receives student data and produces balanced study groups."""

    def __init__(self, llm_client=None, tool_registry=None):
        self.llm_client = llm_client

    async def run(self, query: str | dict) -> dict:
        """Run the study-group formation pipeline.

        ``query`` can be:
        - A **dict** with keys ``students``, optional ``subjects``,
          ``target_size``, and ``method``.
        - A **string** — the agent will use built-in demo data.
        """
        print(f"📚 StudyGroup Agent started")

        # ── parse input ──────────────────────────────────────────────────
        if isinstance(query, dict):
            students = query.get("students", [])
            subjects = query.get("subjects", DEFAULT_SUBJECTS)
            target_size = query.get("target_size", 4)
            method = query.get("method", "kmeans")
        else:
            # When called via text query, use demo data
            from demo.demo_data import DEMO_STUDENTS, SUBJECTS as DEMO_SUBJECTS  # type: ignore[import-not-found]
            students = DEMO_STUDENTS
            subjects = DEMO_SUBJECTS
            target_size = 4
            method = "kmeans"
            print(f"   (using demo dataset with {len(students)} students)")

        if not students:
            return {
                "response": "❌ No student data provided. Please supply a list of students with skill profiles.",
                "groups": [],
                "report": "",
            }

        n_groups = max(1, -(-len(students) // target_size))
        print(f"   Forming {n_groups} groups of ~{target_size} from {len(students)} students  [method={method}]")

        # ── cluster ──────────────────────────────────────────────────────
        groups = form_study_groups(
            students, subjects,
            n_groups=n_groups,
            target_size=target_size,
            method=method,
        )

        # ── build report text ────────────────────────────────────────────
        report_lines: list[str] = []
        report_lines.append("# 📊 Study Group Composition Report\n")
        report_lines.append(f"**Algorithm**: {str(method).title()}  |  "
                            f"**Students**: {len(students)}  |  "
                            f"**Groups**: {len(groups)}  |  "
                            f"**Target size**: {target_size}\n")
        report_lines.append(f"**Subjects evaluated**: {', '.join(subjects)}\n")
        report_lines.append("---\n")

        group_summaries: list[dict] = []

        for i, group in enumerate(groups, 1):
            stats = compute_group_stats(group, subjects)
            report_lines.append(f"## Group {i}  ({len(group)} members)  —  "
                                f"Diversity Score: **{stats['diversity_score']}/10**\n")

            # Member table
            report_lines.append("| Student | " + " | ".join(subjects) + " | Role |")
            report_lines.append("|" + "---|" * (len(subjects) + 2))

            for s in group:
                scores = [str(s["skills"].get(subj, "–")) for subj in subjects]
                strengths = [subj for subj in subjects if s["skills"].get(subj, 0) >= 7]
                role = f"Lead in {', '.join(strengths)}" if strengths else "General Support"
                report_lines.append(f"| {s['name']} | " + " | ".join(scores) + f" | {role} |")

            # Per-subject coverage
            report_lines.append(f"\n**Skill Coverage:**")
            for subj, v in stats["subjects"].items():
                bar_len = int(v["mean"])
                bar = "█" * bar_len + "░" * (10 - bar_len)
                report_lines.append(f"  - {subj}: {bar}  avg {v['mean']}  (range {v['min']:.0f}–{v['max']:.0f})")
            report_lines.append("")

            group_summaries.append({
                "group_id": i,
                "members": [s["name"] for s in group],
                "size": len(group),
                "diversity_score": stats["diversity_score"],
                "stats": stats["subjects"],
            })

        # Overall summary
        avg_div = sum(g["diversity_score"] for g in group_summaries) / len(group_summaries) if group_summaries else 0
        report_lines.append("---\n")
        report_lines.append(f"## 🏆 Overall Complementarity Score: **{avg_div:.2f}/10**\n")
        if avg_div >= 5:
            report_lines.append("✅ Groups are well-balanced with strong complementary skill coverage.\n")
        else:
            report_lines.append("⚠️ Groups have moderate overlap — consider adjusting target group size.\n")

        report_text = "\n".join(report_lines)

        # ── response ─────────────────────────────────────────────────────
        short_summary_parts = []
        for g in group_summaries:
            members = ", ".join(g["members"])
            short_summary_parts.append(
                f"**Group {g['group_id']}** ({g['size']} members, diversity {g['diversity_score']}): {members}"
            )
        short_summary = "\n".join(short_summary_parts)

        response = (
            f"📚 **Study Groups Formed Successfully!**\n\n"
            f"Created **{len(groups)} groups** from **{len(students)} students** "
            f"using **{str(method).title()} clustering**.\n\n"
            f"{short_summary}\n\n"
            f"🏆 **Overall Complementarity Score: {avg_div:.2f}/10**\n\n"
            f"Each group has been optimised for maximum skill diversity, "
            f"ensuring every student can both teach and learn from their peers."
        )

        return {
            "response": response,
            "groups": group_summaries,
            "report": report_text,
            "studentCount": len(students),
            "groupCount": len(groups),
            "method": method,
            "averageDiversity": round(float(avg_div), 2),
        }
