HISTFILE=$HOME/.local/state/zsh/history
HISTSIZE=200000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Remove duplicates commands
setopt HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST

# Exclude unnecessary or unhelpful commands from history
setopt HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt HIST_NO_STORE HIST_NO_FUNCTIONS

# HISTDB
HISTDB_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/histdb/zsh-history.db"
HISTDB_PLUGIN="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-histdb"

if [[ -r "$HISTDB_PLUGIN/sqlite-history.zsh" ]]; then
    source "$HISTDB_PLUGIN/sqlite-history.zsh"
fi

if (( $+commands[fzf] )) && [[ -r "$HISTDB_PLUGIN/histdb-fzf.zsh" ]]; then
    source "$HISTDB_PLUGIN/histdb-fzf.zsh"
    bindkey '^R' _fzf_histdb_widget
fi

unset HISTDB_PLUGIN
