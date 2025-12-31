#!/usr/bin/env python3

import os
import sys


def _ensure_import_path() -> None:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    candidate_paths = [
        current_dir,
        os.path.abspath(os.path.join(current_dir, "..", "lib")),
        os.path.expanduser("~/.local/lib"),
    ]
    for path in candidate_paths:
        if path and path not in sys.path:
            sys.path.insert(0, path)


def main() -> int:
    _ensure_import_path()
    from system_status.__main__ import main as status_main

    return status_main()


if __name__ == "__main__":
    raise SystemExit(main())
