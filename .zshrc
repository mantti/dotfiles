# emacs keybinds in commandline editing
bindkey -e 

# Check other mailboxes
mailpath=(~/Mail/private'?New private mail'
		  ~/Mail/root'?New root mail') 

# Name some directories to shorten promp mainly
#hash -d lsrc=/usr/local/src

# set command prompt
PS1="%n@%B%m%b:%~%#"
# Command history
export HISTSIZE=10240
export SAVEHIST=10240
export HISTFILE=~/.zsh_history
export PATH="$HOME/bin:$PATH"
export CDPATH="/home/manttila/src/ops:/home/manttila/src/dev"

# {{{ Set some zsh options{{{}}}
# Every instance adds its own commands to history
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY
# Don't leave duplicate lines to history
setopt HIST_IGNORE_ALL_DUPS
# Remove unnecessary blanks before saving
setopt HIST_REDUCE_BLANKS
# Don't save history commands
setopt HIST_NO_STORE
# Don't save function definitions
#setopt HIST_NO_FUNCTIONS
# Don't beep on end of list
setopt NO_HIST_BEEP

# Don't autonice bg:ed processes
setopt NO_BG_NICE
# Don't kill bg-jobs on exit
setopt NO_HUP 
# No error on empty globs in commandline
setopt CSH_NULL_GLOB
# Don't beep on anything
setopt NO_BEEP
# use command correction
setopt CORRECT
# save directory hierarchy to stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
# Also complete commands inside aliases
setopt COMPLETEALIASES
# }}}

# set size of directory stack
export DIRSTACKSIZE=32

# Some generic variables
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR=vim
export PAGER=less
# Don't clear page after reading man-page and show ansi colorcodes etc
export LESS="-gRXQ" 
# Default folder for python virtualenvs
export WORKON_HOME=~/Envs

# Show git repo status on prompt when in repo-directory
autoload -Uz vcs_info
# This needs prompt_subst set, hence the name. So:
setopt prompt_subst
# PS1='%!-%3~ ${vcs_info_msg_0_}%# 
PS1="%n@%B%m%b:%~ ${vcs_info_msg_0_}%#"

# to enable history-beginning-search-backward-end 
autoload history-search-end

# {{{ Correct some keybindings
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
#bindkey '\e[A' history-beginning-search-backward-end
bindkey '^[OA' history-beginning-search-backward-end
#bindkey '\e[B' history-beginning-search-forward-end
bindkey '^[OB' history-beginning-search-forward-end
bindkey '^[[A'  history-beginning-search-backward-end
bindkey '^[[B'  history-beginning-search-forward-end
bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e^_' copy-prev-shell-word
bindkey '\eq' push-line-or-edit
#bindkey -s ^X /usr/local/src
# }}}

# Make ssh-command completion use only Host -parameter from ssh_config not Hostname
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users

# Use new completion
autoload -U compinit
compinit

# Use gits completion also for dotfiles-alias
compdef dotfiles=git
add-zsh-hook chpwd _git_dotfiles
# {{{ Load possible aliases 
if [[ -r ~/share/aliases ]]; then
  . ~/share/aliases
fi
if [[ -r ~/.aliases ]]; then
  . ~/.aliases
fi
# }}}

# Add own zsh functions
fpath+=('~/share/zshfunctions')
autoload beep oss

[[ -z ${LS} ]] && LS="ls --color=auto --group-directories-first"

function mcd() {mkdir $1 && cd $1}
function ll() {
        "${LS}" --group-directories-first --color -hCNl $* | less -EiMqrwX
}
function la() {
        ${LS} --color -hCNa $* | less -EiMqrwX
}
function lla() {
        ${LS} --color -hCNla $* | less -EiMqrwX
}

function monitors() {
	xrandr --current | grep ' connected'
}
# {{{ Running keychain if config found
[[ -r ${HOME}/.keychain/my_keys ]] && \
keychain --nogui --quick `cat ${HOME}/.keychain/my_keys`

[[ -r ${HOME}/.keychain/`uname -n`-sh ]] && \
	. ${HOME}/.keychain/`uname -n`-sh
keychain_cmd="$(which keychain)"

#if [ -n "${keychain_cmd}" ]; then
#eval $("${keychain_cmd}" --quiet --eval --agents ssh,gpg id_rsa)
#fi
SSH_AUTH_SOCKET=$(gpgconf --list-dirs | awk -F: '/agent-ssh-socket/{print $2}')
export SSH_AUTH_SOCKET
# }}}

# {{{ Load some OS specific settings if available
[[ -r ${HOME}/share/zsh_paths ]] && \
	. ${HOME}/share/zsh_paths
# }}}

# {{{ Check if we are under chroot
[[ -n ${SCHROOT_USER} ]] && export PS1="%n@%B%m%b-(chroot):%~%#"
# }}}

# I have moved .cache to /dev/shm on lyijykerttu and it needs to be created after reboot
if [[ "`hostname -s`" -eq "Telli" ]]
then
       [[ ! -d /dev/shm/.cache ]] && mkdir /dev/shm/.cache
fi

# We want to gpg-agent instead of ssh-agent for yubikey
unset SSH_AGENT_PID
export GPG_TTY=$(tty)
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Load custom ls-colors
[[ -r ~/share/my_dir_colors ]] && source ~/share/my_dir_colors

# Load custom git-friendly prompt
[[ -r ~/share/git-prompt.zsh ]] && source ~/share/git-prompt.zsh
[[ -r ~/share/pure.zsh ]] && source ~/share/pure.zsh

# load zsh completion for openstack
[[ -r ~/share/openstack-complete ]] && source ~/share/openstack-complete
