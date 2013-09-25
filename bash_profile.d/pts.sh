#!/bin/bash

# Quick exit if cygwin - forking is expensive, use PATH to quickly determine if
# we're cygwin and bail before we start checking uname
if [[ $PATH =~ "cygwin" ]]; then return; fi

# Only source this file on a PTS device
pkg_info 2>/dev/null | grep -q svptsd
if [ $? -ne 0 ]; then return; fi

# Slightly modify the title that's set by the PROMPT_COMMAND
export PROMPT_TITLE="$PROMPT_TITLE(PTS)"

# -------------------- Helpful Exports
# MALLOC_OPTIONS - useful for debugging memory leaks.  man malloc for details
# export MALLOC_OPTIONS=AJ

# -------------------- Helpful Functions (PTS)
function grabLatencyMeasurements()
{
    show policy measurement | grep "^ipAssignmentsAge[ 1234567890]\{5\}[ P][ l][ u][ s] \+[0123456789]" | awk '
        /31000Plus/ {
            gsub("[Pp]lus","")
        }

        {
            gsub("ipAssignmentsAge","")
            gsub(",","")
            printf("IpAssigmentsAge%5.5d %30d\n", $1, $2)
        }
        ' | sort
}
