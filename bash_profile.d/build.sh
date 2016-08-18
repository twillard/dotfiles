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

gnu_make_complete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}

    local targets="test test_checkbuild"

    local unit_tests="$(ls t_*.test | sed 's/t_\([^\.]*\)\.test/t_\1\.test \1/g')"

    local general_options="ALLDEPS=1 CMDCFLAGS="
    local cpu_options="CPU=SVOS9_64 CPU=SVOS10_64 CPU=LINUX_6_64 CPU=LINUX_7_64"
    local compiler_options="USE_CLANG=1 GCC_VERSION= CLANG_VERSION="
    local debug_options="NDEBUG=NDEBUG NDEBUG=DEBUG"
    local gcov_options="TEST_GCOV=html TEST_GCOV=1 GCOVROPTS="
    local test_options="TEST_GDB=1 TEST_VALGRIND=0 TEST_FILTER= TEST_HELGRIND=1 TEST_BUILDONLY=1 TEST_SPECIFIC= TEST_EXEC_ARGS= TEST_RERUN_FAILURES=1 TEST_FORCE_RUN=1"

    local options="$general_options $cpu_options $compiler_options $debug_options $gcov_options $test_options"

    COMPREPLY=( $(compgen -W "$targets $unit_tests $options" -- $cur) )
}
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

