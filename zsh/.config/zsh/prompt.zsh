# setopt PROMPT_SUBST

# zmodload zsh/datetime
# autoload add-zsh-hook

# ### Rosé Pine palette
# typeset -g RP_TEXT='#e0def4'
# typeset -g RP_IRIS='#c4a7e7'
# typeset -g RP_ROSE='#ebbcba'
# typeset -g RP_FOAM='#9ccfd8'
# typeset -g RP_LOVE='#eb6f92'
# typeset -g RP_SUBTLE='#908caa'
# typeset -g RP_BASE='#191724'
# typeset -g RP_HIGHLIGHT='#403d52'
# typeset -g RP_PINE='#31748f'

# ### Line 1
# line1() {
#     local dir=${(%):-%~}
#     local date=${(%):-%D{%a %b %d %Y}}
#     local gap

#     print -nP "%F{$RP_IRIS}%~%f"
#     gap=$(( COLUMNS - ${#dir} - ${#date} - 1 ))

#     # git
#     local git_branch=''
#     if [[ -f .git/HEAD ]]; then
#         IFS= read -r head < .git/HEAD

#         if [[ $head == 'ref: refs/heads/'* ]]; then
#             git_branch=${head#'ref: refs/heads/'}
#         fi
#     fi

#     if [[ -n $git_branch ]]; then
#         print -nP "  %F{$RP_ROSE}git:${git_branch}%f"
#         (( gap-=6+${#git_branch} ))
#     fi

#     # right side
#     if (( gap > 4 )); then
#         printf '%*s' "$gap" ''
#         print -nP "%F{$RP_SUBTLE}%D{%a %b %d %Y}%f"
#     fi
# }

# ### Hook functions
# typeset -g exit_status=0

# typeset -g start_time=''
# typeset -g end_time=''
# typeset -g duration=''

# # display
# typeset -g prompt_display=''
# typeset -g status_display=''
# typeset -g duration_display=''

# # preexec
# get_start_time() {
#     start_time=$EPOCHREALTIME
# }

# _preexec() {
#     get_start_time
# }
# add-zsh-hook preexec _preexec

# # precmd
# get_duration() {
#     if [[ -n $start_time ]]; then
#         printf -v duration '%.3f' "$(( end_time - start_time ))"
#         start_time=''
#     else
#         duration=''
#     fi
# }

# set_display() {
#     if (( exit_status == 0 )); then
#         prompt_display="%F{$RP_TEXT}$USER:$HOST%f%F{$RP_FOAM}%(#.#.>)%f"
#         status_display=""
#     else
#         prompt_display="%F{$RP_TEXT}$USER:$HOST%f%F{$RP_LOVE}%(#.#.>)%f"
#         status_display="[%F{$RP_LOVE}${exit_status}%f] "
#     fi

#     if [[ -n $duration ]]; then
#         duration_display="%F{$RP_FOAM}${duration}s%f "
#     else
#         duration_display=""
#     fi
# }

# _precmd() {
#     exit_status=$?
#     end_time=$EPOCHREALTIME

#     get_duration
#     set_display
# }
# add-zsh-hook precmd _precmd

# ### PS1
# PS1='
# $(line1)
# ${prompt_display} '

# ### RPROMPT
# RPROMPT='${status_display}${duration_display}%F{#908caa}%D{%H:%M:%S}%f'

setopt PROMPT_SUBST

zmodload zsh/datetime
autoload -Uz add-zsh-hook

### Rosé Pine palette
typeset -g RP_TEXT='#e0def4'
typeset -g RP_IRIS='#c4a7e7'
typeset -g RP_ROSE='#ebbcba'
typeset -g RP_FOAM='#9ccfd8'
typeset -g RP_LOVE='#eb6f92'
typeset -g RP_SUBTLE='#908caa'
typeset -g RP_HIGHLIGHT='#403d52'
typeset -g RP_PINE='#31748f'
typeset -g RP_GOLD='#f6c177'

### State: updated once before each prompt
typeset -g _prompt_start_time=''
typeset -g _prompt_duration=''
typeset -gi _prompt_exit_status=0
typeset -g _prompt_branch=''
typeset -g _prompt_dirty=''

