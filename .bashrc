if [ -f /opt/facebook/hg/share/scm-prompt ]; then
  source /opt/facebook/hg/share/scm-prompt
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# User specific aliases and functions for all shells
export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim
alias rm='rm -i'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


function parse_hg_branch {
  if [[ -n $(_scm_prompt) ]]; then
    # wrap in parens
    echo "$(_scm_prompt)"
  fi
}

# Show current hg bookmark
function hgproml {
  # here are a bunch of colors in case
  # you want to get colorful
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local RESET_COLOR="\[\033[0m\]"

  export PS1="\
$GREEN[\u@\h:\w$LIGHT_GRAY\$(parse_hg_branch)$GREEN]\
\n\$$RESET_COLOR "
  PS2='> '
  PS4='+ '
}
hgproml

export PROMPT_DIRTRIM=2 # doesnt work on macos, need to rebuild/homebrew a more recent one

# enable color support of ls and also add handy aliases
alias ls='ls -G'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# TODO.txt program
#export TODOPATH=/home/vsiles/BackUpExclusion/programs/todo.txt_cli-2.10
#alias todo="$TODOPATH/todo.sh -d $TODOPATH/todo.cfg"
#alias t="todo"
#alias hgcommiters='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'

MYSHREG="¯\_(ツ)_/¯"

alias mydevserver='mosh -6 devserver'
# alias mydevserver='et $USER.sb.facebook.com:8080 -t="8377:8377"'
alias mydevfwport='ssh -N -f sandbox-clipper'
alias mybigserver='mosh -6 bigserver'
alias myscratch='vim $HOME/Documents/scratch.org'
alias fair_tunnel='et fairdev:8080 --jport 8080 -t 4321:4321,1250:22'

export LC_ALL='en_US.UTF-8'

alias keynote_code='pbpaste | highlight -S py -O rtf | pbcopy'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export qtpath=/usr/local/Cellar/qt@4/4.8.7_5

alias love='/Applications/love.app/Contents/MacOS/love'

# for leanproject
export PATH="$PATH:/Users/vsiles/Library/Python/3.7/bin"

# scala
export PATH="$PATH:/Users/vsiles/Library/Application Support/Coursier/bin"

function coq {
    cd ~/Documents/work/ReaLM/Coq
}

function shack {
    coq
    cd shack
}
