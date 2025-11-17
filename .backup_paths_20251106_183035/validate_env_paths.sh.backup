#!/usr/bin/env bash

set -euo pipefail

REPO="${REPO:-$PWD}"

REQ=( "env/macos.env" "env/vps.env" "connect/docker-compose.yml" )

for f in "${REQ[@]}"; do [ -f "$REPO/$f" ] || { echo "ERRO: falta $f"; exit 1; }; done

echo "✅ env/paths validados"

