#!/bin/bash

# Only source this file on a linux machine

# Check uname second, slower on Cygwin but won't get hit
if [ $(uname) != "Linux" ]; then return; fi

alias mstsc="rdesktop -u $USER -d SANDVINE -g1024x768 -5 -K -r clipboard:CLIPBOARD"

# -------------------- Helpful Aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias who_owns="rpm -q --whatprovides"

# Make the title something useful before invoking screen
alias screen="title \"$(hostname | cut -d. -f1)(screen)\"; screen"

function extract_rpm()
{
    rpm2cpio $1 | cpio -idmv
}

