#!/bin/bash

# Are we on a test workfarm?
if [[ ! ${HOSTNAME} =~ "test" ]]; then return; fi

alias screen="title \"${HOSTNAME%%.*}(screen)\"; screen"

function lssoak() {
    local soaks="_tcl reserve res 2>/dev/null | grep -i soak"

    # "long" output
    if [ "$1" == "-l" ]; then
        local pattern="."
        if [ "$2" != "" ]; then
            pattern="^Reservation id\|^    desc:\|$2"
        fi
        for soak in $(eval $soaks | awk '{print $2}' | sort | uniq); do
            echo "-------------------------------------------------------------"
            _tcl reserve show $soak 2>/dev/null | grep -i "$pattern"
        done
    else
        eval $soaks | awk '{printf "%s ", $2; for(i=6; i<=NF;++i) printf "%s ", $i; printf "\n";}' | sort | uniq
    fi
}

