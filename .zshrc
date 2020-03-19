#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '\C-[[A' history-beginning-search-backward-end
bindkey '\C-[[B' history-beginning-search-forward-end
bindkey '^[OB' history-beginning-search-forward-end
bindkey '^[OA' history-beginning-search-forward-end
bindkey '^[OB' history-beginning-search-backward-end

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

# Command history
export HISTSIZE=1024
export SAVEHIST=512
export HISTFILE=~/.zsh_history
#
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_PUSHD

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# Let's split paths by '/'
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# autoload -U colors
#colors
#
function node_jobs () {
	squeue -S T,P,-S,-i -o "%i %P %j %u %C %D %m %f %t %M %l %e %R" -w $*
}

function pending_jobs () {
	squeue --format="%8Q %.12i %.9P %.8j %.8u %.19S %.4D %12Y %R" --sort=SQ --states=PENDING $*
}

function running_jobs () {
	squeue --format="%.8u %.12i %.9P %.12j %.19S %e %.4D %24N" --sort=N,S --states=RUNNING $*
}

function notok () {
	sinfo -h -t DRAIN,DOWN -o "%N        %6t %17E %19H"
#	sinfo -h --list-reasons -t DRAIN
}

function man () {
	LC_CTYPE=en_DK.iso88591 /usr/bin/man $*
}

export PS1="%n@%B%m%b:%~%#"

function precmd () {
	print -P "\033k%n@%m:%~\033\\"
}

# Aliases
alias psc='ps xawf -eo pid,user,cgroup,args'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

