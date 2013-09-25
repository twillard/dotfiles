#!/bin/bash

# Quick exit if cygwin - forking is expensive, use PATH to quickly determine if
# we're cygwin and bail before we start checking uname
if [[ $PATH =~ "cygwin" ]]; then return; fi

# Only source this file on an SPB device
pkg_info 2>/dev/null | grep -q spb-services
if [ $? -ne 0 ]; then return; fi

# Slightly modify the title that's set by the PROMPT_COMMAND
export PROMPT_TITLE="$PROMPT_TITLE(SPB)"

