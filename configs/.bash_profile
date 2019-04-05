# Load .bashrc if there
test -f ~/.bashrc && source ~/.bashrc
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export PATH="$HOME/.cargo/bin:$PATH"