### Rendered second line and right prompt
typeset -g _prompt_line2=''
typeset -g _prompt_right_status=''
typeset -g _prompt_right_duration=''

_prompt_update_git() {
    _prompt_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    _prompt_dirty=''

    # Detached HEAD: show an abbreviated commit ID.
    if [[ -z $_prompt_branch ]]; then
        local commit
        commit=$(git rev-parse --short HEAD 2>/dev/null)
        [[ -n $commit ]] && _prompt_branch="@$commit"
    fi

    if [[ -n $_prompt_branch && -n $(git status --porcelain 2>/dev/null) ]]; then
        _prompt_dirty='+'
    fi
}

### Line 1: directory, Git, and right-aligned date
_prompt_line1() {
    local dir=${(%):-%~}
    local date=${(%):-%D{%a %b %d %Y}}
    local max_dir=$(( COLUMNS / 2 ))
    local width gap

    (( max_dir < 8 )) && max_dir=8

    # Prefer the end of a long path; reserve room for Git and the date.
    if (( ${#dir} > max_dir )); then
        dir="…${dir[-$(( max_dir - 1 )),-1]}"
    fi

    width=${#dir}
    local safe_dir=${dir//\%/%%}
    local line="%F{$RP_IRIS}${safe_dir}%f"

    if [[ -n $_prompt_branch ]]; then
        local safe_branch=${_prompt_branch//\%/%%}
        line+="  %F{$RP_ROSE} ${safe_branch}%f"
        (( width += 4 + ${#_prompt_branch} ))

        if [[ -n $_prompt_dirty ]]; then
            line+=" %F{$RP_GOLD}+%f"
            (( width += 2 ))
        fi
    fi

    gap=$(( COLUMNS - width - ${#date} - 1 ))
    if (( gap > 1 )); then
        local padding=''
        printf -v padding '%*s' "$gap" ''
        line+="${padding}%F{$RP_SUBTLE}%D{%a %b %d %Y}%f"
    fi

    # Raw output: Zsh expands all % prompt escapes exactly once in PS1.
    print -rn -- "$line"
}

### Line 2: identity, Powerline separator, and command symbol
_prompt_render_line2() {
    local user_bg=$RP_HIGHLIGHT
    local symbol_color=$RP_FOAM

    # Make privileged shells visually distinct.
    if (( EUID == 0 )); then
        user_bg=$RP_LOVE
    fi

    if (( _prompt_exit_status != 0 )); then
        symbol_color=$RP_LOVE
        _prompt_right_status="[%F{$RP_LOVE}${_prompt_exit_status}%f] "
    else
        _prompt_right_status=''
    fi

    _prompt_line2=''

    # Hostname is useful primarily over SSH.
    if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_TTY:-} ]]; then
        _prompt_line2="%K{$RP_PINE}%F{$RP_TEXT} $HOST "
        _prompt_line2+="%F{$RP_PINE}%K{$user_bg}"
    fi

    _prompt_line2+="%K{$user_bg}%F{$RP_TEXT} $USER "
    _prompt_line2+="%k%F{$user_bg}%f"
    _prompt_line2+=" %F{$symbol_color}%(#.#.❯)%f"

    if [[ -n $_prompt_duration ]]; then
        _prompt_right_duration="%F{$RP_FOAM}${_prompt_duration}s%f "
    else
        _prompt_right_duration=''
    fi
}

### Hooks: collect state before rendering
_prompt_preexec() {
    _prompt_start_time=$EPOCHREALTIME
}

_prompt_precmd() {
    _prompt_exit_status=$?
    local end_time=$EPOCHREALTIME

    if [[ -n $_prompt_start_time ]]; then
        printf -v _prompt_duration '%.3f' "$(( end_time - _prompt_start_time ))"
        _prompt_start_time=''
    else
        _prompt_duration=''
    fi

    _prompt_update_git
    _prompt_render_line2
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd

### Prompt layout
PS1='
$(_prompt_line1)
${_prompt_line2} '

RPROMPT='${_prompt_right_status}${_prompt_right_duration}%F{$RP_SUBTLE}%D{%H:%M:%S}%f'
