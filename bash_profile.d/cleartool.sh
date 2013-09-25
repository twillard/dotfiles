#!/bin/bash

# Only source this file if clearcase is installed and in the path
if [[ ! $PATH =~ "clearcase" ]]; then return; fi

export SVDIFF="diff -u --ignore-all-space"
export DIFF_TOOL="diff -u --ignore-all-space"

alias cdiff="cleartool diff -pre -gra"
alias chist="cleartool lshist -gra"
alias ctxlsv="cleartool lsvtree -gra"
alias ctcou="cleartool co -nc -unr"
alias cact="cleartool lsact -cact | cut -d' ' -f3"
alias findmerge='cleartool findmerge . -flatest -merge -gmerge'

alias ginc="cd \$(pwd | sed 's@/support/@/include/@')"
alias gsup="cd \$(pwd | sed 's@/include/@/support/@')"

# Output to stdout the filesystem location of a view.  
# Takes into account Linux vs. Cygwin
viewdir ()
{
    if [ $(uname) = Linux ]; then
        echo /view/$1/vobs
    else
        echo /m/$1
    fi
}

# Re-parent the given file - use after findmerge
reparent ()
{
    if [ "z$1" == "z" -o ! -f "$1" ]; then
        echo "Usage: reparent <filename>";
        return 1
    fi;

    cp "$1" "$1.reparent"
    cleartool unco -rm "$1" || return 2;
    cleartool co -unr -nc "$1" || return 3;
    cp "$1.reparent" $1
}

# Pretty-printing listing of all checkouts and their associated activities.
# Groups checkouts by activity making it very easy to scan
# Only calls into cleartool once, resulting in quick operation
# Args: $1 - username of person with checkouts to find (optional)
# Dependencies: 
unalias lsco 2>/dev/null >/dev/null
function lsco()
{
    local _cur_view=$(cleartool pwv -short | tr -d "\r\n")
    local _user=$1; shift

    if [ "z$_user" = "z" ]; then
        _user=$USER
    fi

    cleartool lsstream -cview >/dev/null 2>&1

    if [ $? -ne 0 ]; then 
        # Non-UCM stream; don't use activities, just list checkouts
        cleartool lsco -user $_user -avobs -cview | tr '\\' '/' \
            | grep "$_cur_view" \
            | cut -d \" -f 2 \
            | sed -e 's#.*M:#/m#' \
            | sort
    else
        # Awk implementation of pretty-printing
        cleartool lsco -user $_user -avobs -cview | awk -vCUR_VIEW=$_cur_view '
            BEGIN {
                # Initialize our "globals"
                lastFileName = ""
            }
            /checkout .*version .* from/ {
                # Get rid of all those annoying back-slashes
                gsub("\\\\", "/", $0)

                # Change M: to /m
                gsub("M\\:", "/m", $0)

                # Pull the relative filename out of the line
                match($0, ".*\"(..*)\"", fileName)

                # Store filename until we see its activity
                lastFileName = fileName[1]

                # Is the checkout reserved or not?
                #match($0, "(\\(.*reserved\\))", reserved)

                # Add this to filename
                #lastFileName = lastFileName reserved[1]
                lastFileName = lastFileName

                # Done with this record
                next
            }
            /Attached activity:/ {
                next
            }
            /^[ 	]*activity:/ {
                # Pull out the name and ID of the attached activity
                match($0, "activity:([^ @]*)@[^ ]* *\"(.*)\"", activityMatch)

                # The plaintext name of the activity is the second match
                activityName = activityMatch[2]

                # The activity selector (id) is the first thing matched
                selectors[activityName] = activityMatch[1]

                # Add the current file to the list of files checked-out to this activity
                if ( checkouts[activityName] != "" ) {
                    checkouts[activityName] = checkouts[activityName] SUBSEP
                }
                checkouts[activityName] = checkouts[activityName] lastFileName

                # Blank out the filename, just so we do not accidentally reuse it
                lastFileName = ""

                # Done with this record
                next
            }
            END {
                # Output all the checkouts under a heading indicating the attached activity
                for (activity in checkouts) {
                    # Print the header
                    printf "--- Activity: %s (%s)\n\n", activity, selectors[activity]

                    # Print the files in sorted order
                    split(checkouts[activity], files, SUBSEP)
                    numFiles = asort(files)
                    for (idx = 1; idx <= numFiles; idx++) {
                        printf ("%s\n", files[idx])
                    }

                    print ""
                }
            }'
    fi
}

# Output diffs for all checked-out files in the current view
# Args: $1 - username of person with checkouts to find (optional)
# Dependencies: lsco function, pdiff
function diffall()
{
    _olddir=$(pwd)

    local _user=$1; shift

    if [ "z$_user" = "z" ]; then
        _user=$USER
    fi

    which pdiff >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Could not determine location of pdiff binary"
        return 1
    fi

    cview="$(cleartool pvw -short | tr -d '\r\n')"
    if [ $? -ne 0 ]; then
        echo "Could not determine current view"
        return 1
    fi

    for _file in $(lsco $_user | grep "$cview"); do
        if [ ! -d $_file ]; then
            cd $(dirname $_file)
            pdiff $(basename $_file)
        else
            echo "====DIR <$_file> has changed. Manually diff.===="
        fi
    done

    cd $_olddir
}

# Find all checkouts on all active views for the current user
# Args: none
# Dependencies: lsco
findco()
{
    for view in $(cleartool lsview | grep $USER | sed "s@^..@@" | cut -d' ' -f1); do
        echo "Looking for checkouts in $view"

        viewdir="$(viewdir $view)"
        unset end_view
        if [ ! -d "$viewdir" ]; then
            cleartool startview $view

            if [ ! -d "$viewdir" ]; then
                echo "Could not find view directory for $view"
                continue
            fi

            end_view=1
        fi

        cd $viewdir/fw
        lsco
        cd - >/dev/null
        
        if [ -n "$end_view" ]; then
            cleartool endview $view
        fi
    done
}


