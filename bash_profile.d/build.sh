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
alias m632="make CPU=FREEBSD6"
alias m664="make CPU=FREEBSD6_64"
alias m932="make CPU=SVOS9"
alias m964="make CPU=SVOS9_64"
alias ml5="make CPU=LINUX_64"
alias ml6="make CPU=LINUX_6_64"
alias ml7="make CPU=LINUX_7_64"

alias m932b="make CPU=SVOS9 BUILD_OPTS=BULLSEYE"
alias m964b="make CPU=SVOS9_64 BUILD_OPTS=BULLSEYE"
alias ml5b="make CPU=LINUX_64 BUILD_OPTS=BULLSEYE"
alias ml6b="make CPU=LINUX_6_64 BUILD_OPTS=BULLSEYE"
alias ml7b="make CPU=LINUX_7_64 BUILD_OPTS=BULLSEYE"

alias cloc="perl /view/swbuild_main/vobs/fw-tools/scripts/py/loc/bin/cloc-1.53.pl --force-lang=c++"

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

