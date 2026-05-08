export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export MANPAGER="sh -c 'ansifilter | bat -plman'"
export FZF_DEFAULT_OPTS="--walker-skip .git,node_modules,target,.ssh,.gnupg
      --tmux
      --style minimal
      --preview 'b --color=always {}'"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export EZA_CONFIG_DIR="$HOME/.config/eza/"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=100000

export PAGER=less

export PATH="$HOME/.local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

export PATH="$(brew --prefix curl)/bin:$PATH"
export PATH="$(brew --prefix ffmpeg-full)/bin:$PATH"

source "$ZDOTDIR/.secret.pii.sh"
source "$ZDOTDIR/alias.sh"
source "$ZDOTDIR/gpg.sh"

disable log

setopt COMBINING_CHARS

setopt BEEP
setopt HIST_BEEP
setopt LIST_BEEP

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_LEX_WORDS
