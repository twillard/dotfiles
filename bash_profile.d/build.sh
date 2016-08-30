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
alias m932="make -j32 CPU=SVOS9"
alias m964="make -j32 CPU=SVOS9_64"
alias ml6="make -j32 CPU=LINUX_6_64"
alias ml7="make -j32 CPU=LINUX_7_64"

alias cloc="perl /view/swbuild_main/vobs/fw-tools/scripts/py/loc/bin/cloc-1.53.pl --force-lang=c++"

# gnu_make_complete defined in svdev
complete -F gnu_make_complete make
complete -F gnu_make_complete m932
complete -F gnu_make_complete m964
complete -F gnu_make_complete ml6
complete -F gnu_make_complete ml7

# Use the nonrecursive make infrastructure, when it becomes available
# export USE_NONRECURSIVE_MAKE=1

function covbr()
{
    /view/swbuild_main/vobs/fw-tools/Linux/bullseye/BullseyeCoverage-CURRENT-Linux-x64/bin/covbr \
            --file $(pwd)/test/${BSPEC}/test.cov \
            --srcdir $(pwd) \
            --no-time --no-banner --all $@
}

function extract_rpm()
{
    rpm2cpio $1 | cpio -idmv
}

