#!/bin/zsh
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  print -u2 "This setup is for macOS."
  exit 1
fi

script_dir="${0:A:h}"
brew_bin="$(command -v brew || true)"
if [[ -z "$brew_bin" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin=/usr/local/bin/brew
  else
    print -u2 "Homebrew is required. Install it from https://brew.sh and rerun this script."
    exit 1
  fi
fi
eval "$("$brew_bin" shellenv zsh)"

brew bundle install --file="$script_dir/Brewfile"

install_with_backup() {
  local source_file="$1"
  local destination="$2"
  mkdir -p "${destination:h}"
  if [[ -f "$destination" ]] && ! cmp -s "$source_file" "$destination"; then
    if [[ ! -e "$destination.before-terminal-setup" ]]; then
      cp "$destination" "$destination.before-terminal-setup"
      print "Backed up existing file to $destination.before-terminal-setup"
    fi
  fi
  cp "$source_file" "$destination"
}

install_with_backup "$script_dir/.zprofile" "$HOME/.zprofile"
install_with_backup "$script_dir/.zshrc" "$HOME/.zshrc"
install_with_backup "$script_dir/starship.toml" "$HOME/.config/starship.toml"

iterm_profiles="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$iterm_profiles"
install_with_backup "$script_dir/Catppuccin.json" "$iterm_profiles/Catppuccin.json"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "9778A987-96A7-4FF8-875E-2171C3464B4D"

print "Terminal setup installed. Open a new shell; restart iTerm2 if it was already open."
