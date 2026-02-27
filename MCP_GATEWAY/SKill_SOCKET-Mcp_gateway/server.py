"""
Skill Socket MCP Gateway — Python Edition
==========================================
FastAPI server that routes incoming queries to the appropriate agent.
"""

import os
import sys
import time
from contextlib import asynccontextmanager

# Ensure the project root is on sys.path for local imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from dotenv import load_dotenv  # type: ignore[import-untyped]
from fastapi import FastAPI, HTTPException  # type: ignore[import-untyped]
from fastapi.middleware.cors import CORSMiddleware  # type: ignore[import-untyped]
from pydantic import BaseModel  # type: ignore[import-untyped]

load_dotenv()

from mcp_server.cerebras_client import CerebrasClient  # type: ignore[import-not-found]
from mcp_server.tool_registry import ToolRegistry  # type: ignore[import-not-found]
from mcp_server.router import MCPRouter  # type: ignore[import-not-found]
from agents.perplexity_agent import PerplexityAgent  # type: ignore[import-not-found]
from agents.roadmap_agent import RoadmapAgent  # type: ignore[import-not-found]
from agents.skill_match_agent import SkillMatchAgent  # type: ignore[import-not-found]
from agents.study_group_agent import StudyGroupAgent  # type: ignore[import-not-found]


# ── application setup ────────────────────────────────────────────────────────
_start_time = time.time()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialise shared singletons once at startup."""
    llm = CerebrasClient()
    tools = ToolRegistry()

    perplexity = PerplexityAgent(llm, tools)
    roadmap = RoadmapAgent(llm, tools)
    skillmatch = SkillMatchAgent(llm, tools)
    studygroup = StudyGroupAgent(llm, tools)

    router = MCPRouter(llm, {
        "perplexity": perplexity,
        "roadmap": roadmap,
        "skillmatch": skillmatch,
        "studygroup": studygroup,
    })

    app.state.router = router
    print("🚀 Skill Socket MCP Gateway (Python) is ready")
    yield


app = FastAPI(
    title="Skill Socket MCP Gateway",
    version="2.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── request / response models ────────────────────────────────────────────────

class InvokeRequest(BaseModel):
    query: str


# ── endpoints ────────────────────────────────────────────────────────────────

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "uptime": round(float(time.time() - _start_time), 2),
        "service": "Skill Socket MCP Gateway (Python)",
    }


@app.post("/mcp/invoke")
async def mcp_invoke(body: InvokeRequest):
    if not body.query:
        raise HTTPException(status_code=400, detail='A "query" is required.')
    try:
        result = await app.state.router.route(body.query)
        return result
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


# ── entrypoint ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    import uvicorn  # type: ignore[import-untyped]

    port = int(os.getenv("PORT", "8000"))
    uvicorn.run("server:app", host="0.0.0.0", port=port, reload=True)
