# BEGIN: Block added by chef, to set environment strings
# Please see https://fburl.com/AndroidProvisioning if you do not use bash
# or if you would rather this bit of code 'live' somewhere else
. ~/.fbchef/environment
# END: Block added by chef

export EDITOR=vim
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home

export FBANDROID_DIR=/Users/vsiles/fbsource/fbandroid
alias quicklog_update=/Users/vsiles/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${JAVA_HOME}/bin:${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
echo "Welcome to Facebook."

# opam configuration
test -r /Users/vsiles/.opam/opam-init/init.sh && . /Users/vsiles/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

export PATH="$HOME/.elan/bin:$PATH"

# because Appel is stupid...
export BASH_SILENCE_DEPRECATION_WARNING=1

##
# Your previous /Users/vsiles/.bash_profile file was backed up as /Users/vsiles/.bash_profile.macports-saved_2020-01-15_at_11:40:55
##

# MacPorts Installer addition on 2020-01-15_at_11:40:55: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/vsiles/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/vsiles/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/vsiles/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/vsiles/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

