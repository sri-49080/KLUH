#!/usr/bin/env python3
"""
Run Demo — Study Group Formation
=================================
Standalone script that loads the sample student dataset, runs the clustering
pipeline, prints the formed groups to the terminal, and writes a Markdown
report to ``demo/group_report_output.md``.

Usage:
    python demo/run_demo.py
    python demo/run_demo.py --method agglomerative --size 3
"""

from __future__ import annotations

import argparse
import asyncio
import os
import sys

# Ensure project root is on the path so relative imports resolve
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from demo.demo_data import DEMO_STUDENTS, SUBJECTS           # noqa: E402  # type: ignore[import-not-found]
from agents.study_group_agent import StudyGroupAgent          # noqa: E402  # type: ignore[import-not-found]


async def main(method: str = "kmeans", target_size: int = 4) -> None:
    agent = StudyGroupAgent()

    payload = {
        "students": DEMO_STUDENTS,
        "subjects": SUBJECTS,
        "target_size": target_size,
        "method": method,
    }

    result = await agent.run(payload)

    # ── Pretty-print to terminal ─────────────────────────────────────
    print("\n" + "=" * 70)
    print(result["response"])
    print("=" * 70)

    # ── Write the full report to a file ──────────────────────────────
    report_path = os.path.join(os.path.dirname(__file__), "group_report_output.md")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(result["report"])
    print(f"\n✅ Full report written to {report_path}")

    # ── Also print the full report ───────────────────────────────────
    print("\n" + result["report"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Study Group Formation Demo")
    parser.add_argument(
        "--method", choices=["kmeans", "agglomerative"], default="kmeans",
        help="Clustering algorithm to use (default: kmeans)",
    )
    parser.add_argument(
        "--size", type=int, default=4,
        help="Target group size (default: 4)",
    )
    args = parser.parse_args()
    asyncio.run(main(method=args.method, target_size=args.size))
