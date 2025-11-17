fzf_search() {
  local pkg_var=$1
  shift

  local prompt=$1
  shift

  local cmd="$*"

  local result
  result="$(eval "$cmd" | fzf \
    --prompt="$prompt" \
    --preview 'brew info {} 2>/dev/null | head -100' \
    --preview-window=right:60%:wrap
  )" || return

  eval "$pkg_var=\"\$result\""
}


brew-u() {
  local pkgs
  pkgs=($(brew list | fzf --multi \
    --prompt="Search installed packages: " \
    --preview 'brew info {} 2>/dev/null | head -100' \
    --preview-window=right:60%:wrap
  ))

  [[ ${#pkgs[@]} -eq 0 ]] && { echo "No packages selected."; return 1 }

  echo "Selected packages:"
  printf '%s\n' "${pkgs[@]}"
  echo

  for pkg in "${pkgs[@]}"; do
    echo "Uninstalling $pkg..."
    brew uninstall "$pkg"
  done
}


brew-i() {
  local cache_file="$HOME/.cache/brew-packages.txt"
  mkdir -p "$(dirname "$cache_file")"

  if [[ ! -f "$cache_file" || $(find "$cache_file" -mtime +1) ]]; then
    echo "Updating brew package cache..."
    brew search "" > "$cache_file"
  fi

  local pkg=""
  fzf_search pkg "Search Homebrew: " "cat \"$cache_file\""

  [[ -z "$pkg" ]] && return

  echo
  brew info "$pkg"
  echo

  if brew list --formula "$pkg" &>/dev/null || brew list --cask "$pkg" &>/dev/null; then
    echo "Upgrading $pkg..."
    brew upgrade "$pkg" || brew upgrade --cask "$pkg"
  else
    echo "Installing $pkg..."
    if brew info --cask "$pkg" &>/dev/null; then
      brew install --cask "$pkg"
    else
      brew install "$pkg"
    fi
  fi
}
