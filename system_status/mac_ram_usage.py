import re
import subprocess
from typing import Optional, Tuple

from system_status.utils import run_command


class MacRamUsage:
    def usage(self) -> Optional[Tuple[int, int, int]]:
        try:
            total_bytes = int(run_command(["sysctl", "-n", "hw.memsize"]))
            vm_stat = run_command(["vm_stat"])
        except (OSError, subprocess.CalledProcessError, ValueError):
            return None

        page_size_match = re.search(r"page size of (\d+) bytes", vm_stat)
        page_size = int(page_size_match.group(1)) if page_size_match else 4096

        pages = {}
        for line in vm_stat.splitlines():
            if ":" not in line:
                continue
            key, value = line.split(":", 1)
            pages[key.strip()] = int(re.sub(r"\D", "", value))

        free_pages = pages.get("Pages free", 0) + pages.get("Pages speculative", 0)
        free_bytes = free_pages * page_size
        used_bytes = max(0, total_bytes - free_bytes)
        total_mib = total_bytes // (1024 * 1024)
        used_mib = used_bytes // (1024 * 1024)
        pct = int(used_mib * 100 / total_mib) if total_mib else 0
        return used_mib, total_mib, pct
