import os
import httpx  # type: ignore[import-untyped]
class CerebrasClient:
    """LLM client that communicates with the Cerebras API."""

    def __init__(self):
        api_key = os.getenv("CEREBRAS_API_KEY")
        if not api_key:
            raise RuntimeError("CEREBRAS_API_KEY is not set in the environment variables.")
        self.base_url = "https://api.cerebras.ai/v1"
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        }

    async def generate_text(self, prompt: str, temperature: float = 0.5) -> str:
        """Send a prompt to the Cerebras chat-completions endpoint and return the text."""
        payload = {
            "model": "llama3.1-8b",
            "messages": [{"role": "user", "content": prompt}],
            "temperature": temperature,
            "max_tokens": 2000,
        }
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    f"{self.base_url}/chat/completions",
                    headers=self.headers,
                    json=payload,
                )
                response.raise_for_status()
                data = response.json()
                return data["choices"][0]["message"]["content"]
        except httpx.HTTPError as exc:
            print(f"Cerebras API Error: {exc}")
            raise RuntimeError("Failed to generate text from Cerebras API.") from exc
