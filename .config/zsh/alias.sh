ITALIC=$(tput sitm)
R_ITALIC=$(tput ritm)

BOLD=$(tput bold)
R_BOLD=$'\e[22m'

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
R_COLOR=$(tput op)

red() {
  echo "$RED$@$R_COLOR"
}

green() {
  echo "$GREEN$@$R_COLOR"
}

blue() {
  echo "$BLUE$@$R_COLOR"
}

italic() {
  echo "$ITALIC$@$R_ITALIC"
}

bold() {
  echo "$BOLD$@$R_BOLD"
}

log.info() {
   echo "\n$(italic "$(blue "Info:")") $@\n"
}

log.error() {
   echo "\n$(bold "$(red "Error:")") $@\n"
}

alias x="gxargs"

_.gpgedit() {
   set -uo pipefail

   local file="${1:?usage: gedt file.gpg}"
   local run="${2:-0}"

   umask 077

   local tmp=$(mktemp)
   trap 'rm -f "'"$tmp"'"' EXIT

   gpg --yes --quiet -d -o "$tmp" "$file"

   nvim -n -c 'set ft=sh' "$tmp"

   [[ "$run" == "1" ]] && source "$tmp" 2> /dev/tty

   gpg --yes --quiet -e -r "${GPG_ENCR_SUBKEY:-$GPG_DEFAULT_ENCR_SUBKEY}" -o "$file" "$tmp"
}
alias gedt=" _.gpgedit"

_.gpgsource() {
   set -uo pipefail

   local file="${1:?usage: gsrc file.gpg}"

   source <(gpg --quiet -d "$file")
}

alias gsrc=" _.gpgsource"

alias shl=" ssh-add -L"
alias ggd=" gpg --delete-secret-keys ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY}\!"
alias gge=" gpg --export --armor ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY}"
alias gges=" gpg --export-secret-keys --armor"
alias ggl=" gpg --list-keys --with-subkey-fingerprints --with-keygrip ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY}"
alias ggls=" gpg --list-secret-keys --with-subkey-fingerprints --with-keygrip ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY}"
alias ggqs=" gpg --quick-add-key ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY} ${GPG_KIND:-$GPG_DEFAULT_KIND} sign ${GPG_EXPIRATION:-$GPG_DEFAULT_EXPI}"
alias ggqa=" gpg --quick-add-key ${GPG_PRIMARY_KEY:-$GPG_DEFAULT_PRIMARY_KEY} ${GPG_KIND:-$GPG_DEFAULT_KIND} auth ${GPG_EXPIRATION:-$GPG_DEFAULT_EXPI}"

alias brew="log.error use brew helpers $(italic \(e.g. bw, bwi and bwr\)).; return 1;"


bw() {
   local command="${1:-}"

   case $command in
      install|remove)
         trap '\brew bundle dump --file ~/.Brewfile --force &> /dev/null; log.info brew bundle $(bold updated).' EXIT
         ;;
      *)
         log.info brew bundle update $(bold skipped).
         ;;
   esac


   \brew $@
}

alias bwi="bw install"
alias bwr="bw remove"


alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias oa="env -i open -a"
alias oas="oa Safari"
alias oak="oa /System/Library/CoreServices/Applications/'Keychain Access.app'"

alias exit="log.error use tmux.; return 1;"
alias e="tmux detach"
alias ee="tmux kill-session"

alias c="clear"

alias vi="log.error use nvim.; return 1;"
alias nano="log.error use nvim.; return 1;"
alias vim="log.error use nvim.; return 1;"
alias v="nvim"

alias diff="log.error use delta.; return 1;"
alias d="delta"

alias cat="log.error use bat.; return 1;"
alias b="bat"

alias .hist="b ~/.zsh_history"

alias grep="log.error use rg.; return 1;"
alias r="rg"

alias cd="log.error use zoxide.; return 1;"

alias find="log.error use fzf.; return 1;"
alias f="fzf"

alias code="opencode"

alias .zshrc="v ~/.config/zsh/.zshrc && source ~/.config/zsh/.zshrc"
alias .zshenv="v ~/.config/zsh/.zshenv && source ~/.config/zsh/.zshenv"
alias .zprofile="v ~/.config/zsh/.zprofile && source ~/.config/zsh/.zprofile"
alias .zlogout="v ~/.config/zsh/.zlogout && source ~/.config/zsh/.zlogout"
alias .zlogin="v ~/.config/zsh/.zlogin && source ~/.config/zsh/.zlogin"
alias .zalias="v ~/.config/zsh/alias.sh && source ~/.config/zsh/alias.sh"
alias .startship="v ~/.config/startship/starship.toml"
alias .alacritty="v ~/.config/alacritty/alacritty.toml"
alias .gitignore="v ~/.gitignore"
alias .gitconfig="v ~/.gitconfig"
alias .tmux="v ~/.config/tmux/tmux.conf && tmux source ~/.config/tmux/tmux.conf"
alias .nvim="v ~/.config/nvim/init.lua"
alias .hammerspoon="v ~/.hammerspoon/init.lua"
alias .update="v ~/.bin/update.sh && source ~/.bin/update.sh && update"

alias ls="log.error use eza.; return 1;"

alias l="eza --group-directories-first --show-symlinks --icons --hyperlink --group --smart-group --header --octal-permissions --git --git-repos --flags"
alias lg="l --git-ignore"

alias ll="l --long"
alias llg="ll --git-ignore"

alias la="l --all --all"
alias lag="la --git-ignore"

alias lla="la --long"
alias llag="lla --git-ignore"

alias lt="l --tree"
alias ltg="lt --git-ignore"

alias llt="lt --long"
alias lltg="llt --git-ignore"

alias lat="lt --all"
alias latg="lat --git-ignore"

alias llat="lat --long"
alias llatg="llat --git-ignore"

alias lx="eza -1 --icons=never --color=never"
