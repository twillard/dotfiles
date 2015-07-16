#!/bin/bash

# Quick way to determine if we're on a TPC: does it have svcli?
if [ ! -x "/usr/local/sandvine/bin/svcli" -a ! -x "/usr/local/sandvine/bin/cli" ]; then
    return
fi

alias tcl='/m/test_main/fwtest/bin/tcl'
alias mtcl='/m/test_maintenance/fwtest/bin/tcl'
alias mytcl='/m/twillard_lab/fwtest/bin/tcl'

alias hh="TPC_IN_SAME_WINDOW=1 h"

# -- MIB PDB
alias mibExprDefn="pdbc -c 'lst /iso/org/dod/internet/mgmt/mib-2/dismanExpressionMIB/1/expDefine/expExpressionTable'"
alias mibExprValue="pdbc -c 'ls /iso/org/dod/internet/mgmt/mib-2/dismanExpressionMIB/1/expValue/expValueTable/expValueEntry/expValueCounter64Val/1'"
alias mibExprObj="pdbc -c 'lst /iso/org/dod/internet/mgmt/mib-2/dismanExpressionMIB/1/expDefine/expObjectTable'"
alias mibTriggers="pdbc -c 'lst /iso/org/dod/internet/mgmt/mib-2/dismanEventMIB/dismanEventMIBObjects/mteTrigger/mteTriggerTable'"

# -- SubscriberMap PDB
alias clearlatency="pdbc -c 'set devices/subscriberMap/1/latency/config/clearStats true'"
alias latency="pdbc -c 'ls devices/subscriberMap/1/latency/config/; lst devices/subscriberMap/1/latency/messaging/detailsTable/; lst devices/subscriberMap/1/latency/messaging/histogramTable/'"

export TERM=xterm

# -------------------- Helpful Functions
function gdb()
{
    if [ -z "$GDB_DIRS" ]; then
        $(which gdb) $*
    else
        $(which gdb) -d "${GDB_DIRS}" $*
    fi
}


