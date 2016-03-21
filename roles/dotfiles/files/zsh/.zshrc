#!/bin/zsh

source "$HOME/.local/zsh/includes/keys.zsh"
source "$HOME/.local/zsh/includes/aliases.zsh"
source "$HOME/.local/zsh/includes/completion.zsh"
source "$HOME/.local/zsh/includes/environment.zsh"
source "$HOME/.local/zsh/includes/history.zsh"
source "$HOME/.local/zsh/includes/prompt.zsh"
source "$HOME/.local/zsh/includes/syntax-highlighting.zsh"

source "$HOME/.local/zsh/plugins/history-substring-search/zsh-history-substring-search.zsh"
source "/usr/lib/z.sh"


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
