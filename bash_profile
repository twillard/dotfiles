# .bash_profile

# REMEMBER: forking is really expensive in cygwin.  Don't fork as much as
# possible in here to speed-up cygwin startup

# -------------------- Import bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# -------------------- Path

prepend_to_path() {
    if [[ ! ":$PATH:" =~ ":$1:" ]]; then
        echo "$1:$PATH"
    else
        echo "$PATH"
    fi
}

append_to_path() {
    if [[ ! ":$PATH:" =~ ":$1:" ]]; then
        echo "$PATH:$1"
    else
        echo "$PATH"
    fi
}

export PATH="$(append_to_path "$HOME/bin")"
export PATH="$(append_to_path "$HOME/.local/bin")"
export PATH="$(append_to_path "/root/bin")"
export PATH="$(append_to_path "/sbin")"
export PATH="$(prepend_to_path "/opt/local/bin")"
export PATH="$(prepend_to_path "/opt/local/sbin")"
export PATH="$(prepend_to_path "/usr/local/bin")"
export PATH="$(prepend_to_path "/usr/local/sbin")"
export PATH="$(prepend_to_path "$HOME/.fastlane/bin")"

export LC_COLLATE=C
export EDITOR="vim"

# vim: set ts=2 sw=2 et:
