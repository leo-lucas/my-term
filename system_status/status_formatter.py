from system_status.cpu_stats import CpuStats
from system_status.gpu_stats import GpuStats
from system_status.ram_stats import RamStats


class StatusFormatter:
    def format(self, cpu: CpuStats, ram: RamStats, gpu: GpuStats) -> str:
        cpu_display = f"{cpu.usage_pct:.1f}%" if cpu.usage_pct is not None else "N/A"
        if ram.usage_pct is not None and ram.used_mib is not None and ram.total_mib is not None:
            ram_display = f"{ram.usage_pct}% ({ram.used_mib}/{ram.total_mib} MiB)"
        else:
            ram_display = "N/A"
        return f"CPU: {cpu_display} | RAM: {ram_display} | GPU: {gpu.utilization} | VRAM: {gpu.vram}"
