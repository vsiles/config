set -gx PATH $PATH /opt/local/bin /opt/local/sbin
set -gx PATH $PATH:/Applications/WezTerm.app/Contents/MacOS/
set -gx PATH $PATH:$HOME/Downloads/nvim-macos/bin/

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ls "ls --color"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
end

function rm --description "safe rm"
    command rm -i $argv
end

# start ssh-agent
fish_ssh_agent
set -gx RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin # for code

# file explorer
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
