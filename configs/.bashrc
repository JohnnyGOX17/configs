#!/usr/bin/env bash
#
# Settings for both *nix and macOS systems
# Vi-style centric for user input
# John Gentile <johncgentile17@gmail.com>
#

# =============================================================================
# Terminal & Path additions/edits/exports
# =============================================================================

# Source global definitions if exists
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source bash completion if exists (support multiple possible locations)
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi
# Some distros make use of a profile.d script to import completion
if [ -f /etc/profile.d/bash_completion.sh ]; then
  . /etc/profile.d/bash_completion.sh
fi
# On macOS, load brew bash completion modules
if [ $(uname) = "Darwin" ] && command -v brew &> /dev/null ; then
  BREW_PREFIX=$(brew --prefix)
  if [ -f "$BREW_PREFIX"/etc/bash_completion ]; then
    . "$BREW_PREFIX"/etc/bash_completion
  fi
 # homebrew/versions/bash-completion2 (required for projects.completion.bash) is installed to this path
  if [ "${BASH_VERSINFO}" -ge 4 ] && [ -f "$BREW_PREFIX"/share/bash-completion/bash_completion ]; then
    . "$BREW_PREFIX"/share/bash-completion/bash_completion
  fi
fi


# =============================================================================
# Terminal & Path additions/edits/exports
# =============================================================================

# customize PS1 bash prompt and change if on remote machine over SSH:
#   SSH: bold w/red user@host and yellow pwd $
#   Local: bold w/blue user@host and yellow pwd $
if [ -n "$SSH_CLIENT" ]; then
  export PS1="\[\e[1;31m\][SSH]\u@\h \[\e[1;33m\]\W $\[\e[0m\] "
else
  export PS1="\[\e[1;34m\]\u@\h \[\e[1;33m\]\W $\[\e[0m\] "
fi

# set Neovim as default editor (when available)
if command -v nvim > /dev/null; then
  alias vim='nvim'
  export VISUAL=nvim
else
  export VISUAL=vim
fi
export EDITOR="$VISUAL"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
export PYTHONIOENCODING='UTF-8'

# enable more advanced globbing in bash
shopt -s globstar

# autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null;
done;

# Append to bash history file rather than overwriting it
shopt -s histappend
# keep more bash history
export HISTSIZE=10000
export HISTFILESIZE=120000
# Omit duplicates and commands that begin with a space from bash history
export HISTCONTROL='ignoreboth'

# Prefer US English and use UTF-8
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Highlight section titles in manual pages
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page
export MANPAGER='less -X'

# Set PATH & library variables
if [[ -z $TMUX ]]; then # prevent duplication when launching new shells in tmux
  if [ "$(uname -s)" = "Linux" ]; then
    # TODO: add check for non-Ubuntu system?
    # add paths for - NVCC NVIDIA CUDA Compiler
    #               - Go
    #               - Rust
    #               - Ruby `rbenv`
    #               - Xilinx Vivado 2020.2 (Ubuntu data HDD install)
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/cuda/lib64:/usr/lib/cuda/include
    export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.rbenv/bin:$HOME/data/apps/Xilinx/Vivado/2020.2/bin
    # TODO: better way for DPDK include?
    #export RTE_SDK=$HOME/src/dpdk-19.02
    #export RTE_TARGET=x86_64-native-linuxapp-gcc
    # Prevent ioctl error when gpg2 signing
    export GPG_TTY=$(tty)
    # Enable GCC 8 & LLVM 7 in CentOS
    if [ -f /etc/centos-release ]; then
      source scl_source enable devtoolset-8 llvm-toolset-7
    fi
  elif [ "$(uname -s)" = "Darwin" ]; then
    # For macOS Catalina, Ruby not installed in System so use brew one and it's build paths
    export PATH="/usr/local/opt/ruby/bin:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/ruby/lib"
    export CPPFLAGS="-I/usr/local/opt/ruby/include"
  fi

  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/bin" ] ; then
      PATH="$HOME/bin:$PATH"
  fi
  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/.local/bin" ] ; then
      PATH="$HOME/.local/bin:$PATH"
  fi
