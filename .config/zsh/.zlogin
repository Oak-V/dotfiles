source "$ZDOTDIR/keyboard.sh"

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
eval "$(tree-sitter complete --shell zsh)"

source <(fzf --zsh)
