eval "$(/opt/homebrew/bin/brew shellenv zsh)"

if [[ -n "$TMUX" ]]; then
    export ZDOTDIR="${HOME}/.config/zsh/"
fi

