HISTFILE=$HOME/.local/state/zsh/history
HISTSIZE=20000
SAVEHIST=10000

# Share History between shells
setopt SHARE_HISTORY

# Store timestamps
setopt EXTENDED_HISTORY

# Remove duplicates commands
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_FIND_NO_DUPS

# Prevent accidental file overwrites
setopt NO_CLOBBER HIST_ALLOW_CLOBBER

# Exclude unnecessary or unhelpful commands from history
setopt HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt HIST_NO_STORE HIST_NO_FUNCTIONS