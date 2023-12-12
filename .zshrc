# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# List of plugins to load
plugins=(
	git
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Enable Vi mode
set -o vi

# Enable colors and change prompt:
#export TERM="xterm-256color"
autoload -U colors && colors

# Go to a directory by typing its name
setopt auto_cd

# History in cache directory:
HISTFILE=$ZSH/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# But.... home and end key escape sequences 
# are DIFFERENT depending on whether I'm in a tmux session or not!
# To determine if tmux is running, examine values of $TERM and $TMUX.
if [ "${TERM}" = "xterm-256color" ] && [ -n "${TMUX}" ]; then
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
else
  # Assign these keys if tmux is NOT being used:
  bindkey "^[[H" beginning-of-line
  bindkey "^[[F" end-of-line
fi

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} = vicmd ]] ||
       [[ ${1} = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} = main ]] ||
       [[ ${KEYMAP} = viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ ${1} = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' } # Use beam shape cursor for each new prompt.

# GPG workaround
export GPG_TTY=$(tty)

# Docker workaround
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Vim aliases
alias vi="nvim"
alias vim="nvim"
alias nano="nvim"
alias edit="nvim"

# Git aliases
alias clone="git clone"
alias commit="git add . ; git commit -m"
alias push="git push"
alias pull="git pull -R"
alias linuscommit="git -c user.name='Linus Torvalds' -c user.email='torvalds@linux-foundation.org' commit -m"

# Package management
alias install="brew install"
alias uninstall="brew uninstall"
alias newstuff="brew update && brew upgrade"
alias autoremove="brew autoremove"
alias cleanup="brew cleanup"

# Other
alias pprint="~/Dev/Bash/dotfiles/bin/pprint"
alias python="python3"

# Load other aliases from aliasrc
source $ZSH/aliasrc

export EDITOR=nvim
export VISUAL="$EDITOR"

# Env
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"

# Path
PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
PATH="/usr/local:$PATH"
PATH="/opt/local/bin:/opt/local/sbin:$PATH"
MANPATH="/opt/local/share/man:$MANPATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
