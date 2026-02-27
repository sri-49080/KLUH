"""
Demo Student Data
=================
Twenty-four sample students with diverse skill profiles across six academic
subjects.  Each skill is rated on a 1-10 scale (1 = weak, 10 = expert).
"""

SUBJECTS = ["Math", "Science", "English", "Programming", "Art", "History"]

DEMO_STUDENTS: list[dict] = [
    # ── math-strong / art-weak ────────────────────────────
    {"name": "Alice Chen",      "skills": {"Math": 9, "Science": 7, "English": 4, "Programming": 8, "Art": 2, "History": 5}},
    {"name": "Bob Martinez",    "skills": {"Math": 8, "Science": 6, "English": 5, "Programming": 9, "Art": 3, "History": 4}},
    {"name": "Cathy Liu",       "skills": {"Math": 10, "Science": 8, "English": 3, "Programming": 7, "Art": 2, "History": 3}},

    # ── art-strong / math-weak ────────────────────────────
    {"name": "David Kim",       "skills": {"Math": 3, "Science": 4, "English": 7, "Programming": 2, "Art": 9, "History": 8}},
    {"name": "Emma Wilson",     "skills": {"Math": 2, "Science": 5, "English": 8, "Programming": 3, "Art": 10, "History": 7}},
    {"name": "Frank Osei",      "skills": {"Math": 4, "Science": 3, "English": 6, "Programming": 2, "Art": 8, "History": 9}},

    # ── science-strong / history-weak ─────────────────────
    {"name": "Grace Patel",     "skills": {"Math": 7, "Science": 10, "English": 5, "Programming": 6, "Art": 4, "History": 2}},
    {"name": "Henry Zhao",      "skills": {"Math": 6, "Science": 9, "English": 4, "Programming": 8, "Art": 3, "History": 3}},
    {"name": "Isla Nakamura",   "skills": {"Math": 5, "Science": 8, "English": 6, "Programming": 7, "Art": 5, "History": 2}},

    # ── english-strong / programming-weak ─────────────────
    {"name": "Jack Thompson",   "skills": {"Math": 4, "Science": 5, "English": 10, "Programming": 2, "Art": 7, "History": 8}},
    {"name": "Karen Singh",     "skills": {"Math": 3, "Science": 4, "English": 9, "Programming": 3, "Art": 6, "History": 9}},
    {"name": "Leo Andersen",    "skills": {"Math": 5, "Science": 6, "English": 8, "Programming": 2, "Art": 7, "History": 6}},

    # ── programming-strong / english-weak ─────────────────
    {"name": "Mia Johnson",     "skills": {"Math": 8, "Science": 7, "English": 2, "Programming": 10, "Art": 3, "History": 4}},
    {"name": "Noah Brown",      "skills": {"Math": 7, "Science": 8, "English": 3, "Programming": 9, "Art": 2, "History": 5}},
    {"name": "Olivia Dubois",   "skills": {"Math": 6, "Science": 5, "English": 4, "Programming": 8, "Art": 4, "History": 3}},

    # ── history-strong / science-weak ─────────────────────
    {"name": "Peter Rossi",     "skills": {"Math": 4, "Science": 2, "English": 7, "Programming": 3, "Art": 6, "History": 10}},
    {"name": "Quinn O'Brien",   "skills": {"Math": 5, "Science": 3, "English": 8, "Programming": 4, "Art": 5, "History": 9}},
    {"name": "Rita Svensson",   "skills": {"Math": 3, "Science": 2, "English": 6, "Programming": 5, "Art": 7, "History": 8}},

    # ── well-rounded students ─────────────────────────────
    {"name": "Sam Taylor",      "skills": {"Math": 6, "Science": 6, "English": 6, "Programming": 6, "Art": 6, "History": 6}},
    {"name": "Tina Garcia",     "skills": {"Math": 5, "Science": 5, "English": 7, "Programming": 5, "Art": 5, "History": 7}},
    {"name": "Umar Khan",       "skills": {"Math": 7, "Science": 5, "English": 5, "Programming": 7, "Art": 4, "History": 5}},

    # ── polarised specialists ─────────────────────────────
    {"name": "Vera Petrov",     "skills": {"Math": 10, "Science": 9, "English": 2, "Programming": 10, "Art": 1, "History": 2}},
    {"name": "Will Nguyen",     "skills": {"Math": 1, "Science": 2, "English": 9, "Programming": 1, "Art": 10, "History": 9}},
    {"name": "Xena Muller",     "skills": {"Math": 5, "Science": 10, "English": 5, "Programming": 3, "Art": 8, "History": 3}},
]
