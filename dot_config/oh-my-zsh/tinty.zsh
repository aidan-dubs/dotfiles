# Installs the latest tinty binary to ~/.local/bin if it isn't already available.

_tinty_install() {
  local install_dir="${TINTY_INSTALL_DIR:-$HOME/.local/bin}"
  local os arch asset url tmp

  case "$(uname -s)" in
    Darwin) os="darwin" ;;
    Linux)  os="linux" ;;
    *) print -u2 "tinty: unsupported OS: $(uname -s)"; return 1 ;;
  esac

  case "$(uname -m)" in
    x86_64|amd64)  arch="x86_64" ;;
    arm64|aarch64) arch="aarch64" ;;
    *) print -u2 "tinty: unsupported architecture: $(uname -m)"; return 1 ;;
  esac

  if [[ $os == darwin ]]; then
    asset="tinty-universal-apple-darwin.tar.gz"
  else
    asset="tinty-${arch}-unknown-linux-gnu.tar.gz"
  fi

  # The /latest/download/ path redirects to the newest release without
  # touching the GitHub API, so there are no rate limit or jq concerns.
  url="https://github.com/tinted-theming/tinty/releases/latest/download/${asset}"

  tmp="$(mktemp -d)" || return 1
  print "tinty: downloading ${asset}..."

  if ! curl -fsSL "$url" -o "$tmp/$asset"; then
    print -u2 "tinty: download failed: $url"
    rm -rf "$tmp"
    return 1
  fi

  if ! tar -xzf "$tmp/$asset" -C "$tmp"; then
    print -u2 "tinty: failed to extract archive"
    rm -rf "$tmp"
    return 1







  fi

  # Locate the binary in case the archive nests it in a directory
  local bin
  bin="$(find "$tmp" -type f -name tinty | head -n 1)"
  if [[ -z $bin ]]; then
    print -u2 "tinty: binary not found in archive"
    rm -rf "$tmp"
    return 1
  fi

  mkdir -p "$install_dir"
  install -m 755 "$bin" "$install_dir/tinty"
  rm -rf "$tmp"
  print "tinty: installed to $install_dir/tinty"
  "$install_dir/tinty" install
}

# Only download if tinty isn't already available
if ! (( $+commands[tinty] )); then
  _tinty_install
fi
