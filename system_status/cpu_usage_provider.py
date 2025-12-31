from typing import Optional, Protocol


class CpuUsageProvider(Protocol):
    def usage(self) -> Optional[float]:
        raise NotImplementedError
