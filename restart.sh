#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

echo "🗑 Removing incrmntal-challenge container..."
"${SCRIPT_DIR}/delete.sh"

echo "♻️ Recreating database and applying migrations..."
"${SCRIPT_DIR}/run.sh"

echo "✅ Done"
