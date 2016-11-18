# load fzf, if you are using it

if brew_contains_element "fzf"; then
    export FZF_TARGET="${BREW_HOME}/opt/fzf"

    # Auto-completion
    [[ $- == *i* ]] && source "${FZF_TARGET}/shell/completion.bash" 2> /dev/null

    # Key bindings
    . "${FZF_TARGET}/shell/key-bindings.bash"

    # Setting ag as the default source for fzf
    export FZF_DEFAULT_COMMAND='ag -l -g ""'

    # view what devices a running process has open `lsof -p 5051`
    complete -o bashdefault -o default -o nospace -F _fzf_complete_kill lsof
    # Viewing memory allocation with pmap (vmmap on osx). You can view the
    # memory allocations for a particular process with pmap (vmmap):
    complete -o bashdefault -o default -o nospace -F _fzf_complete_kill vmmap
    complete -o bashdefault -o default -F _fzf_path_completion ec
    complete -F _fzf_path_completion em
    complete -F _fzf_path_completion gittower

elif hash fzf 2>/dev/null; then
    true
fi