fi


# =============================================================================
# User specific aliases and functions
# =============================================================================

# set terminal since other machines likely don't have our funky term settings
alias ssh='TERM=xterm-256color ssh'
# start SSH & add key for current session
alias ssh-init='eval "$(ssh-agent)" && ssh-add'

# easy updating for package management
if [ "$(uname -s)" = "Linux" ]; then
  if [ -n "$(command -v apt)" ]; then
    alias sys-update='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y && echo "" > /tmp/sys_package_updates'
  elif [ -n "$(command -v yum)" ]; then
    alias sys-update='sudo yum upgrade -y && echo "" > /tmp/sys_package_updates'
  elif [ -n "$(command -v dnf)" ]; then
    alias sys-update='sudo dnf upgrade -y && echo "" > /tmp/sys_package_updates'
  fi
elif [ "$(uname -s)" = "Darwin" ]; then
  alias sys-update='brew update && brew upgrade && brew cleanup && echo "" > /tmp/sys_package_updates'
fi

# Upgrade all pip packages: https://stackoverflow.com/questions/2720014/how-to-upgrade-all-python-packages-with-pip
alias pip-upgrade-all='pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'

# ls macros
alias ll='ls -lhXG'
if [ "$(uname -s)" = "Darwin" ]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias lsa='ls -A'
alias lsd="ls -alF | grep /$"

# color grep by default
alias grep='grep --color=auto'

# allow `cd..` typo for `cd ..`
alias cd..='cd ..'
# allow for typo of `cd -` previous cmd (and suppress output since we're toggling
# back and forth a previous directory not examing the stack like in push/popd)
alias cd-='cd - > /dev/null'
# cd to root directory of git repo (or submodule)
alias cdg='cd "$(git rev-parse --show-toplevel)"'
# pushd to root directory of git repo (or submodule)
alias pdg='pushd "$(git rev-parse --show-toplevel) > /dev/null"'
# cd to ~/src directory since common
alias cds='cd ~/src'
# pushd to ~/src directory since common
alias pds='pushd ~/src > /dev/null'

# Clean output of directory size usage
alias duh='du -h -d 1 | sort -rh'
# Recursively find largest 10 files within current directory
if [ "$(uname -s)" = "Darwin" ]; then
  alias duf="gfind ./ -type f -printf '%s\t%p\n' | sort -nr | head -10"
else
  alias duf="find ./ -type f -printf '%s\t%p\n' | sort -nr | head -10"
fi


# type less for faster push/pop dirs
alias p='pushd > /dev/null'
alias o='popd > /dev/null'
alias d='dirs -v'

# clear screen and ls with one command
alias cls='clear && ls'

# start calculator with math support
alias bc='bc -l'

# source ranger so it quits to navigated directory instead of directory it started in
alias ranger='source ranger'

# tmux should assume 256 color terminal support
alias tmux='tmux -2'

# create daily logbook
function lb() {
  mkdir -p ~/logbook
  StrDate=$(date '+%m-%d-%Y')
  StrPath=~/logbook/$StrDate.md
  touch "$StrPath"
  echo "# Logbook for $StrDate" > "$StrPath"
  echo "## Problem/Situation"  >> "$StrPath"
  echo "## Hypothesis"         >> "$StrPath"
  echo "## Experiment"         >> "$StrPath"
  echo "## Outcome"            >> "$StrPath"
  vim "$StrPath"
}

# <tab> completion for "Makefile"s in a dir showing all options as well
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make


# =============================================================================
# Cleanup & Launches
# =============================================================================

# Run tmux automatically if not in SSH session and not already launched
# Attach to `dev` session if existent, else launch session `dev`
if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ]; then
  tmux new-session -A -s dev
fi

# Initiate Ruby environment
if [ $(command -v rbenv) ]; then
  eval "$(rbenv init -)"
fi
