from tools.websearch import web_search


class ToolRegistry:
    """Simple registry that maps tool names to callable functions."""

    def __init__(self):
        self.tools: dict = {}
        self._register_default_tools()

    def _register_default_tools(self):
        self.register("web_search", web_search)

    def register(self, name: str, func):
        self.tools[name] = func

    def get(self, name: str):
        if name not in self.tools:
            raise KeyError(f'Tool "{name}" not found.')
        return self.tools[name]
