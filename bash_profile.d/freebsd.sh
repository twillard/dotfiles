#!/bin/bash

# Quick exit if cygwin - forking is expensive, use PATH to quickly determine if
# we're cygwin and bail before we start checking uname
if [[ $PATH =~ "cygwin" ]]; then return; fi

# Only source this file on a FreeBSD device
if [ $(uname) != "FreeBSD" -a $(uname) != "SVOS" ]; then return; fi

# BSD versions of ls and grep aliases
alias ls="ls -GF"
alias grep="grep -G"

alias pkg_add="sudo pkg_add"
alias pkg_delete="sudo pkg_delete"

function oste_replay()
{
    capture=$1

    if [ ! -f $capture ]; then
        echo "Could not find capture file $capture"
        return 1
    fi 

    data1name=$2
    data2name=$3 
    shift; shift; shift

    if [ -z "$data1name" -o -z "$data2name" ]; then
        echo "Usage: oste_replay <capture> <data1iface> <data2iface>"
        return 2
    fi

    data1mac=$(ifconfig $data1name | grep ether | awk '{print $2}')
    data2mac=$(ifconfig $data2name | grep ether | awk '{print $2}')

    if [ -z "$data1mac" -o -z "$data2mac" ]; then
        echo "Error: Could not determine mac addresses. $data1name-$data1mac : $data2name-$data2mac"
        echo "Usage: oste_replay <capture> <data1iface> <data2iface>"
        return 3
    fi

    echo "Replaying <$capture> through DATA_1 ($data1name-$data1mac), DATA_2 ($data2name-$data2mac)"
    sudo tcpreplay $@ -i $data1name -I $data2mac -j $data2name -J $data1mac -K $data2mac -k $data1mac -c $capture.cache $capture
}
