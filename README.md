# macOS terminal setup

My terminal setup for iTerm2 and the macOS Terminal app: the same Catppuccin theme and font in both, a Starship prompt with a path breadcrumb, fzf search, zoxide, eza and zsh autosuggestions and syntax highlighting.

## Install

Copy the whole block below (use the copy button), paste it into Terminal or iTerm2, and press `Enter`. Nothing needs to be downloaded or cloned; the setup is all in this one command.

```sh
t="$(mktemp)" && cat >| "$t" <<'TERMINAL_SETUP' && zsh "$t"; rm -f "$t"
set -euo pipefail
if [[ "$(uname -s)" != Darwin ]]; then print -u2 "This setup is for macOS."; exit 1; fi

load_brew() {
  if command -v brew >/dev/null 2>&1; then return 0; fi
  if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; return 0; fi
  if [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; return 0; fi
  return 1
}
if ! load_brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
fi

brew install starship fzf zoxide eza zsh-autosuggestions zsh-syntax-highlighting
if [[ ! -d /Applications/iTerm.app ]]; then brew install --cask iterm2; fi
if [[ ! -f ~/Library/Fonts/JetBrainsMonoNerdFontMono-Regular.ttf ]] && ! brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
  brew install --cask font-jetbrains-mono-nerd-font
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

put() {
  local dest="$1"
  cat > "$work/new"
  mkdir -p "${dest:h}"
  if [[ -f "$dest" && ! -e "$dest.before-terminal-setup" ]] && ! cmp -s "$work/new" "$dest"; then
    cp "$dest" "$dest.before-terminal-setup"
    print "Backed up $dest to $dest.before-terminal-setup"
  fi
  cat "$work/new" > "$dest"
}

put ~/.zprofile <<'EOF'
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv zsh)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"
EOF

put ~/.zshrc <<'EOF'
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history hist_ignore_dups hist_ignore_space

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

alias ll='eza -lah --group-directories-first'
alias lt='eza --tree --level=2 --group-directories-first'

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
EOF

put ~/.config/starship.toml <<'EOF'
add_newline = true
format = '$directory$git_branch$git_status$python$rust$golang$java$docker_context$cmd_duration$line_break$character'

[directory]
format = '[\[](#585b70)[$path]($style)[\]](#585b70)[$read_only]($read_only_style)  '
style = 'bold #89b4fa'
read_only = ' read-only'
truncation_length = 3
truncation_symbol = '…/'
truncate_to_repo = false

[git_branch]
format = '[$symbol$branch]($style) '
symbol = ' '
style = 'bold #cba6f7'

[git_status]
style = 'bold #f9e2af'

[python]
symbol = 'python '

[rust]
symbol = 'rust '

[golang]
symbol = 'go '

[java]
symbol = 'java '

[docker_context]
symbol = 'docker '

[character]
success_symbol = '[❯](bold #a6e3a1)'
error_symbol = '[❯](bold #f38ba8)'

[cmd_duration]
min_time = 2000
style = '#f9e2af'
EOF

iterm_profile="$HOME/Library/Application Support/iTerm2/DynamicProfiles/Catppuccin.json"
put "$iterm_profile" <<'EOF'
{
  "Profiles": [
    {
      "Name": "Catppuccin",
      "Guid": "9778A987-96A7-4FF8-875E-2171C3464B4D",
      "Rewritable": true,
      "Normal Font": "JetBrainsMonoNFM-Regular 13",
      "Non Ascii Font": "JetBrainsMonoNFM-Regular 13",
      "Use Non-ASCII Font": true,
      "Use Bold Font": true,
      "Use Italic Font": true,
      "Cursor Type": 2,
      "Blinking Cursor": false,
      "Transparency": 0,
      "Use Separate Colors for Light and Dark Mode": false,
      "Background Color": {"Color Space": "sRGB", "Red Component": 0.118, "Green Component": 0.118, "Blue Component": 0.180},
      "Foreground Color": {"Color Space": "sRGB", "Red Component": 0.804, "Green Component": 0.839, "Blue Component": 0.957},
      "Bold Color": {"Color Space": "sRGB", "Red Component": 0.804, "Green Component": 0.839, "Blue Component": 0.957},
      "Cursor Color": {"Color Space": "sRGB", "Red Component": 0.961, "Green Component": 0.878, "Blue Component": 0.863},
      "Cursor Text Color": {"Color Space": "sRGB", "Red Component": 0.118, "Green Component": 0.118, "Blue Component": 0.180},
      "Selection Color": {"Color Space": "sRGB", "Red Component": 0.345, "Green Component": 0.357, "Blue Component": 0.439},
      "Selected Text Color": {"Color Space": "sRGB", "Red Component": 0.804, "Green Component": 0.839, "Blue Component": 0.957},
      "Ansi 0 Color": {"Color Space": "sRGB", "Red Component": 0.271, "Green Component": 0.278, "Blue Component": 0.353},
      "Ansi 1 Color": {"Color Space": "sRGB", "Red Component": 0.953, "Green Component": 0.545, "Blue Component": 0.659},
      "Ansi 2 Color": {"Color Space": "sRGB", "Red Component": 0.651, "Green Component": 0.890, "Blue Component": 0.631},
      "Ansi 3 Color": {"Color Space": "sRGB", "Red Component": 0.976, "Green Component": 0.886, "Blue Component": 0.686},
      "Ansi 4 Color": {"Color Space": "sRGB", "Red Component": 0.537, "Green Component": 0.706, "Blue Component": 0.980},
      "Ansi 5 Color": {"Color Space": "sRGB", "Red Component": 0.796, "Green Component": 0.651, "Blue Component": 0.969},
      "Ansi 6 Color": {"Color Space": "sRGB", "Red Component": 0.580, "Green Component": 0.886, "Blue Component": 0.835},
      "Ansi 7 Color": {"Color Space": "sRGB", "Red Component": 0.729, "Green Component": 0.761, "Blue Component": 0.871},
      "Ansi 8 Color": {"Color Space": "sRGB", "Red Component": 0.345, "Green Component": 0.357, "Blue Component": 0.439},
      "Ansi 9 Color": {"Color Space": "sRGB", "Red Component": 0.953, "Green Component": 0.545, "Blue Component": 0.659},
      "Ansi 10 Color": {"Color Space": "sRGB", "Red Component": 0.651, "Green Component": 0.890, "Blue Component": 0.631},
      "Ansi 11 Color": {"Color Space": "sRGB", "Red Component": 0.976, "Green Component": 0.886, "Blue Component": 0.686},
      "Ansi 12 Color": {"Color Space": "sRGB", "Red Component": 0.537, "Green Component": 0.706, "Blue Component": 0.980},
      "Ansi 13 Color": {"Color Space": "sRGB", "Red Component": 0.796, "Green Component": 0.651, "Blue Component": 0.969},
      "Ansi 14 Color": {"Color Space": "sRGB", "Red Component": 0.580, "Green Component": 0.886, "Blue Component": 0.835},
      "Ansi 15 Color": {"Color Space": "sRGB", "Red Component": 0.655, "Green Component": 0.678, "Blue Component": 0.784}
    }
  ]
}
EOF
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "9778A987-96A7-4FF8-875E-2171C3464B4D"

osascript -l JavaScript - "$iterm_profile" "$work/terminal-profile.plist" <<'EOF'
ObjC.import('AppKit');
function run(argv) {
  const p = JSON.parse($.NSString.stringWithContentsOfFileEncodingError(argv[0], $.NSUTF8StringEncoding, null).js).Profiles[0];
  const archive = o => $.NSKeyedArchiver.archivedDataWithRootObject(o);
  const color = c => archive($.NSColor.colorWithSRGBRedGreenBlueAlpha(c['Red Component'], c['Green Component'], c['Blue Component'], 1));
  const d = $.NSMutableDictionary.alloc.init;
  const map = {BackgroundColor: 'Background Color', TextColor: 'Foreground Color', TextBoldColor: 'Bold Color', CursorColor: 'Cursor Color', SelectionColor: 'Selection Color'};
  ['Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White'].forEach((n, i) => {
    map['ANSI' + n + 'Color'] = 'Ansi ' + i + ' Color';
    map['ANSIBright' + n + 'Color'] = 'Ansi ' + (i + 8) + ' Color';
  });
  for (const k in map) d.setObjectForKey(color(p[map[k]]), k);
  const [fontName, fontSize] = p['Normal Font'].split(' ');
  let font = $.NSFont.fontWithNameSize(fontName, Number(fontSize));
  for (let i = 0; i < 15 && font.isNil(); i++) { delay(1); font = $.NSFont.fontWithNameSize(fontName, Number(fontSize)); }
  if (font.isNil()) throw new Error('Font not available yet: ' + fontName + '. Run the command again.');
  d.setObjectForKey(archive(font), 'Font');
  const settings = {name: 'Catppuccin', type: 'Window Settings', ProfileCurrentVersion: 2.09,
    FontAntialias: true, UseBrightBold: true, CursorBlink: false, DynamicANSIForegroundColors: false};
  for (const k in settings) d.setObjectForKey(settings[k], k);
  const ints = {columnCount: 120, rowCount: 30, CursorType: 0};
  for (const k in ints) d.setObjectForKey($.NSNumber.numberWithInt(ints[k]), k);
  if (d.writeToFileAtomically(argv[1], true) == false) throw new Error('Could not write the Terminal profile');
}
EOF

terminal_prefs="$work/terminal-prefs.plist"
pb=/usr/libexec/PlistBuddy
defaults export com.apple.Terminal "$terminal_prefs"
"$pb" -c 'Add :"Window Settings" dict' "$terminal_prefs" 2>/dev/null || true
"$pb" -c 'Delete :"Window Settings":Catppuccin' "$terminal_prefs" 2>/dev/null || true
"$pb" -c 'Add :"Window Settings":Catppuccin dict' "$terminal_prefs"
"$pb" -c "Merge \"$work/terminal-profile.plist\" :\"Window Settings\":Catppuccin" "$terminal_prefs"
defaults import com.apple.Terminal "$terminal_prefs"
defaults write com.apple.Terminal "Default Window Settings" -string Catppuccin
defaults write com.apple.Terminal "Startup Window Settings" -string Catppuccin

print "Done. Quit and reopen iTerm2 and Terminal to see the new setup."
TERMINAL_SETUP
```

What it does:

- Installs Homebrew if it is missing (it asks for your password).
- Installs `starship`, `fzf`, `zoxide`, `eza`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, iTerm2 (unless it is already in `/Applications`) and JetBrains Mono Nerd Font.
- Writes `~/.zshrc`, `~/.zprofile` and `~/.config/starship.toml`. If you already have a different version of one of these, it is first saved next to it as `<file>.before-terminal-setup`.
- Adds the Catppuccin profile to iTerm2 and to Terminal and makes it the default in both. Terminal's other profiles are not changed.

You can run it again at any time; it doesn't change anything that's already set up. Quit and reopen iTerm2 and Terminal afterwards to see the theme.

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
