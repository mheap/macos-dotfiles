#!/bin/zsh

source "$HOME/.local/zsh/includes/keys.zsh"
source "$HOME/.local/zsh/includes/aliases.zsh"
source "$HOME/.local/zsh/includes/completion.zsh"
source "$HOME/.local/zsh/includes/environment.zsh"
source "$HOME/.local/zsh/includes/history.zsh"
source "$HOME/.local/zsh/includes/prompt.zsh"
source "$HOME/.local/zsh/includes/syntax-highlighting.zsh"

source "$HOME/.local/zsh/plugins/history-substring-search/zsh-history-substring-search.zsh"
source "/usr/share/z/z.sh"


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Below this is temporary
function rg(){
    docker stop graphite
    docker rm graphite
    sudo docker run -d \
        --name graphite \
        -p 81:80 \
        -p 2003:2003 \
        -p 8125:8125/udp \
        hopsoft/graphite-statsd
}

export NVM_DIR="/home/michael/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

