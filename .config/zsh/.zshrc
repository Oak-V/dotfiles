source "$ZDOTDIR/antidote.sh"

export GPG_TTY="$(tty)"

unset SSH_AGENT_PID
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
