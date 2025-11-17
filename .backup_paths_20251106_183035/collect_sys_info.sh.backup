#!/usr/bin/env bash
# Collects a snapshot of key macOS development environment details.
# Usage: ./scripts/collect_sys_info.sh > sys-info.txt

set -euo pipefail

echo "--- macOS Version ---"
if command -v sw_vers >/dev/null 2>&1; then
  sw_vers
else
  echo "sw_vers not found"
fi

echo
echo "--- CPU Architecture ---"
uname -m

echo
echo "--- PATH Environment Variable ---"
echo "$PATH"

echo
echo "--- Homebrew Packages ---"
if command -v brew >/dev/null 2>&1; then
  brew list
else
  echo "Homebrew not installed"
fi

echo
echo "--- Node.js Version ---"
if command -v node >/dev/null 2>&1; then
  node -v
else
  echo "Node.js not installed"
fi

echo
echo "--- Python Version ---"
if command -v python3 >/dev/null 2>&1; then
  python3 -V
else
  echo "Python 3 not installed"
fi
