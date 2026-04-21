#!/usr/bin/env bash
# Docker container count — emits waybar json.
# Click: lazydocker. Right-click: bare `docker ps` snapshot.

if ! command -v docker >/dev/null 2>&1; then
  printf '{"text":"—","tooltip":"docker not installed","class":"absent"}\n'
  exit 0
fi

# Use timeout to avoid hanging waybar if the daemon is down.
if ! running=$(timeout 2 docker ps -q 2>/dev/null | wc -l); then
  printf '{"text":"off","tooltip":"docker daemon not reachable","class":"off"}\n'
  exit 0
fi

total=$(timeout 2 docker ps -a -q 2>/dev/null | wc -l)
tooltip=$(timeout 2 docker ps --format 'table {{.Names}}\t{{.Status}}' 2>/dev/null)

# Escape for JSON: strip backslashes, escape quotes, collapse newlines to \n.
tooltip_escaped=$(printf '%s' "$tooltip" \
  | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' \
  | awk 'BEGIN{ORS="\\n"} {print}')

if [[ "$running" -eq 0 ]]; then
  class="idle"
else
  class="active"
fi

printf '{"text":"%s/%s","tooltip":"%s","class":"%s"}\n' "$running" "$total" "$tooltip_escaped" "$class"
