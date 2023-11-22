set -gx PATH $PATH /opt/local/bin /opt/local/sbin
set -gx PATH $PATH:/Applications/WezTerm.app/Contents/MacOS/
set -gx PATH $PATH:$HOME/Downloads/nvim-macos/bin/

function rm --description "safe rm"
    command rm -i $argv
end

alias vim /opt/local/bin/vim

alias ls "ls --color"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some ssh/mosh aliases
alias mydevserver='mosh -6 devserver'
alias mybigserver='mosh -6 bigserver'

set -gx RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
