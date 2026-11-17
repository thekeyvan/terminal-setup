HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history hist_ignore_dups hist_ignore_space

export PATH="$HOME/Library/pnpm/bin:$PATH"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

alias ll='eza -lah --group-directories-first'
alias lt='eza --tree --level=2 --group-directories-first'

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
