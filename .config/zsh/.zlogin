source "$ZDOTDIR/keyboard.sh"

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
eval "$(tree-sitter complete --shell zsh)"
eval "$(opencode completion)"

source <(fzf --zsh)

gsrc "$ZDOTDIR/.secret.token.sh.gpg"
