if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv zsh)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"
