import sys

from system_status.cpu_usage_provider import CpuUsageProvider
from system_status.gpu_usage_provider import GpuUsageProvider
from system_status.linux_cpu_usage import LinuxCpuUsage
from system_status.linux_ram_usage import LinuxRamUsage
from system_status.mac_cpu_usage import MacCpuUsage
from system_status.mac_ram_usage import MacRamUsage
from system_status.nvidia_gpu_usage import NvidiaGpuUsage
from system_status.ram_usage_provider import RamUsageProvider


class ProviderFactory:
    def cpu_provider(self) -> CpuUsageProvider:
        if sys.platform.startswith("linux"):
            return LinuxCpuUsage()
        if sys.platform == "darwin":
            return MacCpuUsage()
        return LinuxCpuUsage()

    def ram_provider(self) -> RamUsageProvider:
        if sys.platform.startswith("linux"):
            return LinuxRamUsage()
        if sys.platform == "darwin":
            return MacRamUsage()
        return LinuxRamUsage()

    def gpu_provider(self) -> GpuUsageProvider:
        return NvidiaGpuUsage()
