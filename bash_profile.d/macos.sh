#!/bin/bash

# Only source this file on a macos machine
if [ $(uname) != "Darwin" ]; then return; fi

if [[ ! ":$PATH:" =~ ":/opt/local/bin:" ]]; then
    export PATH="$PATH:/opt/local/bin"
fi

if [[ ! ":$PATH:" =~ ":/opt/local/sbin:" ]]; then
    export PATH="$PATH:/opt/local/sbin"
fi

if [[ ! ":$PATH:" =~ ":/usr/local/bin:" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

if [[ ! ":$PATH:" =~ ":/usr/local/sbin:" ]]; then
  export PATH="/usr/local/sbin:$PATH"
fi

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

if [ -d "$HOME/Qt/5.6" ]; then
	export Qt5_DIR="$HOME/Qt/5.6/clang_64"
fi

