# emacs keybinds in commandline editing
bindkey -e 

# Check other mailboxes
mailpath=(~/Mail/private'?New private mail'
		  ~/Mail/root'?New root mail') 

# Name some directories to shorten promp mainly
hash -d lsrc=/usr/local/src

# Command history
export HISTSIZE=1024
export SAVEHIST=512
export HISTFILE=~/.zsh_history
export PATH="$HOME/bin:$PATH"

# Tell ruby to search also home-directory for gems
export RUBYLIB="$HOME/.local/lib/ruby"

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
# }}}

# set size of directory stack
export DIRSTACKSIZE=32

# Some generic variables
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR=vim
export PAGER=less

# to enable history-beginning-search-backward-end 
autoload history-search-end

# Enable editing commandline in EDITOR
autoload edit-command-line

# {{{ Correct some keybindings
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N edit-command-line
bindkey '^[OA' history-beginning-search-backward-end
bindkey '\e[A' history-beginning-search-backward-end
bindkey "key[Up]" history-beginning-search-backward-end
bindkey '^[OB' history-beginning-search-forward-end
bindkey '\e[B' history-beginning-search-forward-end
bindkey "key[Down]" history-beginning-search-forward-end
bindkey "key[Delete]" delete-char
bindkey "key[Home]" beginning-of-line
bindkey "key[End]" end-of-line
bindkey '\e^_' copy-prev-shell-word
bindkey '\eq' push-line-or-edit
bindkey "\ee" edit-command-line
#bindkey -s ^X /usr/local/src
# }}}

# Use new completion
autoload -U compinit
autoload -Uz vcs_info
compinit

zstyle ':vcs_info:git*' formats "%r/%S [%b%m%u%c] "
zstyle ':vcs_info:git*' actionformats "%r/%S [%b|%a%m%u%c] "
# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
# # Set the format of the Git information for vcs_info
# zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
# zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# {{{ Load possible aliases 
if [[ -r ~/share/aliases ]]; then
  . ~/share/aliases
fi
if [[ -r ~/.aliases ]]; then
  . ~/.aliases
fi
# }}}

# Add own zsh functions
fpath=(~/share/zshfunctions $fpath)
autoload beep

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

# {{{ Running keychain if config found
[[ -r ${HOME}/.keychain/my_keys ]] && \
keychain --nogui --quick `cat ${HOME}/.keychain/my_keys`

[[ -r ${HOME}/.keychain/`uname -n`-sh ]] && \
	. ${HOME}/.keychain/`uname -n`-sh
# }}}

# {{{ Load some OS specific settings if available
[[ -r ${HOME}/share/zsh_paths ]] && \
	. ${HOME}/share/zsh_paths
# }}}

function precmd() {
	# For displaying git repo info on prompt
	vcs_info
	if [[ -z ${vcs_info_msg_0_} ]]; then
		# Ok, not in vcs directory, so let's use normal prompt
        printf "\033]0;%s@%s:%s\007"
		PS1="%n@%B%m%b:%5~%#"
	else
		# Will use different prompt if on git repo directory
        printf "\033]0;%s@%s:%s\007"
		PS1="%n@%B%m%b:${vcs_info_msg_0_}%#"
	fi
}

# {{{ Check if we are under chroot
[[ -n ${SCHROOT_USER} ]] && PS1="%n@%B%m%b-(chroot):%~%#"
# }}}

# Load custom ls-colors
[[ -r ~/share/my_dir_colors ]] && source ~/share/my_dir_colors
