from typing import Optional, Tuple


class LinuxRamUsage:
    def usage(self) -> Optional[Tuple[int, int, int]]:
        try:
            meminfo = {}
            with open("/proc/meminfo", "r", encoding="utf-8") as handle:
                for line in handle:
                    if ":" not in line:
                        continue
                    key, value = line.split(":", 1)
                    meminfo[key.strip()] = value.strip()
            total_kb = int(meminfo["MemTotal"].split()[0])
            available_kb = int(meminfo["MemAvailable"].split()[0])
        except (OSError, KeyError, ValueError):
            return None

        used_kb = max(0, total_kb - available_kb)
        total_mib = total_kb // 1024
        used_mib = used_kb // 1024
        pct = int(used_mib * 100 / total_mib) if total_mib else 0
        return used_mib, total_mib, pct
