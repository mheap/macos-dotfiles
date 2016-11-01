#!/bin/zsh

autoload -U colors && colors

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '$'
}

function git_branch {
    BRANCH="$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3,4,5)"
    if ! test -z $BRANCH; then
        COL="%{$fg[green]%}" # Everything's fine
        [[ $(git log origin/$BRANCH..HEAD 2> /dev/null ) != "" ]] && COL="%{$fg[blue]%}" # We have changes to push
        [[ $(git status --porcelain 2> /dev/null) != "" ]] && COL="%{$fg[red]%}" # We have uncommited changes
        echo "$COL$BRANCH"
    fi
}

function _info_knife() {
    knife_info_msg_=""

    local ENVIRONMENT_FILE ENVIRONMENT COLOUR

    [[ ! -L "$HOME/.chef/knife.rb" ]] && return

    ENVIRONMENT_FILE=$(realpath "$HOME/.chef/knife.rb")
    ENVIRONMENT=$(basename $ENVIRONMENT_FILE | sed "s/knife-\(.*\).rb/\1/")
    COLOUR="$fg_bold[green]"

    # When the environment is `none`, skip showing knife information
    [[ "$ENVIRONMENT" == "none" ]] && return

    # Set colors based on the environment
    [[ "$ENVIRONMENT" == "production"  ]] && COLOUR="$fg[red]"
    [[ "$ENVIRONMENT" == "staging"     ]] && COLOUR="$fg[yellow]"
    [[ "$ENVIRONMENT" == "development" ]] && COLOUR="$fg[green]"
    [[ "$ENVIRONMENT" == "automation"    ]] && COLOUR="$fg[magenta]"
    [[ "$ENVIRONMENT" == "berksapi"    ]] && COLOUR="$fg[blue]"

    ENVIRONMENT="%{$COLOUR%}${ENVIRONMENT}%{$reset_color%}"
    knife_info_msg_="%{$reset_color%}(%{$fg_bold[green]%}knife:%{$reset_color%}${ENVIRONMENT}) "
}

function precmd() {
    NAME=""
    if [[ $(whoami) != "michael" ]]; then; NAME="%n%{$reset_color%}@"; fi;

    _info_knife
    PROMPT="%{$fg[red]%}$NAME%{$fg[green]%}%m ${knife_info_msg_}%{$fg[yellow]%}%~ %{$reset_color%}% 
$(prompt_char) "
    RPROMPT="$(git_branch)%{$reset_color%}%"
}
