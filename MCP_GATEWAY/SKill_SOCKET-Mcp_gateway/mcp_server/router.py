import json
import re


class MCPRouter:
    """Routes incoming queries to the appropriate agent using LLM-based classification."""

    def __init__(self, llm_client, agents: dict):
        self.llm_client = llm_client
        self.agents = agents

    async def route(self, query: str) -> dict:
        print(f'MCP Router received query: "{query}"')

        agent_descriptions = (
            "- perplexity: Answers specific questions using web search. "
            "Use for facts, definitions, current events, or general knowledge questions.\n"
            "- roadmap: Generates a detailed learning plan for a topic. "
            'Use for "how to learn X", "roadmap for Y", "study plan", "learning path".\n'
            "- skillmatch: Finds users with complementary skills for skill exchange. "
            'Use for ANY query mentioning skills like "I offer X", "I need Y", '
            '"I can teach Z", "I want to learn W", "find users", "match me", '
            '"skill exchange", "connect me".\n'
            "- studygroup: Forms optimal study groups among students based on "
            "complementary academic strengths and weaknesses using clustering algorithms. "
            'Use for "form study groups", "create teams", "group students", '
            '"study group", "team formation", "collaborative learning groups".'
        )

        prompt = (
            "You are an intelligent router. Select the best agent for the user's query.\n\n"
            f"Available agents:\n{agent_descriptions}\n\n"
            f'User query: "{query}"\n\n'
            'Respond with a JSON object containing "agent" (the agent\'s name) '
            'and "input" (the query for that agent).'
        )

        response_str = await self.llm_client.generate_text(prompt, 0.1)

        try:
            json_match = re.search(r"\{[\s\S]*\}", response_str)
            if not json_match:
                raise ValueError("LLM did not return valid JSON for routing.")
            decision = json.loads(json_match.group(0))
            print(f"AI routing decision: {decision}")

            agent_name = decision.get("agent", "")
            agent_to_run = self.agents.get(agent_name)
            if agent_to_run is None:
                raise ValueError(f"AI chose an invalid agent: {agent_name}")

            result = await agent_to_run.run(decision.get("input", query))
            return {"agentUsed": agent_name, "result": result}

        except Exception as exc:
            print(f"MCP Routing failed: {exc}  — Falling back to perplexity agent.")
            fallback = await self.agents["perplexity"].run(query)
            return {"agentUsed": "perplexity (fallback)", "result": fallback}
