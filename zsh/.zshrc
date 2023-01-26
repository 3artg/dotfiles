# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
#
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# plugins
plugins=(
  fzf
  git
  python
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export LANG=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=$PATH:~/.local/bin:~/.bin

# shopt -s histappend
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

export EDITOR=nvim
export ZVM_VI_EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export GPG_TTY=$(tty)

export FZF_BASE=~/.fzf
export FZF_DEFAULT_COMMAND='fd'
export FZF_ALT_C_COMMAND='fd -L --type directory --hidden | sed -En "s/\.\///; /^\\./{H;bL}; p; :L \${g;s/^\\n//;T;p}"'

if [[ $TERM_PROGRAM == 'vscode' ]]; then
  export GIT_EDITOR='code --wait'
fi

alias c='clear'
alias ca='conda activate'
alias du1='du -hd1 | sort -h'
alias df='df -h'
alias e="$EDITOR"
alias E="nvim -u NONE"
alias g='git'
alias gh='ghn'
alias ghA='gh --all'
alias gha='gh --exclude=refs/stash --all'
alias github='\gh'
alias gs="git status"
alias ls='lsd'
alias l='lsd -l --date="+%y-%m-%d %H:%M" --group-directories-first'
alias ll='lsd -Al --date="+%y-%m-%d %H:%M" --group-directories-first'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -v'
alias vi='nvim'
alias grep='grep --color=auto'
alias t='tmux'
alias s='solve'
alias run='solve run --copytool copy'
alias get='solve get'
if [[ $TERM_PROGRAM == 'vscode' ]]; then
  alias wa='solve diff -t "code --diff"'
  alias tc='solve tc -t code'
else
  alias wa='solve diff -t "nvim -d"'
  alias tc='solve tc -t nvim'
fi

# X11
if grep -qi microsoft /proc/version; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
elif [[ $SSH_TTY ]]; then
  export DISPLAY=localhost:10.0
else
  export DISPLAY=0:0
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zvm_after_init_commands+=(
  '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
  "bindkey '^[[A' up-line-or-search"
  "bindkey '^[[B' down-line-or-search"
)

# Anaconda3
# see ~/.zshenv for $CONDA_EXE detection
function _conda_initialize() {
# >>> conda initialize >>>
if [ -n "${CONDA_EXE}" ]; then
  ${CONDA_EXE} config --set auto_activate_base false
  __conda_setup="$(${CONDA_EXE} 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  fi
  unset __conda_setup
fi
# <<< conda initialize <<<
}

# Note: conda initialize is slow (0.3 sec), so execute lazily
conda() {
  unfunction conda
  _conda_initialize
  conda "$@"
}

function ghn() {
    # git history, but truncate w.r.t the terminal size. Assumes not headless.
    # A few lines to subtract from the height: previous prompt (2) + blank (1) + current prompt (2)
    local num_lines=$(($(stty size | cut -d" " -f1) - 5))
    if [[ $num_lines -gt 25 ]]; then num_lines=$((num_lines - 5)); fi  # more margin
    git history --color=always -n$num_lines "$@" | head -n$num_lines | less --QUIT-AT-EOF -F
}

# pip
function pip-search() {
  (( $+commands[pip_search] )) || python -m pip install pip_search
  pip_search "$@"
}
# some useful fzf-grepping functions for python
function pip-list-fzf() {
  pip list "$@" | fzf --header-lines 2 --reverse --nth 1 --multi | awk '{print $1}'
}
function pip-search-fzf() {
  # 'pip search' is gone; try: pip install pip_search
  if ! (( $+commands[pip_search] )); then echo "pip_search not found (Try: pip install pip_search)."; return 1; fi
  if [[ -z "$1" ]]; then echo "argument required"; return 1; fi
  pip-search "$@" | fzf --reverse --multi --no-sort --header-lines=4 | awk '{print $3}'
}
function conda-list-fzf() {
  conda list "$@" | fzf --header-lines 3 --reverse --nth 1 --multi | awk '{print $1}'
}
function pipdeptree-fzf() {
  python -m pipdeptree "$@" | fzf --reverse
}
function pipdeptree-vim() {   # e.g. pipdeptree -p <package>
  python -m pipdeptree "$@" | vim - +"set ft=config foldmethod=indent" +"norm zR"
}
