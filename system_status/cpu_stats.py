from dataclasses import dataclass
from typing import Optional


@dataclass(frozen=True)
class CpuStats:
    usage_pct: Optional[float]
