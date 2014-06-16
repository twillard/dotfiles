# .bash_profile

# REMEMBER: forking is really expensive in cygwin.  Don't fork as much as
# possible in here to speed-up cygwin startup

# -------------------- Import bashrc
source ~/.bashrc

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

# -------------------- Aliases
alias psg="ps aux | head -1; ps aux | grep"
alias pstree="ps auxf"

# -------------------- Prompt
# Colours
# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37
set_prompt()
{
local CLEAR="\[\033[0m\]"

local CYAN="\[\033[0;36m\]"
local LIGHTCYAN="\[\033[1;36m\]"

local GREEN="\[\033[0;32m\]"
local LIGHTGREEN="\[\033[1;32m\]"

local LIGHTBLUE="\[\033[1;34m\]"

local YELLOW="\[\033[0;33m\]"
local RED="\[\033[0;31m\]"

# REMEMBER: forking is really expensive in cygwin.  Simply DO NOT FORK in PS1.
# It's brutal.  For srs.
export PS1="\
$CYAN($LIGHTCYAN\@\
$CYAN|$GREEN\h$LIGHTCYAN:\u\
$CYAN|$LIGHTGREEN\$("'
  if [[ "$PWD" =~ ^"/view/"|^"/m/" ]]; then
      # Grab from pwd
      CURVIEW=${PWD#/view/}
      CURVIEW=${CURVIEW#/m/}
      echo ${CURVIEW%%/*}
  elif [[ -n "${CLEARCASE_ROOT}" ]]; then
      # CLEARCASE_ROOT is set by cleartool setview
      echo "{set}${CLEARCASE_ROOT#/view/}"
  fi
'")\
$CYAN|$LIGHTBLUE\W$CYAN)\
$YELLOW\\\$$CLEAR "
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

function ssh()
{
  if echo "$@" | grep -q swbuild; then
    echo "SSH access to swbuild revoked.  Use the /net/swbuild/d2 share on lview machines."
    return 1
  fi

  $(which ssh) "$@"
}

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
