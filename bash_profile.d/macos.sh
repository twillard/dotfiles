#!/bin/bash

# Only source this file on a macos machine
if [ $(uname) != "Darwin" ]; then return; fi

if [ -x $(which brew 2>/dev/null) ]; then
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
fi

if [ -f "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]; then
    . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
fi

# -------------------- Helpful Aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# Make the title something useful before invoking screen
alias screen="title \"$(hostname | cut -d. -f1)(screen)\"; screen"

if [ -d "~/Qt/5.6" ]; then
	export Qt5_DIR="~/Qt/5.6/clang_64"
fi

