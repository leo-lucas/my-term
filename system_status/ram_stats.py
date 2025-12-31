from dataclasses import dataclass
from typing import Optional


@dataclass(frozen=True)
class RamStats:
    used_mib: Optional[int]
    total_mib: Optional[int]
    usage_pct: Optional[int]
