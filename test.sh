#!/usr/bin/env bash
# Test rendering and the Herdr destination adapter in a temporary home.

set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
OMARCHY_PATH=${OMARCHY_PATH:-/usr/share/omarchy}
COLORS="$OMARCHY_PATH/themes/tokyo-night/colors.toml"
command -v omarchy-theme-set-templates >/dev/null 2>&1 || {
  printf 'omarchy-theme-set-templates was not found; install Omarchy first\n' >&2
  exit 1
}
[[ -f "$COLORS" ]] || {
  printf 'test palette not found: %s\n' "$COLORS" >&2
  exit 1
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/.config/omarchy/themed" \
         "$TMP/.config/omarchy/hooks/theme-set.d" \
         "$TMP/.local/state/omarchy/current/next-theme"
cp "$ROOT/herdr.json.tpl" "$TMP/.config/omarchy/themed/herdr.json.tpl"
cp "$COLORS" "$TMP/.local/state/omarchy/current/next-theme/colors.toml"

HOME="$TMP" XDG_CONFIG_HOME="$TMP/.config" OMARCHY_PATH="$OMARCHY_PATH" \
  omarchy-theme-set-templates

mv "$TMP/.local/state/omarchy/current/next-theme" \
   "$TMP/.local/state/omarchy/current/theme"
HOME="$TMP" XDG_CONFIG_HOME="$TMP/.config" \
  bash "$ROOT/theme-set.d/herdr"

GENERATED="$TMP/.config/herdr-app/themes/omarchy.json"
[[ -f "$GENERATED" ]]
! grep -q '{{' "$GENERATED"
python3 - "$GENERATED" "$COLORS" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

generated = json.loads(Path(sys.argv[1]).read_text())
source = tomllib.loads(Path(sys.argv[2]).read_text())
assert len(generated["ansi"]) == 16
assert generated["background"] == source["background"]
assert generated["foreground"] == source["foreground"]
assert generated["colors"]["accent"] == source["accent"]
assert generated["colors"]["selected"] != generated["selection"]
assert generated["colors"]["selection"] == source["selection"]
assert all(value.startswith("#") for value in generated["ansi"])
PY

cmp -s "$GENERATED" "$TMP/.local/state/omarchy/current/theme/herdr.json"
printf 'rendering and Herdr destination adapter: ok\n'
