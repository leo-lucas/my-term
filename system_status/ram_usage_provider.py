from typing import Optional, Protocol, Tuple


class RamUsageProvider(Protocol):
    def usage(self) -> Optional[Tuple[int, int, int]]:
        raise NotImplementedError
