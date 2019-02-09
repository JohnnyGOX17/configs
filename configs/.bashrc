#!/bin/bash

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

if [ "$(uname -s)" = "Linux" ]; then
  # add paths for - NVCC NVIDIA CUDA Compiler
  #               - Vivado 2018.2
  #               - Altera-ModelSim 18.1/10.6d
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
  export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin:/opt/Xilinx/Vivado/2018.2/bin:/home/jgentile/intelFPGA_pro/18.1/modelsim_ase/linux:/usr/local/MATLAB/R2018b/bin
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

# easy updating for package management
if [ "$(uname -s)" = "Linux" ]; then
  if [ -n "$(command -v apt)" ]; then
    alias sys_update='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
  elif [ -n "$(command -v yum)" ]; then
    alias sys_update='sudo yum update && sudo yum upgrade -y'
  fi
elif [ "$(uname -s)" = "Darwin" ]; then
  alias sys_update='brew update && brew upgrade && brew cleanup'
fi


# ls macros
alias ll='ls -lhXG'
alias ls='ls --color=auto'
alias lsa='ls -A --color=auto'
alias lsn='ls -a --color=no'
alias lsd="ls -alF | grep /$"

# allow `cd..` typo for `cd ..`
alias cd..='cd ..'
# allow for typo of `cd -` previous cmd (and suppress output since we're toggling
# back and forth a previous directory not examing the stack like in push/popd)
alias cd-='cd - > /dev/null'
# cd to root directory of git repo (or submodule)
alias cdg='cd "$(git rev-parse --show-toplevel)"'

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
  touch "$StrPath"
  echo "# Logbook for $StrDate" > "$StrPath"
  echo "## Problem/Situation"  >> "$StrPath"
  echo "## Hypothesis"         >> "$StrPath"
  echo "## Experiment"         >> "$StrPath"
  echo "## Outcome"            >> "$StrPath"
  vim "$StrPath"
}

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
  0) eval 'ssh-agent'
    ssh-add
    ;;
  1)
    ;;
  *) kill "$(pidof ssh-agent | awk '{print $1}')"
    ;;
esac
