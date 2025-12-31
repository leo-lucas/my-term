import subprocess


def run_command(command: list[str]) -> str:
    return subprocess.check_output(command, text=True).strip()
