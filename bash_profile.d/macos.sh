#!/bin/bash

# Only source this file on a macos machine
if [ $(uname) != "Darwin" ]; then return; fi

if [ -x $(which brew 2>/dev/null) ]; then
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
fi

# -------------------- Helpful Aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# Make the title something useful before invoking screen
alias screen="title \"$(hostname | cut -d. -f1)(screen)\"; screen"

