# macOS terminal setup

Run this command on a Mac to install or update the terminal setup:

```sh
if ! command -v brew >/dev/null 2>&1; then if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; else /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi; fi; if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi; brew install gh && (gh auth status >/dev/null 2>&1 || gh auth login) && tmp="$(mktemp -d)" && { gh repo clone thekeyvan/terminal-setup "$tmp/terminal-setup" -- --depth 1 --quiet && zsh "$tmp/terminal-setup/install.sh"; rm -rf "$tmp"; }
```

Sign in to GitHub with an account that can access this private repository. The command installs Homebrew if needed, authenticates the GitHub CLI if needed, downloads the setup to a temporary folder, installs only the terminal setup: iTerm2, the same Catppuccin theme and JetBrains Mono Nerd Font in both iTerm2 and the macOS Terminal app (set as the default profile in each), the Starship prompt (path breadcrumb and git info), fzf search (Ctrl-R history, Ctrl-T files), zoxide (`z`), eza (`ll`, `lt`), and zsh autosuggestions and syntax highlighting. The temporary folder is deleted afterwards, so nothing stays cloned on the Mac. Existing shell configuration files are backed up before replacement. Quit and reopen iTerm2 and Terminal afterwards to see the theme. Credentials, shell history, and other machine-specific iTerm2 preferences are not copied.
