import os
import httpx  # type: ignore[import-untyped]


async def web_search(query: str) -> dict:
    """Search the web using the Tavily API and return results."""
    api_key = os.getenv("TAVILY_API_KEY")
    if not api_key:
        raise RuntimeError("TAVILY_API_KEY is not set in environment variables.")
    try:
        async with httpx.AsyncClient(timeout=15.0) as client:
            response = await client.post(
                "https://api.tavily.com/search",
                json={
                    "api_key": api_key,
                    "query": query,
                    "search_depth": "advanced",
                    "max_results": 5,
                },
            )
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as exc:
        raise RuntimeError(f"Web search failed. Error: {exc}") from exc
