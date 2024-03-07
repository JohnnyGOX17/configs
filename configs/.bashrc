#!/usr/bin/env bash
#
# Settings for both *nix and macOS systems
# Vi-style centric for user input
# John Gentile <johncgentile17@gmail.com>
#

# =============================================================================
# Terminal & Path additions/edits/exports
# =============================================================================

# Stop path_helper from pre-pending dirs to PATH on macOS:
# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
if [ "$(uname -s)" = "Darwin" ]; then
  if [ -f /etc/profile ]; then
      PATH=""
      source /etc/profile
  fi
  # In Apple Silicon Brew installs, need to source brew env which is at /opt/homebrew
  # instead of /usr/local/
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export SDKROOT=$(xcrun --show-sdk-path)

  # We must also fix an issue where Jupyter path needs to see homebrew installed 
  # Python and associated plugins
  #  from https://github.com/jupyterlab/jupyterlab/issues/14965#issuecomment-1826294747
  export JUPYTER_PATH=/opt/homebrew/share/jupyter
fi

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
  alias vimdiff='nvim -d'
  export VISUAL=nvim
else
  export VISUAL=vim
fi
export EDITOR="$VISUAL"

# custom binary diff command using xxd and vimdiff for visualization
if command -v xxd > /dev/null; then
  bindiff() {
    vimdiff <(xxd "$1") <(xxd "$2")
  }
fi

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

# Added env safety for log4shell vuln
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

# Set PATH & library variables
#if [[ -z $TMUX ]]; then # prevent duplication when launching new shells in tmux
  if [ "$(uname -s)" = "Linux" ]; then
    # TODO: add check for non-Ubuntu system?
    # add paths for - NVCC NVIDIA CUDA Compiler
    #               - Go
    #               - Rust
    #               - Ruby `rbenv`
    #               - Xilinx Vivado & Vitis 2021.1
    #               - ModelSim Starter Edition (Ubuntu data HDD install)
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/cuda/lib64:/usr/lib/cuda/include
    export PATH=$PATH:/usr/local/cuda/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.rbenv/bin:$HOME/bin_nvme/Xilinx/Vitis/2021.1/bin:$HOME/bin_nvme/Xilinx/Vivado/2021.1/bin:$HOME/data/apps/intelFPGA_lite/20.1/modelsim_ase/bin
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
    # Prioritize GNU Utils over system ones: https://stackoverflow.com/questions/57972341/how-to-install-and-use-gnu-ls-on-macos
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$BREW_PREFIX/opt/llvm/bin/:/opt/homebrew/opt/ruby@3.0/bin:$HOME/.gem/ruby/3.0.0/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"
    export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"
  fi

  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/bin" ]; then
    PATH="$PATH:$HOME/bin"
  fi
  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/.local/bin" ]; then
    PATH="$PATH:$HOME/.local/bin"
  fi
#fi


# =============================================================================
# User specific aliases and functions
# =============================================================================

# set terminal since other machines likely don't have our funky term settings
alias ssh='TERM=xterm-256color ssh'
# start SSH & add key for current session
alias ssh-init='eval "$(ssh-agent)" && ssh-add'

# run sudo with current PATH environment variable:
#  $ mysudo <command> [arguments]
alias mysudo='sudo -E env "PATH=$PATH"'

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
alias pip-upgrade-all="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U && echo '' > /tmp/pip_update_cnt"
alias list_python_packages="python3 -c \"help('modules')\""

# ls macros
alias ll='ls -lhXG'
alias ls='ls --color=auto'
alias lsa='ls -A --color=auto'
alias lsd="ls -alF | grep /$"

# color grep by default
alias grep='grep --color=auto'

# use ripgrep to search for filenames: https://github.com/BurntSushi/ripgrep/issues/193#issuecomment-513201558
alias rgf='rg --files | rg'

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
  $EDITOR "$StrPath"
}

function git-status-recursive-curr-dir() {
  # Colors for printing
  BLU='\033[1;34m'
  NC='\033[0m'

  # Iterate through directories in src/ and check git status
  for d in */ ; do
    pushd "$d" > /dev/null || exit
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]; then
      # Check for uncommitted changes
      gitStatStr="$(git status -s)"
      # Check if changes committed but not pushed
      gitPushStr="$(git status --ahead-behind | grep 'ahead')"

      if [ -n "$gitStatStr" ]; then
        echo -e "\n${BLU}[$d]${NC}"
        echo -e "$gitStatStr"
      elif [ -n "$gitPushStr" ]; then
        echo -e "\n${BLU}[$d]${NC}"
        echo -e "$gitPushStr"
      fi;
    fi;
    popd > /dev/null || exit
  done
}

# <tab> completion for "Makefile"s in a dir showing all options as well
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make


# =============================================================================
# Cleanup & Launches
# =============================================================================

# Run tmux automatically if not in SSH session and not already launched
# Attach to `dev` session if existent, else launch session `dev`
if [ -z "$TMUX" ]; then
  if [ -z "$SSH_CLIENT" ]; then
    tmux new-session -A -s dev
  else
    # Not in a TMUX session, but we're SSH'ed so cd to last directory we were in
    # NOTE: set in ~/.bash_logout
    if [ -f "$HOME/.last_dir" ]; then
      cd "$(<~/.last_dir)" || exit
    fi
  fi
fi
