# .bash_profile

# REMEMBER: forking is really expensive in cygwin.  Don't fork as much as
# possible in here to speed-up cygwin startup

# -------------------- Import bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Default title to be set by PROMPT_COMMAND - bash_profile.d scripts may override or
# enhance this
export PROMPT_TITLE="${HOSTNAME}"

# -------------------- Machine-specific aliases and functions
for file in $(find ~/dotfiles/bash_profile.d/ -type f); do
    source $file
done

# -------------------- Exports

# Add $HOME/bin to path if it's not in there
if [[ ! ":$PATH:" =~ ":$HOME/bin:" ]]; then
  export PATH="$PATH:$HOME/bin"
fi

# Add /root/bin to path if it's not in there
if [[ ! ":$PATH:" =~ ":/root/bin:" ]]; then
  export PATH="$PATH:/root/bin"
fi

# Add /sbin to path if it's not in there
if [[ ! ":$PATH:" =~ ":/sbin:" ]]; then
  export PATH="$PATH:/sbin"
fi

export LC_COLLATE=C
export EDITOR="vim"

# -------------------- Prompt Command

export DEFAULT_PROMPT_TITLE="$PROMPT_TITLE"

# REMEMBER: forking is STUPID expensive in cygwin.  Simply DO NOT FORK in
# PROMPT_COMMAND. It's brutal.  For srs.
# note - title is a bash function which calls 'echo'.  It's cheap.
export PROMPT_COMMAND="title \"\$PROMPT_TITLE\""

resettitle()
{
  export PROMPT_TITLE="$DEFAULT_PROMPT_TITLE"
}

chtitle()
{
  export PROMPT_TITLE="$@"
}

function psg()
{
    ps aux | awk "NR<2 {print} /$@/ {print}"
}

# -------------------- Aliases
alias pstree="ps auxf"

#----------------------------------------------------------------
# Stuff we only care about in interactive terminals
#----------------------------------------------------------------
if tty -s; then

# Colours
# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37
COLOR_RESET="\033[0m"
COLOR_CYAN="\033[0;36m"
COLOR_LIGHTCYAN="\033[1;36m"
COLOR_BROWN="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_LIGHTGREEN="\033[1;32m"
COLOR_LIGHTBLUE="\033[1;34m"
COLOR_YELLOW="\033[0;33m"
COLOR_RED="\033[0;31m"

cleartool_prompt()
{
  echo -e "\[$COLOR_LIGHTGREEN$\]"'\$(
    if [[ "$PWD" =~ ^"/view/"|^"/m/" ]]; then
        # Grab from pwd
        CURVIEW=${PWD#/view/}
        CURVIEW=${CURVIEW#/m/}
        echo ${CURVIEW%%/*}
    elif [[ -n "${CLEARCASE_ROOT}" ]]; then
        # CLEARCASE_ROOT is set by cleartool setview
        echo "{set}${CLEARCASE_ROOT#/view/}"
    else
        echo "Unknown view"
    fi)'
}

git_color()
{
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working tree clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_BROWN
  fi
}

git_branch()
{
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "$branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "$commit"
  fi
}

git_prompt()
{
  echo -e "\[\$(git_color)\]\$(git_branch)"
}

vcs_prompt()
{
  if [ -x "$(which git 2>/dev/null)" ]; then
    git_prompt
  elif [ -x "$(which cleartool 2>/dev/null)" ]; then
    cleartool_prompt
  fi
}

# -------------------- Prompt
set_prompt()
{
  PS1="\[$COLOR_CYAN\](\[$COLOR_LIGHTCYAN\]\@"
  PS1+="\[$COLOR_CYAN\]|\[$COLOR_GREEN\]\h\[$COLOR_LIGHTCYAN\]:\u"
  PS1+="\[$COLOR_CYAN\]|$(vcs_prompt)"
  PS1+="\[$COLOR_CYAN\]|\[$COLOR_LIGHTBLUE\]\W\[$COLOR_CYAN\])"
  PS1+="\[$COLOR_YELLOW\]\\\$\[$COLOR_RESET\] "

  export PS1
}
set_prompt

# -------------------- Shell Options

# Disable flow control shortcuts
stty -ixoff -ixon

# other useful stuff
shopt -s cdspell
shopt -s extglob
shopt -s cmdhist
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
# Append shell cmd history after every command
shopt -s histappend
# Don't allow overwriting of files with > redirection
set -o noclobber
# Use vi terminal emulation
set -o vi

fi

#----------------------------------------------------------------
# End interactive terminal block
#----------------------------------------------------------------


# -------------------- History Setup

# Save the last 30,000 commands
HISTFILESIZE=30000
HISTSIZE=30000

# Don't store ls, bg, fg, exit in history
HISTIGNORE="&:ls:[bf]g:exit"

# Strip duplicate commands from history
HISTCONTROL=ignoredups:erasedups

# Use separate history files for tpc, lview, and test machines
case $(hostname) in
    wtl-lview-* ) export HISTFILE="$HOME/.bash_history_lview" ;;
    wtllab-test-* ) export HISTFILE="$HOME/.bash_history_test" ;;
    TPC* ) export HISTFILE="$HOME/.bash_history_tpc" ;;
esac

# -------------------- Helpful Functions

function per_process_mem()
{
  ps aux | awk '
  NR==1 {
      printf "%30.30s  %15.15s\n", $11, $5
      next
  }

  {
      sizes[$11] = sizes[$11] + $5
  }

  END {
      for(idx in sizes) {
          printf "%30.30s: %15d\n", idx, sizes[idx]
      }
  }'
}

function dot2ps()
{
    dot -Tps "$1" -o $(basename "$1" .dot).ps
}

function title()
{
    # This checks for a screen session.
    # When inside screen, $STY always set, and never outside
    if [[ -n "$STY" || "$TERM" == *screen* ]]; then
        # Uses the screen escape sequence to set title
        # ESC k title ESC \
        echo -ne "\033k$1\033\\"
    else
        # Uses regular terminal escape sequence to set title
        echo -ne "\033]0;$1\007"
    fi
}

function calc()
{
    echo "$*" | bc
}

# vim: set ts=2 sw=2 et:

##
# Your previous /Users/travis.willard/.bash_profile file was backed up as /Users/travis.willard/.bash_profile.macports-saved_2017-07-04_at_13:10:22
##

# MacPorts Installer addition on 2017-07-04_at_13:10:22: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

