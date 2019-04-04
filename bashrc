# .bashrc

# -------------------- Machine-specific aliases and functions
for file in $(find ~/dotfiles/bashrc.d/ -type f); do
    source $file
done

if [ -d ~/.bashrc.d ]; then
  for file in $(find ~/.bashrc.d/ -type f); do
      source $file
  done
fi

# -------------------- Aliases
alias pstree="ps auxf"

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

# -------------------- Prompt Command

export PROMPT_TITLE="${HOSTNAME}"
export DEFAULT_PROMPT_TITLE="$PROMPT_TITLE"

export PROMPT_COMMAND='title "$PROMPT_TITLE"'

if [ "$(type -t __git_ps1)" = 'function' ]; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWSTASHSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWCOLORHINTS=true
    export GIT_PS1_SHOWUPSTREAM="auto"

    GITPS1_BEGINNING="\[$COLOR_CYAN\](\[$COLOR_LIGHTCYAN\]\@"
    GITPS1_BEGINNING+="\[$COLOR_CYAN\]|\[$COLOR_GREEN\]\h\[$COLOR_LIGHTCYAN\]:\u"
    GITPS1_BEGINNING+="\[$COLOR_RESET\]"
    GITPS1_END=" \[$COLOR_LIGHTBLUE\]\W\[$COLOR_CYAN\])"
    GITPS1_END+="\[$COLOR_YELLOW\]\\\$\[$COLOR_RESET\] "
    export PROMPT_COMMAND="$PROMPT_COMMAND; __git_ps1 \"$GITPS1_BEGINNING\" \"$GITPS1_END\""
fi

# -------------------- Prompt
# Note if __git_ps1 is installed this is overridden in PROMPT_COMMAND
set_prompt()
{
  PS1="\[$COLOR_CYAN\](\[$COLOR_LIGHTCYAN\]\@"
  PS1+="\[$COLOR_CYAN\]|\[$COLOR_GREEN\]\h\[$COLOR_LIGHTCYAN\]:\u"
  PS1+="\[$COLOR_CYAN\]|\[$COLOR_LIGHTBLUE\]\W\[$COLOR_CYAN\])"
  PS1+="\[$COLOR_YELLOW\]\\\$\[$COLOR_RESET\] "

  export PS1
}
set_prompt

resettitle()
{
  export PROMPT_TITLE="$DEFAULT_PROMPT_TITLE"
}

chtitle()
{
  export PROMPT_TITLE="$@"
}

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

if [ -f ~/.local/bin/bashmarks.sh ]; then
  source ~/.local/bin/bashmarks.sh
fi

# -------------------- History Setup

# Save the last 30,000 commands
HISTFILESIZE=30000
HISTSIZE=30000

# Don't store ls, bg, fg, exit in history
HISTIGNORE="&:ls:[bf]g:exit"

# Strip duplicate commands from history
HISTCONTROL=ignoredups:erasedups

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

function psg()
{
    ps aux | awk "NR<2 {print} /$@/ {print}"
}

# vim: set ts=2 sw=2 et:
