# Eza aliases
# Remove any existing ll function first
functions -e ll 2>/dev/null

alias ls="eza"
alias ll="eza -hl"
alias la="eza -hlA"
alias lt="eza --tree"
abbr -a rr "rm -r"
abbr -a rf "rm -rf"

abbr -a cl "claude"
abbr -a clc "claude -c"
abbr -a clr "claude -r"
