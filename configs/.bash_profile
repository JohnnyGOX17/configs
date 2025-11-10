# Load .bashrc if there
test -f ~/.bashrc && source ~/.bashrc
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"
test -f "$HOME/.local/bin/env" && . "$HOME/.local/bin/env"
