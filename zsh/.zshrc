# Default prompt host color for pure theme and tmux statusbar.
# You may want to have different color per machine (use ANSI color name or xterm color codes [0-255]).
#   - https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# The PROMPT_HOST_COLOR variable can be inherited from a parent shell, tmux, or SSH session.
if [[ -z "$PROMPT_HOST_COLOR" ]]; then
  export PROMPT_HOST_COLOR="6" # cyan
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'archive' \
  'rsync' \
  'completion' \
  'prompt' \
  'fasd' \
  'ruby' \
  'git'

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load
autoload -Uz promptinit && promptinit && prompt powerlevel10k

# User configuration

# export LANG=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:~/.local/bin:~/.bin

export HISTFILE=~/.zsh_history
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
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

if [[ $TERM_PROGRAM == 'vscode' ]]; then
  export GIT_EDITOR='code --wait'
fi

export PYTHONSTARTUP=$HOME/.pythonrc.py

# .zshrc.local
if [[ -s ~/.zshrc.local ]]; then
  source ~/.zshrc.local
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
alias help='run-help'
alias ls='lsd'
alias l='lsd -l --date="+%y-%m-%d %H:%M" --group-directories-first'
alias la='lsd -al --date="+%y-%m-%d %H:%M" --group-directories-first'
alias lt='l -t'
alias ll='lsd -Al --date="+%y-%m-%d %H:%M" --group-directories-first'
alias llt='ll -t'
alias mv='mv -iv'
alias cp='cp -iv'
alias cpr='rsync -aAX --info=progress2'
alias rm='rm -v'
if command -v nvim 2>&1 >/dev/null; then
  alias vi='nvim'
  alias vim='nvim'
fi
alias grep='grep --color=auto'
alias t='tmux'
alias ta='tmux attach'
alias top='htop'
alias topc='htop -s PERCENT_CPU'
alias topm='htop -s PERCENT_MEM'
alias s='solve'
alias reload='exec zsh'
alias run='solve run --copytool copy'
alias get='solve get'
if [[ $TERM_PROGRAM == 'vscode' ]]; then
  alias wa='solve diff -t "code --diff"'
  alias tc='solve tc -t code'
else
  alias wa='solve diff -t "nvim -d"'
  alias tc='solve tc -t nvim'
fi
alias pip='python -m pip'
alias pip3='python3 -m pip'
alias py='python'
alias py3='python3'
alias ipython='python -m IPython --no-confirm-exit'
alias ipy='ipython'
alias ptpython='python -m ptpython'
alias ptipython='python -m ptpython.entry_points.run_ptipython'
alias ptpy='ptipython'
alias pt='ptpy'

# Aliases for FASD
#
# @see https://github.com/clvv/fasd
eval "$(fasd --init auto)"
alias a='fasd -a'
alias s='fasd -si'
alias d='fasd -d'
alias f='fasd -f'
alias sd='fasd -sid'
alias sf='fasd -sif'
alias z='fasd_cd -d'
alias zz='fasd_cd -d -i'

# X11
if grep -qi microsoft /proc/version; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
elif [[ $SSH_CLIENT ]]; then
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
    local num_cols=$(stty size | cut -d" " -f2)
    if [[ $num_lines -gt 25 ]]; then num_lines=$((num_lines - 5)); fi  # more margin
    if [[ $num_cols -lt 100 ]]; then num_lines=10; fi
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
function site-packages() {
    # print the path to the site packages from current python environment,
    # e.g. ~/.anaconda3/envs/XXX/lib/python3.6/site-packages/

    local base=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
    if [[ -n "$1" ]] && [[ ! -d "$base/$1" ]]; then
        echo "Does not exist: $base/$1" >&2;
        return 1
    else
        echo "$base/$1"
    fi;
}

# WSL
if [[ -d /usr/lib/wsl/lib ]] then
  export PATH=$(echo $PATH | tr ':' '\n' | grep -v '^/mnt/c' | tr '\n' ':' | sed 's/:$//'):/mnt/c/Windows
  export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH
  alias open=explorer.exe
fi
