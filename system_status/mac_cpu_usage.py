import os
import subprocess
from typing import Optional

from system_status.utils import run_command


class MacCpuUsage:
    def usage(self) -> Optional[float]:
        try:
            output = run_command(["ps", "-A", "-o", "%cpu="])
            values = [float(value) for value in output.split() if value.strip()]
        except (OSError, subprocess.CalledProcessError, ValueError):
            return None

        if not values:
            return None
        cores = os.cpu_count() or 1
        usage = sum(values) / cores
        return max(0.0, min(100.0, usage))
