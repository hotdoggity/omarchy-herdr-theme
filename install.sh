#!/usr/bin/env bash
# Install Omarchy's generated Herdr theme integration for the current user.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
OMARCHY_CONFIG="$CONFIG_HOME/omarchy"
TEMPLATE_TARGET="$OMARCHY_CONFIG/themed/herdr.json.tpl"
HOOK_TARGET="$OMARCHY_CONFIG/hooks/theme-set.d/herdr"

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

[[ -d "$HOME" ]] || fail "HOME is not set to a directory"
[[ -f "$SCRIPT_DIR/herdr.json.tpl" ]] || fail "herdr.json.tpl is missing from the package"
[[ -f "$SCRIPT_DIR/theme-set.d/herdr" ]] || fail "theme-set.d/herdr is missing from the package"
command -v omarchy-theme-refresh >/dev/null 2>&1 || \
  fail "omarchy-theme-refresh was not found; install Omarchy first"

backup_if_needed() {
  local target="$1"
  local package_file="$2"
  local backup="${target}.before-omarchy-herdr"

  if [[ -e "$target" || -L "$target" ]] && ! cmp -s "$package_file" "$target" 2>/dev/null; then
    if [[ ! -e "$backup" && ! -L "$backup" ]]; then
      cp -a "$target" "$backup"
      printf 'Backed up %s to %s\n' "$target" "$backup"
    fi
  fi
}

install_template() {
  mkdir -p "$(dirname "$TEMPLATE_TARGET")"
  backup_if_needed "$TEMPLATE_TARGET" "$SCRIPT_DIR/herdr.json.tpl"
  install -m 0644 "$SCRIPT_DIR/herdr.json.tpl" "$TEMPLATE_TARGET"
}

install_hook() {
  mkdir -p "$(dirname "$HOOK_TARGET")"
  backup_if_needed "$HOOK_TARGET" "$SCRIPT_DIR/theme-set.d/herdr"
  install -m 0755 "$SCRIPT_DIR/theme-set.d/herdr" "$HOOK_TARGET"
}

install_template
install_hook

# Render the current theme immediately. Theme switching will render it again,
# and the hook will keep Herdr's discovery file synchronized from then on.
OMARCHY_THEME_SKIP_BACKGROUND=1 omarchy-theme-refresh

printf '\nOmarchy Herdr theme integration installed.\n'
printf 'Select "omarchy" once in Herdr (Ctrl+P, then Settings > Look).\n'
printf 'Future `omarchy theme set ...` commands update it automatically.\n'
