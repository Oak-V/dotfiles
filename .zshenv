trap '' INT
export ZDOTDIR="${HOME}/.config/zsh"
source "${ZDOTDIR}/.zshenv"
trap - INT
