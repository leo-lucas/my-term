import time
from typing import Optional, Tuple


class LinuxCpuUsage:
    def _read_cpu(self) -> Tuple[int, int]:
        with open("/proc/stat", "r", encoding="utf-8") as handle:
            fields = handle.readline().split()
        if len(fields) < 8:
            raise ValueError("/proc/stat não possui dados suficientes")
        values = list(map(int, fields[1:8]))
        idle = values[3] + values[4]
        total = sum(values)
        return idle, total

    def usage(self) -> Optional[float]:
        try:
            idle_1, total_1 = self._read_cpu()
            time.sleep(0.1)
            idle_2, total_2 = self._read_cpu()
        except (OSError, ValueError):
            return None

        idle_delta = idle_2 - idle_1
        total_delta = total_2 - total_1
        if total_delta <= 0:
            return None
        return max(0.0, min(100.0, 100.0 * (1.0 - idle_delta / total_delta)))
