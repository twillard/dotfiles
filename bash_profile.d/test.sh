#!/bin/bash

# Are we on a test workfarm?
if [[ ! ${HOSTNAME} =~ "test" ]]; then return; fi

alias screen="title \"${HOSTNAME%%.*}(screen)\"; screen"
alias lssoak="tcl reserve res | grep soak | sed 's@  *@ @g' | cut -d' ' -f2,6- | sort | uniq"

