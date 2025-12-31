from typing import Protocol

from system_status.gpu_stats import GpuStats


class GpuUsageProvider(Protocol):
    def usage(self) -> GpuStats:
        raise NotImplementedError
