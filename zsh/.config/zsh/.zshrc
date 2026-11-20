# AppImage sets ARGV0; prevent zsh from passing it to mise and other commands.
unset ARGV0

setopt extendedglob notify
setopt EXTENDED_GLOB

unsetopt autocd beep

bindkey -e
stty -ixon

source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/bind.zsh"
source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/eval.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/source.zsh"

ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'


