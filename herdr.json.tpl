{
  "background": "{{ background }}",
  "foreground": "{{ foreground }}",
  "selection": "{{ selection_background }}",
  "cursor": "{{ cursor }}",
  "ansi": [
    "{{ color0 }}", "{{ color1 }}", "{{ color2 }}", "{{ color3 }}",
    "{{ color4 }}", "{{ color5 }}", "{{ color6 }}", "{{ color7 }}",
    "{{ color8 }}", "{{ color9 }}", "{{ color10 }}", "{{ color11 }}",
    "{{ color12 }}", "{{ color13 }}", "{{ color14 }}", "{{ color15 }}"
  ],
  "colors": {
    "background": "{{ background }}",
    "canvas": "{{ darker_background }}",
    "chrome": "{{ dark_background }}",
    "surface": "{{ background }}",
    "popover": "{{ dark_background }}",
    "raised": "{{ lighter_background }}",
    "hover": "{{ lighter_background }}",
    "selected": "{{ mix background foreground 10% }}",
    "border": "{{ muted }}",
    "input": "{{ dark_foreground }}",
    "foreground": "{{ foreground }}",
    "muted": "{{ muted }}",
    "dim": "{{ dark_foreground }}",
    "accent": "{{ accent }}",
    "accent_foreground": "{{ selection_foreground }}",
    "solid": "{{ accent }}",
    "solid_foreground": "{{ bright_foreground }}",
    "selection": "{{ selection_background }}",
    "working": "{{ cyan }}",
    "blocked": "{{ red }}",
    "done": "{{ green }}",
    "idle": "{{ muted }}",
    "unknown": "{{ dark_foreground }}"
  }
}
