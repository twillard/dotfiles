#!/bin/bash

# Only source this file on a macos machine
if [ $(uname) != "Darwin" ]; then return; fi

if [ -x $(which exa 2>/dev/null) ]; then
    alias ls="exa"
fi

if [ -x $(which brew 2>/dev/null) ]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
fi

if [ -e /usr/local/opt/fzf/shell/completion.bash ]; then
    source /usr/local/opt/fzf/shell/key-bindings.bash
    source /usr/local/opt/fzf/shell/completion.bash
fi

# fzf + ag configuration
if which fzf >/dev/null 2>/dev/null && which ag >/dev/null 2>/dev/null; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi

if [ -f "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]; then
    . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
fi

##
## Android SDK
##
export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/r17
export ANDROID_NDK=/usr/local/Cellar/android-ndk/r7b

# Make the title something useful before invoking screen
alias screen="title \"$(hostname | cut -d. -f1)(screen)\"; screen"

# ssh-agent
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
