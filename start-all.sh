#!/usr/bin/env bash
# Starts all course demos (SYS-03, SYS-04, SYS-06) in the background, each on
# its own port, so you don't have to `cd` into each demo/ folder one by one.
#
# Usage:
#   ./start-all.sh
#
# Then open index.html (the demo hub) to jump between them.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SYS03_DIR="$SCRIPT_DIR/SYS-03-integrating-enterprise-authentication/manage_login/demo"
SYS04_DIR="$SCRIPT_DIR/SYS-04-advanced-functions/manage_functions/demo"
SYS06_DIR="$SCRIPT_DIR/SYS-06-mcp-server-integration/manage-server-mcp/demo"

echo "Starting all course demos in the background (this can take a while on first run)..."
echo

start_demo() {
  local dir="$1"
  local name="$2"
  local port="$3"
  local env_file="$4"
  local env_content="$5"

  echo "-- ${name} (http://localhost:${port}) --"

  if [ ! -f "${dir}/${env_file}" ]; then
    if [ -n "${env_content}" ]; then
      echo "  Creating missing ${env_file} with default values..."
      printf '%s\n' "${env_content}" > "${dir}/${env_file}"
    else
      echo "  WARNING: ${env_file} not found and requires a value you must provide (NGROK_AUTHTOKEN)."
      echo "  Creating a placeholder file -- edit it with your real ngrok auth token, then re-run this script:"
      echo "  ${dir}/${env_file}"
      printf 'NGROK_AUTHTOKEN=your_token_here\n' > "${dir}/${env_file}"
    fi
  fi

  (cd "${dir}" && \
    docker compose build && \
    docker compose run --rm web bundle install && \
    docker compose up -d)
  echo "  Started."
  echo
}

start_demo "${SYS03_DIR}" "SYS-03 - Enterprise Authentication" 3000 ".env_dev" "MONGO_URI=mongodb://mongodb:27017/embedded_webcomponent_auth_development"
start_demo "${SYS04_DIR}" "SYS-04 - Advanced Functions" 3004 ".env_dev" "MONGO_URI=mongodb://mongodb:27017/sys_04_advanced_functions_development"
start_demo "${SYS06_DIR}" "SYS-06 - MCP Server Integration" 3006 ".env" ""

cat <<EOF

All demos are starting up:
  SYS-03  ->  http://localhost:3000
  SYS-04  ->  http://localhost:3004
  SYS-06  ->  http://localhost:3006

Open the hub page to jump between them:
  open "${SCRIPT_DIR}/index.html"

Check status any time with:
  docker ps

Stop everything with:
  ./stop-all.sh
EOF
