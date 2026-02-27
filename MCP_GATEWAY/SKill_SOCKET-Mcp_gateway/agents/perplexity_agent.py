class PerplexityAgent:
    """Answers questions using web search results + LLM synthesis."""

    def __init__(self, llm_client, tool_registry):
        self.llm_client = llm_client
        self.websearch_tool = tool_registry.get("web_search")

    async def run(self, query: str) -> dict:
        search_results = await self.websearch_tool(query)

        results = search_results.get("results", [])
        if not results:
            return {
                "answer": "Sorry, I couldn't find relevant information online.",
                "sources": [],
            }

        context = "\n\n".join(
            f"Source [{i + 1}]: {r['content']} (URL: {r['url']})"
            for i, r in enumerate(results)
        )

        prompt = (
            f'User\'s question: "{query}"\n\n'
            f"Context:\n{context}\n\n"
            "Based only on the provided context, write a comprehensive answer. "
            "Cite sources using the format [1], [2], etc."
        )

        answer = await self.llm_client.generate_text(prompt)

        # Deduplicate sources by URL
        seen: dict[str, dict] = {}
        for r in results:
            if r["url"] not in seen:
                seen[r["url"]] = {"url": r["url"], "title": r.get("title", "")}

        return {"answer": answer, "sources": list(seen.values())}
