#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=$PATH:~/.local/bin:~/bin

shopt -s histappend
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export GPG_TTY=$(tty)

alias ls='ls --color=auto'
PS1='\[\e[m\][\u@\h \W]\[\e[93m\]\$\[\e[m\] '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias c='clear'
alias e="$EDITOR"
alias E="nvim -u NONE"
alias ls='lsd'
alias l='lsd -l'
alias ll='lsd -Al'
alias mv='mv -i'
alias cp='cp -i'
alias vi='nvim'
alias grep='grep --color=auto'
alias tmux='tmux -2'
alias cat='pygmentize -g -O style=dracula'
alias s='solve'
alias run='solve run'
alias get='solve get'

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

export FZF_ALT_C_COMMAND='fd --type directory --hidden | sed -En "s/\.\///; /^\\./{H;bL}; p; :L \${g;s/^\\n//;T;p}"'
