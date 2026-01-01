#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/leo-lucas/my-term.git"

temp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$temp_dir"
}
trap cleanup EXIT

git clone "$REPO_URL" "$temp_dir/my-term"

cd "$temp_dir/my-term"
./install.sh
