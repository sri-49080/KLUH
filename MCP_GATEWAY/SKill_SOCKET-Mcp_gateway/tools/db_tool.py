import os
import httpx  # type: ignore[import-untyped]

BACKEND_API_URL = os.getenv(
    "BACKEND_API_URL", "https://skillsocket-backend.onrender.com"
)


async def find_complementary_users(
    skills_required: list[str] | None = None,
    skills_offered: list[str] | None = None,
) -> list[dict]:
    """Find users with complementary skills via the SkillSocket backend API."""
    skills_required = skills_required or []
    skills_offered = skills_offered or []

    print("🔍 Searching for users via backend API...")
    print(f"   - Want to learn: {skills_required}")
    print(f"   - Can teach:     {skills_offered}")

    required_skill = skills_required[0] if skills_required else ""
    offered_skill = skills_offered[0] if skills_offered else ""

    if not required_skill and not offered_skill:
        print("⚠️  No skills provided")
        return []

    api_url = f"{BACKEND_API_URL}/api/users/match"
    params: dict[str, str] = {}
    if required_skill:
        params["required"] = required_skill
    if offered_skill:
        params["offered"] = offered_skill

    print(f"🌐 Calling API: {api_url}  params={params}")

    try:
        async with httpx.AsyncClient(timeout=8.0) as client:
            response = await client.get(api_url, params=params)
            response.raise_for_status()
            data = response.json()

        if isinstance(data, list):
            print(f"✅ API returned {len(data)} users")
            return data
        print(f"⚠️  API returned unexpected format: {data}")
        return []

    except httpx.TimeoutException:
        raise RuntimeError(
            "Backend API is not accessible. Please check if the backend server is running."
        )
    except httpx.HTTPStatusError as exc:
        raise RuntimeError(
            f"Backend API error: {exc.response.status_code} - {exc.response.reason_phrase}"
        )
    except httpx.HTTPError as exc:
        raise RuntimeError(f"Network error: {exc}")


async def test_connection() -> dict:
    """Test connectivity to the backend API."""
    print("🧪 Testing backend API connectivity...")
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{BACKEND_API_URL}/api/health")
        if response.status_code == 200:
            print("✅ Backend API is accessible")
            data = response.json()
            print(f"📊 API Health: {data}")
            return {"success": True, "apiStatus": data}
        raise RuntimeError(f"API returned status {response.status_code}")
    except Exception as exc:
        print(f"❌ API test failed: {exc}")
        return {"success": False, "error": str(exc)}
