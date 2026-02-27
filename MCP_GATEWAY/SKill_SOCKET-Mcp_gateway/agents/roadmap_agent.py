class RoadmapAgent:
    """Generates a step-by-step learning roadmap for any topic."""

    def __init__(self, llm_client, tool_registry):
        self.llm_client = llm_client
        self.websearch_tool = tool_registry.get("web_search")

    async def run(self, topic: str) -> dict:
        print(f'Roadmap Agent started for topic: "{topic}"')

        search_results = await self.websearch_tool(
            f"learning path and key concepts for {topic}"
        )
        results = search_results.get("results", [])
        context = "\n\n".join(f"Source: {r['content']}" for r in results)

        prompt = (
            f'Topic: "Learn {topic}"\n\n'
            f"Context:\n{context}\n\n"
            "Based on the context, generate a detailed, step-by-step learning roadmap "
            "in Markdown. Include stages (Beginner, Intermediate, Advanced) with key "
            "concepts and project ideas."
        )

        roadmap = await self.llm_client.generate_text(prompt, 0.7)
        return {"roadmap": roadmap}
