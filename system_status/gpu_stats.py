from dataclasses import dataclass


@dataclass(frozen=True)
class GpuStats:
    utilization: str
    vram: str
