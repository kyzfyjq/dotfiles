setopt PROMPT_SUBST

zmodload zsh/datetime
autoload add-zsh-hook

### Line 1
line1() {
    local dir=${(%):-%~}
    local date=${(%):-%D{%a %b %d %Y}}
    local gap

    print -nP '%F{blue}%~%f'
    gap=$(( COLUMNS - ${#dir} - ${#date} - 1 ))

    # git
    local git_branch=''
    if [[ -f .git/HEAD ]]; then
        IFS= read -r head < .git/HEAD

        if [[ $head == 'ref: refs/heads/'* ]]; then
            git_branch=${head#'ref: refs/heads/'}
        fi
    fi

    if [[ -n $git_branch ]]; then
        print -nP "  %F{yellow}git:${git_branch}%f"
        (( gap-=6+${#git_branch} ))
    fi

    # right side
    if (( gap > 4 )); then
        printf '%*s' "$gap" ''
        print -nP '%D{%a %b %d %Y}'
    fi
}

### Hook functions
typeset -g exit_status=0

typeset -g start_time=''
typeset -g end_time=''
typeset -g duration=''

# display
typeset -g prompt_display=''
typeset -g status_display=''
typeset -g duration_display=''

# preexec
get_start_time() {
    start_time=$EPOCHREALTIME
}

_preexec() {
    get_start_time
}
add-zsh-hook preexec _preexec

# precmd
get_duration() {
    if [[ -n $start_time ]]; then
        printf -v duration '%.3f' "$(( end_time - start_time ))"
        start_time=''
    else
        duration=''
    fi
}

set_display() {
    if (( exit_status == 0 )); then
        prompt_display="$USER:$HOST%F{green}%(#.#.>)%f"
        status_display=""
    else
        prompt_display="$USER:$HOST%F{red}%(#.#.>)%f"
        status_display="[%F{red}${exit_status}%f] "
    fi

    if [[ -n $duration ]]; then
        duration_display="%F{green}${duration}s%f "
    else
        duration_display=""
    fi
}

_precmd() {
    end_time=$EPOCHREALTIME
    exit_status=$?

    get_duration
    set_display
}
add-zsh-hook precmd _precmd

### PS1
PS1='
$(line1)
${prompt_display} '

### RPROMPT
RPROMPT='${status_display}${duration_display}%F{yellow}%D{%H:%M:%S}%f'