# emacs keybinds in commandline editing
bindkey -e 

# Check other mailboxes
mailpath=(~/Mail/private'?New private mail'
		  ~/Mail/root'?New root mail') 

# Name some directories to shorten promp mainly
hash -d lsrc=/usr/local/src

# set command prompt
PS1="%n@%B%m%b:%~%#"
# Command history
export HISTSIZE=1024
export SAVEHIST=512
export HISTFILE=~/.zsh_history
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME=/run/user/${UID}
export TERMINAL=alacritty

# Use "proper" date and time formats
export LC_TIME=en_DK.utf8

# {{{ Set some zsh options
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
# Allow aliases to expanded before completion
setopt COMPLETEALIASES
# Don't wait for double tab for ambiguous completions
setopt AUTO_LIST
# }}}

# set size of directory stack
export DIRSTACKSIZE=32

# Some generic variables
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR=vim
export PAGER=less

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
# }}}

# Use new completion
autoload -U compinit
compinit

# Load some completion settins
[[ -r ~/.zsh_completion ]] && source ~/.zsh_completion

# {{{ Load possible aliases 
if [[ -r ~/.aliases ]]; then
  . ~/.aliases
fi
# }}}

# Add own zsh functions
[[ -d ~/.zsh_functions ]] && fpath=(~/.zsh_functions $fpath)

[[ -z ${LS} ]] && LS=ls

function mcd() {mkdir $1 && cd $1}
function ll() {
        ${LS} --color -hCNl $* | less -EiMqrwX
}
function la() {
        ${LS} --color -hCNa $* | less -EiMqrwX
}
function lla() {
        ${LS} --color -hCNla $* | less -EiMqrwX
}

function mcd() {mkdir $1 && cd $1}

# {{{ Running keychain if config found
[[ -r ${HOME}/.keychain/my_keys ]] && \
keychain --nogui --quick `cat ${HOME}/.keychain/my_keys`

[[ -r ${HOME}/.keychain/`uname -n`-sh ]] && \
	. ${HOME}/.keychain/`uname -n`-sh
# }}}

# {{{ Check if we are under chroot
[[ -n ${SCHROOT_USER} ]] && export PS1="%n@%B%m%b-(chroot):%~%#"
# }}}

# Load custom ls-colors
[[ -r ~/.my_dir_colors ]] && source ~/.my_dir_colors
