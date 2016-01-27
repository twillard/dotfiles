#!/bin/bash

# Quick exit if cygwin - forking is expensive, use PATH to quickly determine if
# we're cygwin and bail before we start checking uname
if [[ $PATH =~ "cygwin" ]]; then return; fi

# Only source this file on an SDE
if [ $(uname) != "Linux" ]; then return; fi
if ! rpm -q svsde >/dev/null 2>/dev/null; then return; fi

# Slightly modify the title that's set by the PROMPT_COMMAND
export PROMPT_TITLE="$PROMPT_TITLE(SDE)"

export TPC_IN_SAME_WINDOW=1

# -------------------- Helpful Aliases

