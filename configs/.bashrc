#!/bin/bash
# File              : .bashrc
# Author            : John Gentile <johncgentile17@gmail.com>
# Date              : 12.12.2017
# Last Modified Date: 04.03.2018
# Last Modified By  : John Gentile <johncgentile17@gmail.com>

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# =============================================================================
# Terminal & Path additions/edits
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

# add paths for NVCC (NVIDIA CUDA Compiler)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin

# =============================================================================
# User specific aliases and functions
# =============================================================================

# set terminal since other machines likely don't have our funky term settings
alias ssh='TERM=xterm-256color ssh'

# explicitly alias vi->vim
alias vi='vim'

# useful for simple projects looking to add->commit->push in one step
alias gitacp='git add -A && git commit -s && git push'

# easy updating for debian/apt-based package management
alias update='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'

# ls macros
alias ll='ls -lhXG'
alias ls='ls --color=auto'
alias lsa='ls -A --color=auto'
alias lsn='ls -a --color=no'
alias lsd="ls -alF | grep /$"

# allow cd.. for cd ..
alias cd..='cd ..'

# type less for faster push/pop dirs
alias p='pushd'
alias o='popd'
alias d='dirs -v'

# clear screen and ls with one command
alias cls='clear && ls'

# start calculator with math support
alias bc='bc -l'

# tmux should assume 256 color terminal support
alias tmux="tmux -2"

# enable more advanced globbing in bash
shopt -s globstar

# keep more bash history
export HISTSIZE=10000
export HISTFILESIZE=120000

# create daily logbook
function lb() {
  mkdir -p ~/logbook
  StrDate=$(date '+%m-%d-%Y')
  StrPath=~/logbook/$StrDate.md
  touch $StrPath
  echo "# Logbook for $StrDate" > $StrPath
  echo "## Problem/Situation" >> $StrPath
  echo "## Hypothesis" >> $StrPath
  echo "## Experiment" >> $StrPath
  echo "## Outcome" >> $StrPath
  vim $StrPath
}

# =============================================================================
# Cleanup & Launches
# =============================================================================

# Run tmux automatically if not in SSH session
if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ]; then
  tmux new -s dev
fi

# Find if ssh-agent process is already running. If not, start it and auto add
# private key from default location. If running do nothing. If more than one
# process running, kill last one
case "$(pidof ssh-agent | wc -w)" in
  0) eval 'ssh-agent'
    ;;
  1) 
    ;;
  *) kill $(pidof ssh-agent | awk '{print $1}')
    ;;
esac
ssh-add
