#!/bin/bash
# File              : .bashrc
# Author            : John Gentile <johncgentile17@gmail.com>
# Date              : 12.12.2017
# Last Modified Date: 28.12.2017
# Last Modified By  : John Gentile <johncgentile17@gmail.com>

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# =============================================================================
# Path additions/edits
# =============================================================================

# customize PS1 bash prompt: bold w/blue user@host and yellow pwd $
export PS1="\[\e[1;34m\]\u@\h \[\e[1;33m\]\W $\[\e[0m\] "

# set vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# add paths for NVCC (NVIDIA CUDA Compiler)
export LD_LIBRARY_PATH=/usr/local/cuda/lib64
export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin

# =============================================================================
# User specific aliases and functions
# =============================================================================

# ls macros
alias ll='ls -lhXG'
alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
alias lsn='ls -a --color=no'
alias lsd="ls -alF | grep /$"

# allow cd.. for cd ..
alias cd..='cd ..'

# clear screen and ls with one command
alias cls='clear && ls'

# start calculator with math support
alias bc='bc -l'

# tmux should assume 256 color terminal support
alias tmux="tmux -2"

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

# Run tmux automatically
if [ -z "$TMUX" ]; then
  tmux new -s dev
fi
