# Omarchy Herdr Theme

A small user-level integration that keeps Herdr's interface and terminal colors
in sync with the active Omarchy theme.

Omarchy owns the palette; this package adapts it for Herdr:

```text
active Omarchy colors.toml
        |
        v
~/.config/omarchy/themed/herdr.json.tpl
        |
        v
active theme/herdr.json
        |
        v
~/.config/herdr-app/themes/omarchy.json
        |
        v
Herdr
```

The generated Herdr theme is always named `omarchy`, so select it once. The
selected-list background is intentionally a subtle 10% foreground tint rather
than Omarchy's often-bright selection color. The separate terminal text
selection still follows Omarchy's `selection_background`.

## Install

```sh
git clone https://github.com/hotdoggity/omarchy-herdr-theme.git
cd omarchy-herdr-theme
./install.sh
```

Then select **omarchy** in Herdr (Ctrl+P → Settings → Look), or run:

```sh
herdr-app do app.theme '{"name":"omarchy"}'
```

The installer renders the current Omarchy theme immediately. Future
`omarchy theme set ...` and `omarchy theme refresh` operations update Herdr's
palette automatically through the installed theme-set hook. The generated
file is copied atomically, and Herdr can reload the theme without restarting.

For the terminal focus outline to follow the active theme, Herdr settings must
not override `colors.accent` with a fixed color.

## What is installed

| Path | Purpose |
| --- | --- |
| `~/.config/omarchy/themed/herdr.json.tpl` | Herdr palette template rendered from Omarchy `colors.toml` |
| `~/.config/omarchy/hooks/theme-set.d/herdr` | Copies the generated palette into Herdr's theme directory |
| `~/.config/herdr-app/themes/omarchy.json` | Generated theme consumed by Herdr |

The integration uses Omarchy's user override directories. It does not modify
`/usr/share/omarchy` or replace Herdr's own files. The installer backs up
pre-existing template and hook files before replacing them. To remove the
integration:

```sh
./uninstall.sh
```

The uninstaller restores those backups when possible, leaves subsequently
modified files alone, and does not change Herdr's selected theme setting.

## Palette mapping

| Omarchy color | Herdr role |
| --- | --- |
| `background`, `darker_background`, `dark_background` | terminal, canvas, and chrome surfaces |
| `lighter_background` | raised and hovered surfaces |
| `mix background foreground 10%` | subdued selected-list background |
| `foreground`, `muted`, `dark_foreground` | text and hierarchy |
| `accent` | focused pane outline and accent controls |
| `selection_background`, `cursor` | terminal selection and cursor |
| `cyan`, `red`, `green` | working, blocked, and done status colors |
| `color0`–`color15` | terminal ANSI palette |

## Test

Run `./test.sh` to render the template against an installed Omarchy palette in
a temporary home and verify the generated JSON and Herdr destination hook.

## License

MIT. See [LICENSE](LICENSE).
