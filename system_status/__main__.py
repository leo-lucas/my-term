from system_status.provider_factory import ProviderFactory
from system_status.status_formatter import StatusFormatter
from system_status.system_status import SystemStatus


def main() -> int:
    factory = ProviderFactory()
    status = SystemStatus(
        cpu_provider=factory.cpu_provider(),
        ram_provider=factory.ram_provider(),
        gpu_provider=factory.gpu_provider(),
        formatter=StatusFormatter(),
    )
    print(status.render())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
