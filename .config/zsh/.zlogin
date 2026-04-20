echo ".zlogin"

if [[ -n "$TMUX" ]]; then
	:
else
	if tmux has-session 2>/dev/null; then
		tmux attach || true
	else
		tmux new-session -s default || true
	fi
fi

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

bindkey -v

bindkey -s '\033[A' ''   
bindkey -s '\033[B' ''   
bindkey -s '\033[D' ''   
bindkey -s '\033[C' ''   

