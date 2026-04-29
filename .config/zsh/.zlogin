source "$ZDOTDIR/keyboard.sh"

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

source <(fzf --zsh)
