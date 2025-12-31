import shutil
import subprocess

from system_status.gpu_stats import GpuStats
from system_status.utils import run_command


class NvidiaGpuUsage:
    def usage(self) -> GpuStats:
        if not shutil.which("nvidia-smi"):
            return GpuStats(utilization="N/A", vram="N/A")
        try:
            output = run_command(
                [
                    "nvidia-smi",
                    "--query-gpu=utilization.gpu,memory.used,memory.total",
                    "--format=csv,noheader,nounits",
                ]
            )
            parts = [part.strip() for part in output.split(",")]
            if len(parts) < 3:
                return GpuStats(utilization="N/A", vram="N/A")
        except (OSError, subprocess.CalledProcessError):
            return GpuStats(utilization="N/A", vram="N/A")

        gpu_util = f"{parts[0]}%"
        vram_used = f"{parts[1]}MiB"
        vram_total = f"{parts[2]}MiB"
        return GpuStats(utilization=gpu_util, vram=f"{vram_used}/{vram_total}")
