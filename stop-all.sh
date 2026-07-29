#!/usr/bin/env bash
# Stops all course demos started with start-all.sh.
#
# Usage:
#   ./stop-all.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DEMOS=(
  "SYS-03 - Enterprise Authentication:${SCRIPT_DIR}/SYS-03-integrating-enterprise-authentication/manage_login/demo"
  "SYS-04 - Advanced Functions:${SCRIPT_DIR}/SYS-04-advanced-functions/manage_functions/demo"
  "SYS-06 - MCP Server Integration:${SCRIPT_DIR}/SYS-06-mcp-server-integration/manage-server-mcp/demo"
)

for entry in "${DEMOS[@]}"; do
  name="${entry%%:*}"
  dir="${entry#*:}"
  echo "-- Stopping ${name} --"
  (cd "${dir}" && docker compose down)
  echo
done

echo "All demos stopped."
