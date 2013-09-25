#!/bin/bash

# Only source this file on a build machine

# Check for /view quick - no forks, fast on Cygwin
if [ ! -d /view ]; then return; fi

# Check uname second, slower on Cygwin but won't get hit
if [ $(uname) != "Linux" ]; then return; fi

# Force 'make' on its own to fail - make me think about which CPU I'm building for
unset CPU
unset TOPDIR

export TPC_IN_SAME_WINDOW=1

# -------------------- Helpful Aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"

alias m632="make CPU=FREEBSD6"
alias m664="make CPU=FREEBSD6_64"
alias m932="make CPU=SVOS9"
alias m964="make CPU=SVOS9_64"
alias ml5="make CPU=LINUX_64"
alias ml6="make CPU=LINUX_6_64"

# Make the title something useful before invoking screen
alias screen="title \"$(hostname | cut -d. -f1)(screen)\"; screen"

unalias make 2>/dev/null
alias make="$(which make) -rRs --no-print-directory C++OVERVIRT=-Wno-overloaded-virtual"

function covbr()
{
    /view/swbuild_main/vobs/fw-tools/Linux/bullseye/BullseyeCoverage-CURRENT-Linux-x64/bin/covbr \
            --file $(pwd)/test/${BSPEC}/test.cov \
            --srcdir $(pwd) \
            --no-time --no-banner --all $@
}

