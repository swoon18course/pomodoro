#!/usr/bin/env bash
set -euo pipefail

WORK="${1:-25}"
BREAK="${2:-10}"
NO_NOTIFY="${NO_NOTIFY:-0}"

notify() {
  [[ "$NO_NOTIFY" == "1" ]] && return 0
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Pomodoro" "$1" || true
  elif command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$1\" with title \"Pomodoro\"" || true
  fi
}

countdown() {
  local total="$1" label="$2" remaining
  remaining="$total"
  while (( remaining > 0 )); do
    printf "\r%s %02d:%02d " "$label" $((remaining / 60)) $((remaining % 60))
    sleep 1
    remaining=$((remaining - 1))
  done
  printf "\r%s done.          \n" "$label"
}

countdown $((WORK * 60)) "focus"
notify "Focus session finished — take a break"
countdown $((BREAK * 60)) "break"
notify "Break finished — back to work"
