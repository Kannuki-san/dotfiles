#!/usr/bin/env bash
set -e

APT_PACKAGES=(
  neovim
  fd-find
  ripgrep
  git
  nodejs
  python3
  curl
  ca-certificates
)

DNF_PACKAGES=(
  neovim
  fd-find
  ripgrep
  git
  nodejs
  python3
  curl
  ca-certificates
  dnf-plugins-core
)

PACMAN_PACKAGES=(
  neovim
  fd
  ripgrep
  git
  nodejs
  python
  curl
  ca-certificates
)

UV_TOOLS=(
  pytest
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_SOURCE_DIR="$SCRIPT_DIR/.config/nvim"
NVIM_TARGET_DIR="$HOME/.config/nvim"

detect_pkg_manager() {
  if command -v apt >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo ""
  fi
}

install_base_packages() {
  local manager="$1"

  case "$manager" in
    apt)
      sudo apt update
      sudo apt install -y "${APT_PACKAGES[@]}"
      ;;
    dnf)
      sudo dnf install -y "${DNF_PACKAGES[@]}"
      ;;
    pacman)
      sudo pacman -Sy --noconfirm "${PACMAN_PACKAGES[@]}"
      ;;
    *)
      echo "Unsupported package manager: $manager" >&2
      exit 1
      ;;
  esac
}

ensure_local_bin_in_path() {
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
  esac
}

ensure_fd_command() {
  if command -v fd >/dev/null 2>&1; then
    return
  fi

  if command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ensure_local_bin_in_path
    echo "Created fd shim: $HOME/.local/bin/fd"
  fi
}

ensure_uv() {
  if command -v uv >/dev/null 2>&1; then
    echo "uv already exists: $(command -v uv)"
    return
  fi

  echo "uv not found in package manager install result. Installing via official installer..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ensure_local_bin_in_path

  if ! command -v uv >/dev/null 2>&1; then
    echo "uv installation failed." >&2
    exit 1
  fi
}

install_uv_tools() {
  ensure_local_bin_in_path

  for tool in "${UV_TOOLS[@]}"; do
    if uv tool list | grep -q "^$tool "; then
      echo "Upgrading uv tool: $tool"
      uv tool upgrade "$tool"
    else
      echo "Installing uv tool: $tool"
      uv tool install "$tool"
    fi
  done
}

install_lazygit_apt_fallback() {
  local version arch tmpdir
  version="$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]+')"
  arch="$(uname -m | sed -e 's/aarch64/arm64/')"

  if [ -z "$version" ]; then
    echo "Could not determine latest lazygit version." >&2
    exit 1
  fi

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN

  (
    cd "$tmpdir"
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_${arch}.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
  )
}

install_lazygit() {
  local manager="$1"

  if command -v lazygit >/dev/null 2>&1; then
    echo "lazygit already exists: $(command -v lazygit)"
    return
  fi

  case "$manager" in
    apt)
      if sudo apt install -y lazygit; then
        :
      else
        echo "apt で lazygit が入らなかったので GitHub Releases から導入します..."
        install_lazygit_apt_fallback
      fi
      ;;
    dnf)
      sudo dnf copr enable dejan/lazygit -y
      sudo dnf install -y lazygit
      ;;
    pacman)
      sudo pacman -S --noconfirm lazygit
      ;;
    *)
      echo "Unsupported package manager for lazygit: $manager" >&2
      exit 1
      ;;
  esac

  if ! command -v lazygit >/dev/null 2>&1; then
    echo "lazygit installation failed." >&2
    exit 1
  fi
}

copy_nvim_config() {
  if [ ! -d "$NVIM_SOURCE_DIR" ]; then
    echo "Neovim config source directory not found: $NVIM_SOURCE_DIR" >&2
    exit 1
  fi

  mkdir -p "$HOME/.config"

  if [ -d "$NVIM_TARGET_DIR" ]; then
    mv "$NVIM_TARGET_DIR" "${NVIM_TARGET_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
  fi

  cp -r "$NVIM_SOURCE_DIR" "$NVIM_TARGET_DIR"
  echo "Copied nvim config to: $NVIM_TARGET_DIR"
}

main() {
  local manager
  manager="$(detect_pkg_manager)"

  if [ -z "$manager" ]; then
    echo "apt / dnf / pacman のいずれも見つかりませんでした。" >&2
    exit 1
  fi

  echo "Using package manager: $manager"

  install_base_packages "$manager"
  ensure_fd_command
  ensure_uv
  install_uv_tools
  install_lazygit "$manager"
  copy_nvim_config

  echo "Setup completed."
  echo "uv:      $(command -v uv)"
  echo "pytest:  $(command -v pytest || true)"
  echo "lazygit: $(command -v lazygit || true)"
  echo "Run: nvim"
}

main "$@"
