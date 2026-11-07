#!/usr/bin/env bash
# Remove the Omarchy Herdr theme integration without changing Herdr settings.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
OMARCHY_CONFIG="$CONFIG_HOME/omarchy"
TEMPLATE_TARGET="$OMARCHY_CONFIG/themed/herdr.json.tpl"
HOOK_TARGET="$OMARCHY_CONFIG/hooks/theme-set.d/herdr"

restore_or_remove() {
  local target="$1"
  local package_file="$2"
  local backup="${target}.before-omarchy-herdr"

  # Never remove a file changed since this package installed it.
  if [[ -e "$target" || -L "$target" ]] && cmp -s "$package_file" "$target" 2>/dev/null; then
    if [[ -e "$backup" || -L "$backup" ]]; then
      rm -f "$target"
      mv "$backup" "$target"
      printf 'Restored %s\n' "$target"
    else
      rm -f "$target"
      printf 'Removed %s\n' "$target"
    fi
  else
    printf 'Left %s unchanged (it is missing or was modified)\n' "$target"
  fi
}

restore_or_remove "$TEMPLATE_TARGET" "$SCRIPT_DIR/herdr.json.tpl"
restore_or_remove "$HOOK_TARGET" "$SCRIPT_DIR/theme-set.d/herdr"

# Remove the generated theme only if it still matches Omarchy's staged output.
generated="$CONFIG_HOME/herdr-app/themes/omarchy.json"
staged="$HOME/.local/state/omarchy/current/theme/herdr.json"
if [[ -f "$generated" && -f "$staged" ]] && cmp -s "$generated" "$staged"; then
  rm -f "$generated"
  printf 'Removed %s\n' "$generated"
else
  printf 'Left %s unchanged (it is missing or was modified)\n' "$generated"
fi

printf '\nHerdr settings were not changed; change its theme manually if desired.\n'
