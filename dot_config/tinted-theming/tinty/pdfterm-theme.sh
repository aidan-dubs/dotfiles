#!/bin/sh

set -eu

variant="${TINTY_SCHEME_VARIANT:-dark}"
case "$variant" in
  light|dark) ;;
  *)
    printf 'tinty pdfterm theme: unsupported variant: %s\n' "$variant" >&2
    exit 1
    ;;
esac

hex_component() {
  case "$1" in
    [0-9A-Fa-f][0-9A-Fa-f]) printf '%s' "$1" ;;
    *)
      printf 'tinty pdfterm theme: expected a two-digit hex color component, got: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

color() {
  printf '#%s%s%s' \
    "$(hex_component "$1")" \
    "$(hex_component "$2")" \
    "$(hex_component "$3")" |
    tr '[:upper:]' '[:lower:]'
}

base00="$(color "$TINTY_SCHEME_PALETTE_BASE00_HEX_R" "$TINTY_SCHEME_PALETTE_BASE00_HEX_G" "$TINTY_SCHEME_PALETTE_BASE00_HEX_B")"
base01="$(color "$TINTY_SCHEME_PALETTE_BASE01_HEX_R" "$TINTY_SCHEME_PALETTE_BASE01_HEX_G" "$TINTY_SCHEME_PALETTE_BASE01_HEX_B")"
base02="$(color "$TINTY_SCHEME_PALETTE_BASE02_HEX_R" "$TINTY_SCHEME_PALETTE_BASE02_HEX_G" "$TINTY_SCHEME_PALETTE_BASE02_HEX_B")"
base03="$(color "$TINTY_SCHEME_PALETTE_BASE03_HEX_R" "$TINTY_SCHEME_PALETTE_BASE03_HEX_G" "$TINTY_SCHEME_PALETTE_BASE03_HEX_B")"
base04="$(color "$TINTY_SCHEME_PALETTE_BASE04_HEX_R" "$TINTY_SCHEME_PALETTE_BASE04_HEX_G" "$TINTY_SCHEME_PALETTE_BASE04_HEX_B")"
base05="$(color "$TINTY_SCHEME_PALETTE_BASE05_HEX_R" "$TINTY_SCHEME_PALETTE_BASE05_HEX_G" "$TINTY_SCHEME_PALETTE_BASE05_HEX_B")"
base06="$(color "$TINTY_SCHEME_PALETTE_BASE06_HEX_R" "$TINTY_SCHEME_PALETTE_BASE06_HEX_G" "$TINTY_SCHEME_PALETTE_BASE06_HEX_B")"
base08="$(color "$TINTY_SCHEME_PALETTE_BASE08_HEX_R" "$TINTY_SCHEME_PALETTE_BASE08_HEX_G" "$TINTY_SCHEME_PALETTE_BASE08_HEX_B")"
base09="$(color "$TINTY_SCHEME_PALETTE_BASE09_HEX_R" "$TINTY_SCHEME_PALETTE_BASE09_HEX_G" "$TINTY_SCHEME_PALETTE_BASE09_HEX_B")"
base0a="$(color "$TINTY_SCHEME_PALETTE_BASE0A_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0A_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0A_HEX_B")"
base0b="$(color "$TINTY_SCHEME_PALETTE_BASE0B_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0B_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0B_HEX_B")"
base0c="$(color "$TINTY_SCHEME_PALETTE_BASE0C_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0C_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0C_HEX_B")"
base0d="$(color "$TINTY_SCHEME_PALETTE_BASE0D_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0D_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0D_HEX_B")"
base0e="$(color "$TINTY_SCHEME_PALETTE_BASE0E_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0E_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0E_HEX_B")"
base0f="$(color "$TINTY_SCHEME_PALETTE_BASE0F_HEX_R" "$TINTY_SCHEME_PALETTE_BASE0F_HEX_G" "$TINTY_SCHEME_PALETTE_BASE0F_HEX_B")"

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
theme_dir="$config_dir/pdfterm/themes"
mkdir -p "$theme_dir"
tmp_file="$(mktemp "$theme_dir/.tinty-$variant.XXXXXX")"
trap 'rm -f "$tmp_file"' 0
trap 'exit 1' HUP INT TERM

cat > "$tmp_file" <<EOF
[colors]
base = "$base00"
mantle = "$base01"
crust = "$base02"
surface0 = "$base02"
surface1 = "$base03"
overlay0 = "$base04"
overlay1 = "$base05"
overlay2 = "$base06"
text = "$base05"
subtext0 = "$base04"
red = "$base08"
maroon = "$base08"
peach = "$base09"
yellow = "$base0a"
green = "$base0b"
teal = "$base0c"
sky = "$base0c"
blue = "$base0d"
mauve = "$base0e"
pink = "$base0f"

[ui]
background = "base"
background_dark = "mantle"
background_deep = "crust"
border = "surface1"
accent = "mauve"
selection = "surface0"
key = "sky"
text = "text"
text_dim = "subtext0"
error = "red"
cursor_bg = "surface0"

[document]
background = "$base00"
foreground = "$base05"

[git]
add = "$base0b"
change = "$base0d"
delete = "$base08"
EOF

mv "$tmp_file" "$theme_dir/tinty-$variant.toml"
