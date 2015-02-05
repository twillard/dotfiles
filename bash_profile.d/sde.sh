#!/bin/bash

# Quick exit if cygwin - forking is expensive, use PATH to quickly determine if
# we're cygwin and bail before we start checking uname
if [[ $PATH =~ "cygwin" ]]; then return; fi

# Only source this file on an SDE (any Linux machine without /view)
if [ $(uname) != "Linux" -o -d /view ]; then return; fi
if [[ $(hostname) =~ "VirtualBox" ]]; then return; fi

# Slightly modify the title that's set by the PROMPT_COMMAND
export PROMPT_TITLE="$PROMPT_TITLE(SDE)"

export TPC_IN_SAME_WINDOW=1

# -------------------- Helpful Aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias who_owns="rpm -q --whatprovides"

