#!/usr/bin/env bash

# Source global definitions if existent
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

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

# set vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
export PYTHONIOENCODING='UTF-8'

# enable more advanced globbing in bash
shopt -s globstar

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

if [ "$(uname -s)" = "Linux" ]; then
  # add paths for - NVCC NVIDIA CUDA Compiler
  #               - MATLAB R2018b
  #               - Vivado & SDK 2018.2
  #               - Linaro build tools
  #               - Ruby `rbenv`
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
  export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin:/usr/local/MATLAB/R2018b/bin:/home/jgentile/bin/Xilinx/Vivado/2018.2/bin/:/home/jgentile/bin/Xilinx/SDK/2018.2/bin/:/home/jgentile/src/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/bin:/home/jgentile/.rbenv/bin
  export RTE_SDK=/home/jgentile/src/dpdk-19.02
  export RTE_TARGET=x86_64-native-linuxapp-gcc
  # Prevent ioctl error when gpg2 signing
  export GPG_TTY=$(tty)
elif [ "$(uname -s)" = "Darwin" ]; then
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH:/usr/local/go/bin:~/.cargo/bin"
fi

# =============================================================================
# User specific aliases and functions
# =============================================================================

# set terminal since other machines likely don't have our funky term settings
alias ssh='TERM=xterm-256color ssh'

# explicitly alias vi->vim
alias vi='vim'

# useful for simple projects looking to add->commit->push in one step
alias gitacp='git add -A && git commit -s && git push'
alias gitlarge="git rev-list --objects --all \
| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
| sed -n 's/^blob //p' \
| sort --numeric-sort --key=2 \
| cut -c 1-12,41- \
| $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest"

# easy updating for package management
if [ "$(uname -s)" = "Linux" ]; then
  if [ -n "$(command -v apt)" ]; then
    alias sys_update='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y && echo "" > /tmp/sys_package_updates'
  elif [ -n "$(command -v yum)" ]; then
    alias sys_update='sudo yum update && sudo yum upgrade -y && echo "" > /tmp/sys_package_updates'
  fi
elif [ "$(uname -s)" = "Darwin" ]; then
  alias sys_update='brew update && brew upgrade && brew cleanup && echo "" > /tmp/sys_package_updates'
fi

# ls macros
alias ll='ls -lhXG'
alias ls='ls --color=auto'
alias lsa='ls -A --color=auto'
alias lsn='ls -a --color=no'
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
alias duh='du -h -d 1 | sort -bh'

# type less for faster push/pop dirs
alias p='pushd'
alias o='popd'
alias d='dirs -v'

# clear screen and ls with one command
alias cls='clear && ls'

# start calculator with math support
alias bc='bc -l'

# tmux should assume 256 color terminal support
alias tmux='tmux -2'

# PetaLinux environment configs (don't source on entry since can take awhile)
alias peta_init='. ~/src/petalinux/2018.2/settings.sh > /dev/null'

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

# Find if ssh-agent process is already running. If not, start it and auto add
# private key from default location. If running do nothing. If more than one
# process running, kill last one
case "$(pidof ssh-agent | wc -w)" in
  0) eval "$(ssh-agent)"
    ssh-add
    ;;
  1)
    ;;
  *) kill "$(pidof ssh-agent | awk '{print $1}')"
    ;;
esac

# Initiate Ruby environment
if [ $(command -v rbenv) ]; then
  eval "$(rbenv init -)"
fi
