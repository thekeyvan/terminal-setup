# macOS terminal setup

Run this command on a Mac to install or update the terminal setup:

```sh
if ! command -v brew >/dev/null 2>&1; then if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; else /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi; fi; if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi; brew install gh && (gh auth status >/dev/null 2>&1 || gh auth login) && mkdir -p "$HOME/Developer/xp" && (if [ -d "$HOME/Developer/xp/terminal-setup/.git" ]; then git -C "$HOME/Developer/xp/terminal-setup" pull --ff-only; else gh repo clone thekeyvan/terminal-setup "$HOME/Developer/xp/terminal-setup"; fi) && zsh "$HOME/Developer/xp/terminal-setup/install.sh"
```

Sign in to GitHub with an account that can access this private repository. The command installs Homebrew if needed, authenticates the GitHub CLI if needed, fetches the setup, and installs only the terminal setup: iTerm2, the Catppuccin iTerm2 profile and JetBrains Mono Nerd Font, the Starship prompt (path breadcrumb and git info), fzf search (Ctrl-R history, Ctrl-T files), zoxide (`z`), eza (`ll`, `lt`), and zsh autosuggestions and syntax highlighting. Existing shell configuration files are backed up before replacement. Credentials, shell history, and other machine-specific iTerm2 preferences are not copied.
