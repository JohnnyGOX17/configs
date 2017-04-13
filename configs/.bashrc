# .bashrc
#
# Author:       John Gentile
# Date:         1/11/2017

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# =============================================================================
# Path additions/edits
# =============================================================================

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
alias ll='ls -alh'
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

# customize PS1 bash prompt: bold w/blue user@host and yellow pwd $
export PS1="\[\e[1;34m\]\u@\h \[\e[1;33m\]\W $\[\e[0m\] "
