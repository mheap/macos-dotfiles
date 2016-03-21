#!/bin/zsh

source "$HOME/.local/zsh/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
