# macOS terminal setup

Run this command on a Mac to install or update the terminal setup:

```sh
if ! command -v brew >/dev/null 2>&1; then if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; else /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi; fi; if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi; brew install gh && (gh auth status >/dev/null 2>&1 || gh auth login) && tmp="$(mktemp -d)" && { gh repo clone thekeyvan/terminal-setup "$tmp/terminal-setup" -- --depth 1 --quiet && zsh "$tmp/terminal-setup/install.sh"; rm -rf "$tmp"; }
```

Sign in to GitHub with an account that can access this private repository. The command installs Homebrew if needed, authenticates the GitHub CLI if needed, downloads the setup to a temporary folder, installs only the terminal setup: iTerm2, the same Catppuccin theme and JetBrains Mono Nerd Font in both iTerm2 and the macOS Terminal app (set as the default profile in each), the Starship prompt (path breadcrumb and git info), fzf search (Ctrl-R history, Ctrl-T files), zoxide (`z`), eza (`ll`, `lt`), and zsh autosuggestions and syntax highlighting. The temporary folder is deleted afterwards, so nothing stays cloned on the Mac. Existing shell configuration files are backed up before replacement. Quit and reopen iTerm2 and Terminal afterwards to see the theme. Credentials, shell history, and other machine-specific iTerm2 preferences are not copied.

## Cheat sheet

### Search (fzf)

| Keys | What it does |
| --- | --- |
| `Ctrl-R` | Fuzzy-search your command history. Press `Ctrl-R` again to switch between most recent first and best match first. `Enter` puts the command on the prompt. |
| `Ctrl-T` | Fuzzy-find files and folders below the current folder and insert the path. `Tab` selects several. |
| `Esc`, then `C` | Fuzzy-find a subfolder and `cd` into it. On a Mac, `Option-C` types `ç` instead, so use `Esc` then `C`. |
| `**` then `Tab` | Fuzzy completion for any command, for example `cd **<Tab>`, `code **<Tab>`, `kill -9 **<Tab>` (pick a process), `ssh **<Tab>` (pick a host). |

In any fzf list, use the arrow keys or `Ctrl-J`/`Ctrl-K` to move, and `Esc` to cancel. Search syntax: `word` fuzzy match, `'word` exact match, `^start`, `end$`, `!exclude`, `a | b` either one.

### Jump to folders (zoxide)

| Command | What it does |
| --- | --- |
| `z proj` | Jump to the most-used folder matching `proj`. It learns from folders you visit, so use `cd` normally at first. |
| `z xp setup` | Use several words to narrow it down. |
| `zi proj` | Pick from the matches interactively with fzf. |
| `z -` | Go back to the previous folder. |

### Listing files (eza)

| Command | What it does |
| --- | --- |
| `ll` | Detailed list including hidden files, folders first. |
| `lt` | Tree view, two levels deep. |

### Typing commands

- **Autosuggestions:** a grey suggestion from your history appears as you type. Press `→` or `Ctrl-E` to accept all of it, or `Esc` then `F` to accept one word.
- **Syntax highlighting:** commands turn green when they exist and red when they don't, so you see typos before pressing `Enter`.
- **History:** keeps 50,000 commands and skips duplicates. Start a command with a space to keep it out of history, which is useful for commands that contain secrets.

### Prompt (Starship)

```
[Developer/xp/terminal-setup]   main [!?] took 3s
❯
```

- `[…]` is the path breadcrumb, showing the last 3 folders.
- After it come the git branch and, in brackets, the git status: `!` modified, `+` staged, `?` untracked, `✘` deleted, `⇡` ahead, `⇣` behind, `⇕` diverged, `$` stashed, `=` conflicts.
- The Python, Rust, Go and Java versions appear when you are in a project that uses them.
- `took 3s` appears when a command runs for longer than 2 seconds.
- `❯` is green when the last command succeeded and red when it failed.
