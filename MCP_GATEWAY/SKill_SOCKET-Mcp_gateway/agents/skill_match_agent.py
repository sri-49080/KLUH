import json
import re
import asyncio

from tools.db_tool import find_complementary_users, test_connection  # type: ignore[import-not-found]


class SkillMatchAgent:
    """Finds users with complementary skills for peer-to-peer skill exchange."""

    COMMON_SKILLS = [
        "javascript", "python", "java", "react", "flutter", "dart", "node.js",
        "nodejs", "angular", "vue", "typescript", "c++", "c#", "php", "ruby",
        "go", "kotlin", "swift", "html", "css", "sql", "mongodb", "mysql",
        "postgresql", "docker", "kubernetes", "aws", "azure", "git", "linux",
        "machine learning", "ai", "data science", "spring boot", "django",
        "express", "laravel",
    ]

    def __init__(self, llm_client, tool_registry):
        self.llm_client = llm_client

    async def run(self, query: str) -> dict:
        print(f'SkillMatch Agent started with query: "{query}"')

        try:
            # 1. Test API connection
            print("🔌 Testing backend API connection...")
            conn = await test_connection()
            if not conn.get("success"):
                raise RuntimeError(f"Backend API connection failed: {conn.get('error')}")
            print("✅ Backend API is accessible!")

            # 2. Extract skills using LLM
            extraction_prompt = self._build_extraction_prompt(query)
            raw = await self.llm_client.generate_text(extraction_prompt, 0.1)
            print(f"Raw LLM extraction result: {raw}")
            skills = self._parse_skills(raw, query)
            print(f"Extracted skills: {skills}")

            # 3. Search for complementary users (with 8 s timeout)
            print("Searching for matching users...")
            matched_users = await asyncio.wait_for(
                find_complementary_users(
                    skills.get("skillsRequired", []),
                    skills.get("skillsOffered", []),
                ),
                timeout=8.0,
            )
            print(f"Found {len(matched_users)} matching users")

            # 4. Build response
            response = self._format_response(skills, matched_users)
            return {
                "matches": matched_users,
                "response": response,
                "query": {
                    "skillsRequired": skills.get("skillsRequired", []),
                    "skillsOffered": skills.get("skillsOffered", []),
                },
                "matchCount": len(matched_users),
            }

        except Exception as exc:
            print(f"Error in SkillMatch Agent: {exc}")
            return self._error_response(str(exc))

    # ── helpers ───────────────────────────────────────────────────────────

    @staticmethod
    def _build_extraction_prompt(query: str) -> str:
        return (
            "Analyze this user query and extract the skills they need to learn "
            "and the skills they can offer to teach others.\n"
            "Return ONLY a valid JSON object with two arrays.\n\n"
            f'Query: "{query}"\n\n'
            "Instructions:\n"
            '- "skillsRequired" = skills the user wants to learn\n'
            '- "skillsOffered"  = skills the user can teach\n'
            "- Use common skill names like JavaScript, Python, React, Flutter, etc.\n\n"
            "Return only the JSON, no explanation:"
        )

    def _parse_skills(self, raw: str, query: str) -> dict:
        """Try JSON parsing, then regex, then fallback heuristic."""
        try:
            return json.loads(raw.strip())
        except json.JSONDecodeError:
            pass
        match = re.search(r"\{[\s\S]*\}", raw)
        if match:
            try:
                return json.loads(match.group(0))
            except json.JSONDecodeError:
                pass
        return self._extract_skills_fallback(query)

    def _extract_skills_fallback(self, query: str) -> dict:
        lower = query.lower()
        skills_required: list[str] = []
        skills_offered: list[str] = []

        learn_patterns = ["learn", "need", "want to learn", "studying", "learning"]
        teach_patterns = ["teach", "offer", "know", "expert in", "can help with"]

        for pattern in learn_patterns:
            if pattern in lower:
                for skill in self.COMMON_SKILLS:
                    if skill in lower and skill not in skills_required:
                        skills_required.append(skill)

        for pattern in teach_patterns:
            if pattern in lower:
                for skill in self.COMMON_SKILLS:
                    if skill in lower and skill not in skills_offered:
                        skills_offered.append(skill)

        if not skills_required and not skills_offered:
            if "flutter" in lower:
                skills_required.append("Flutter")
            if "java" in lower:
                skills_offered.append("Java")

        return {"skillsRequired": skills_required, "skillsOffered": skills_offered}

    @staticmethod
    def _format_response(skills: dict, matched_users: list[dict]) -> str:
        req = ", ".join(skills.get("skillsRequired", [])) or "Not specified"
        off = ", ".join(skills.get("skillsOffered", [])) or "Not specified"

        if matched_users:
            lines = []
            for i, u in enumerate(matched_users, 1):
                name = u.get("name") or f"{u.get('firstName', '')} {u.get('lastName', '')}".strip() or "User"
                offered = ", ".join(u.get("skillsOffered", [])) or "Not specified"
                needed = ", ".join(u.get("skillsRequired", [])) or "Not specified"
                loc = u.get("location", "Not specified")
                lines.append(
                    f"{i}. **{name}** ({u.get('email', '')})\n"
                    f"   • 💡 **Offers**: {offered}\n"
                    f"   • 🎯 **Needs**: {needed}\n"
                    f"   • 📍 **Location**: {loc}"
                )
            users_data = "\n\n".join(lines)
            n = len(matched_users)
            return (
                f"🎯 **Perfect! I found {n} user{'s' if n > 1 else ''} "
                f"with complementary skills:**\n\n"
                f"**Your Profile:**\n• 📚 **Want to learn**: {req}\n"
                f"• 💡 **Can teach**: {off}\n\n"
                f"**Recommended Connections:**\n\n{users_data}\n\n"
                "💡 **Why these matches work:**\n"
                "These users offer skills you want to learn and need skills "
                "you can teach — creating perfect skill exchange opportunities!\n\n"
                "**Next Steps:**\n"
                "1. Reach out to these users through the platform\n"
                "2. Propose a skill exchange arrangement\n"
                "3. Set up learning sessions or mentorship\n"
                "4. Build lasting professional connections"
            )

        return (
            f"🔍 **No exact matches found, but don't worry!**\n\n"
            f"**Your Skills Profile:**\n• 📚 **Want to learn**: {req}\n"
            f"• 💡 **Can teach**: {off}\n\n"
            "**Suggestions to find skill partners:**\n\n"
            "1. **Broaden your search**: Consider related skills\n"
            "2. **Update your profile**: Make sure your skills are clearly listed\n"
            "3. **Be proactive**: Reach out to users with similar interests\n"
            "4. **Join communities**: Look for study groups or skill-sharing circles\n"
            "5. **Check back later**: New users join regularly!"
        )

    @staticmethod
    def _error_response(message: str) -> dict:
        if "timeout" in message.lower() or "buffering" in message.lower():
            error_msg = "Database connection timed out"
            suggestions = [
                "The database server might be slow or unavailable",
                "Check your internet connection",
                "Try again in a few minutes",
                "Contact support if the issue persists",
            ]
        elif "connection" in message.lower():
            error_msg = "Could not connect to the database"
            suggestions = [
                "Check if the database service is running",
                "Verify your internet connection",
                "Try again later",
            ]
        else:
            error_msg = message
            suggestions = [
                "Check your internet connection",
                "Try again in a few moments",
                "Use simpler skill names like 'JavaScript', 'Python', 'React'",
            ]

        bullets = "\n".join(f"• {s}" for s in suggestions)
        return {
            "error": message,
            "response": (
                f"❌ **Database Connection Issue**\n\n"
                f"**Problem**: {error_msg}\n\n"
                f"**What you can try:**\n{bullets}\n\n"
                "**Alternative**: While we fix this, try asking general questions "
                "about skills or learning paths!"
            ),
            "matches": [],
            "matchCount": 0,
        }
