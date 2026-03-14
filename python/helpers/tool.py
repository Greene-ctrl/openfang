from dataclasses import dataclass
from typing import Any, Optional

@dataclass
class Response:
    message: str
    break_loop: bool = False
    metadata: Optional[Any] = None

class Tool:
    async def execute(self, **kwargs) -> Response:
        raise NotImplementedError("Subclasses must implement execute")
