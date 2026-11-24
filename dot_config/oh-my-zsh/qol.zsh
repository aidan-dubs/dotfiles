if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
else
    export EDITOR='vi'
fi


export VISUAL=$EDITOR
export PAGER='less'
export MANPAGER='less'

bindkey -v; KEYTIMEOUT=20

export FZF_DEFAULT_OPTS='--layout=reverse --height=60% --border --bind=ctrl-j:down,ctrl-k:up'
export FZF_DEFAULT_OPTS='
  --layout=reverse --height=60%
  --border=rounded --padding=0 --margin=0,25%,0,0
  --pointer="" --marker="*" --prompt=" "
  --no-scrollbar --no-separator --info=hidden
  --bind=ctrl-j:down,ctrl-k:up --highlight-line
  --gutter=" "
'

export FZF_DEFAULT_COMMAND='fd -t f -H -E .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd -t d -H -E .git'
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS'--bind=ctrl-t:abort'"
export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS'--bind=alt-c:abort'"

zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept --layout=reverse --height=60% --border=rounded --padding=0 --margin=0,25%,0,0 --pointer="" --marker="*" --prompt=" " --no-scrollbar --no-separator --info=hidden --bind=ctrl-j:down,ctrl-k:up --highlight-line --gutter=" "

vf()  {
    if [[ $EDITOR == *nvim ]]; then
        $EDITOR -c "Telescope find_files"
    else
        local file
        file=$(fzf --bind=alt-f:abort) || return
        [[ -n $file ]] && $EDITOR "$file"
    fi
}

tp() {
    local result
    result=$(tmux ls -F '#S' 2>/dev/null | fzf --print-query --bind=alt-t:abort) || return
    local o=("${(@f)result}")
    [[ -z $o[1] && -z $o[2] ]] && return

    tmux new-session -A -s "${o[2]:-$o[1]}"
}

tsend() { [[ -n $BUFFER ]] && tmux new-session -d -s "${${(z)BUFFER}[1]:t}-$RANDOM" "$BUFFER; exec $SHELL" && print -s -- $BUFFER && BUFFER= && zle -M "sent to tmux" }


zi-widget() {
    local -x FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --bind=alt-z:abort"
    zle -I
    zi
    # zle reset-prompt
}
zle -N zi-widget

for map in emacs viins vicmd; do
    bindkey -M $map '^[z' zi-widget
done

zi-vf-widget() {
    local -x FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --bind=alt-p:abort"
    zle -I
    zi && vf
    # zle reset-prompt
}
zle -N zi-vf-widget

for map in emacs viins vicmd; do
    bindkey -M $map '^[p' zi-vf-widget
done

bindkey -s '^[f' ' vf^M'    # Alt-F  editor file picker
bindkey -s '^[t' ' tp^M'    # Alt-T  tmux session picker

# Alt-F: Editor file picker
# Alt-T: Tmux session picker
# Alt-S: Send to Tmux
# Alt-E: Edit command line
# Alt-Z: Zoxide
# Alt-C: Cd
# Ctl-T: File picker
# Alt-P: Folder then File

zle -N tsend
for map in emacs viins vicmd; do
    bindkey -M $map '^[s' tsend  # Alt-S  send current command line to a new tmux session
done

autoload -Uz edit-command-line
_edit_cmd_toggle() {
    local VISUAL=${EDITOR}' -c "nnoremap <M-e> <Cmd>wq<CR>" -c "inoremap <M-e> <Cmd>wq<CR>"'
    edit-command-line
}

bindkey -M viins '^[.' insert-last-word

zle -N _edit_cmd_toggle
for map in emacs viins vicmd; do
    bindkey -M $map "^[e" _edit_cmd_toggle
done
