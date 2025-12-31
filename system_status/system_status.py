from system_status.cpu_stats import CpuStats
from system_status.gpu_usage_provider import GpuUsageProvider
from system_status.ram_stats import RamStats
from system_status.ram_usage_provider import RamUsageProvider
from system_status.status_formatter import StatusFormatter
from system_status.cpu_usage_provider import CpuUsageProvider


class SystemStatus:
    def __init__(
        self,
        cpu_provider: CpuUsageProvider,
        ram_provider: RamUsageProvider,
        gpu_provider: GpuUsageProvider,
        formatter: StatusFormatter,
    ) -> None:
        self._cpu_provider = cpu_provider
        self._ram_provider = ram_provider
        self._gpu_provider = gpu_provider
        self._formatter = formatter

    def render(self) -> str:
        cpu_usage = self._cpu_provider.usage()
        ram_usage = self._ram_provider.usage()
        gpu_stats = self._gpu_provider.usage()

        cpu_stats = CpuStats(usage_pct=cpu_usage)
        if ram_usage is not None:
            used_mib, total_mib, pct = ram_usage
            ram_stats = RamStats(used_mib=used_mib, total_mib=total_mib, usage_pct=pct)
        else:
            ram_stats = RamStats(used_mib=None, total_mib=None, usage_pct=None)

        return self._formatter.format(cpu_stats, ram_stats, gpu_stats)
