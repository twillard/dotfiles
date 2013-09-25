#!/bin/bash

# Only source this file in a Cygwin terminal - check for 'cygwin' somewhere in
# the path.  Normally we'd check uname, but forking is expensive
if [[ ! $PATH =~ "cygwin" ]]; then return; fi

# -------------------- Make sure lab view is fully started
if [ ! -d /m/${USER}_lab ]; then
    cleartool startview ${USER}_lab >/dev/null
fi

if [ ! -d /m/${USER}_lab/Documents ]; then
    cleartool mount -a >/dev/null
fi

export vsde="10.253.2.20"

# -------------------- Helpful Aliases (Cygwin)

# Make the title something useful before invoking screen
alias screen="title \"${HOSTNAME%%.*}(screen)\"; screen"

# Cygwin versions of ls and grep aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto --group-directories-first"

alias hh="TPC_IN_SAME_WINDOW=1 h"

alias ccolab="/c/programs/codecollabclient/ccollab"
alias tcl="_tcl"

alias astyle="$(which astyle) -m0 -M120 -s4 --mode=c --align-reference=type --align-pointer=type --convert-tabs --add-brackets --indent-preprocessor --style=bsd"

