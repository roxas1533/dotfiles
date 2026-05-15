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

abbr -a cx "codex"
abbr -a cxc "codex resume --last"
abbr -a cxr "codex resume"
