#!/bin/zsh
setopt promptsubst

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit && compinit

# Use case-insensitive completion matches
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# load custom executable functions
for function in ~/.zsh/functions/*; do
    if [[ -n "$DEBUG" ]]; then
        echo "Sourcing $function"
    fi

    source "$function"
done

# makes color constants available
autoload -U colors && colors

# Required for compatibility with old version of zsh
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  #wrap colours between %{ %} to avoid weird gaps in autocomplete
    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH"

# aliases
if [[ -f ~/.aliases ]]; then
    if [[ -n "$DEBUG" ]]; then
        echo "Sourcing ~/.aliases"
    fi

    source ~/.aliases
fi

# environment variables
if [[ -f ~/.env ]]; then
    if [[ -n "$DEBUG" ]]; then
        echo "Sourcing ~/.env"
    fi

    source ~/.env
fi

# Use colorized ls
if [[ $(uname -s) == 'Darwin' ]]; then
    export CLICOLOR=1
    export LSCOLORS='Exfxcxdxbxegedabagacad'
else
    alias ls='ls --color=auto'
fi

# Ensure the HOSTNAME environment variable is set so that `rcm` works properly
if [[ -z "$HOSTNAME" ]]; then
    export HOSTNAME=$(hostname -s)
fi

# Don't autocorrect arguments
unsetopt correct_all

SEGMENT_START='['
SEGMENT_END=']'

# Draws a segment of the prompt if the given content is non-empty.
prompt_segment() {
    if [[ -n $1 ]]; then
        echo -n "$SEGMENT_START$1$RESET$SEGMENT_END"
    fi
}

# Builds the complete prompt
build_prompt() {
    exit=$?

    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        prompt_segment "${BOLD_YELLOW}ssh:$HOSTNAME"
    fi
    prompt_segment "$(git_prompt_info)"
    prompt_segment "${BOLD_BLUE}%~"
    if [[ $exit -gt 0 ]]; then
        prompt_segment "$(exit_code)"
    fi

    echo -n " "
}

# Adds an indicator of where the HEAD is in the graph.
#
# If HEAD is on a branch, the branch name is output in green. If HEAD is
# on a tag, the tag name is output in yellow. If HEAD is on neither a
# branch nor a tag, the short SHA is output in red.
#
# The code assumes that if the HEAD is detached and the ref matches the
# format of a SHA, it is a SHA; otherwise it is a tag.
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $ref ]]; then
        echo "${BOLD_GREEN}${ref#refs/heads/}"
    else
        tag=$(git branch --no-color 2> /dev/null |
                  sed -e '/^[^*]/d' -e "s/* (HEAD detached at \(.*\))/\1/")

        if [[ -n $tag ]] && [[ $tag =~ ^[a-f0-9]+$ ]]; then
            echo "${BOLD_RED}${tag}"
        elif [[ -n $tag ]]; then
            echo "${BOLD_YELLOW}${tag}"
        fi
    fi
}

# Add any non-zero exit code in red
exit_code() {
    echo -n "%(?..${BOLD_RED}%?)"
}

export PROMPT='$RESET$(build_prompt)'

# Perform any app-specific initializations
for init in $HOME/.zsh/init/*.sh; do
    if [[ -n "$DEBUG" ]]; then
        echo "Sourcing $init"
    fi

    source "$init"
done
