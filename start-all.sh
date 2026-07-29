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

# Percent-encodes a filesystem path for use in a file:// URI (handles spaces
# and other special characters, e.g. paths containing spaces).
urlencode_path() {
  local path="$1" encoded="" c hex
  local i
  for (( i=0; i<${#path}; i++ )); do
    c="${path:i:1}"
    case "$c" in
      [a-zA-Z0-9/._~-]) encoded+="$c" ;;
      *) printf -v hex '%%%02X' "'$c"
         encoded+="$hex" ;;
    esac
  done
  printf '%s' "$encoded"
}

# Prints a clickable terminal hyperlink (OSC 8) pointing at a file:// URI.
# Terminals that don't support OSC 8 just show the plain link text instead.
print_hyperlink() {
  local file_path="$1" label="$2"
  local uri="file://$(urlencode_path "${file_path}")"
  printf '  \033]8;;%s\033\\%s\033]8;;\033\\\n' "${uri}" "${label}"
}

# Opens a local file in the default browser, working across macOS, native
# Linux, WSL, and Git Bash/MSYS/Cygwin on Windows. Returns non-zero if no
# known way to open a browser was found, so the caller can fall back.
open_in_browser() {
  local target="$1"
  case "$(uname -s)" in
    Darwin)
      open "${target}"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      # Git Bash / MSYS on native Windows: hand off to cmd.exe with a
      # Windows-style path (needs cygpath, bundled with Git Bash).
      local win_path
      win_path="$(cygpath -w "${target}" 2>/dev/null || printf '%s' "${target}")"
      cmd.exe /c start "" "${win_path}" >/dev/null 2>&1
      ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        # WSL: hand off to Windows to open the default browser.
        if command -v wslview >/dev/null 2>&1; then
          wslview "${target}"
        else
          local win_path
          win_path="$(wslpath -w "${target}" 2>/dev/null || printf '%s' "${target}")"
          cmd.exe /c start "" "${win_path}" >/dev/null 2>&1
        fi
      elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "${target}" >/dev/null 2>&1
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
  esac
}

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

Check status any time with:
  docker ps

Stop everything with:
  ./stop-all.sh
EOF

echo "Opening the demo hub in your browser..."
if ! open_in_browser "${SCRIPT_DIR}/index.html"; then
  echo "Could not open the browser automatically. Open this page manually:"
  print_hyperlink "${SCRIPT_DIR}/index.html" "${SCRIPT_DIR}/index.html"
fi
