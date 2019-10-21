# bash

# Timeout in seconds
export EXTRA_FZF_COMPLETIONS_TIMEOUT=7
export EXTRA_FZF_COMPLETIONS_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
_extra_fzf_completions_main() {
local dir=$1
if [[ -n "$EXTRA_FZF_COMPLETIONS" ]]; then
    for completion in ${EXTRA_FZF_COMPLETIONS[@]}; do
        case $completion in
            kubectl) source "$dir/bash/kubectl-fzf-completion.bash" 2> /dev/null || : ;;
            docker)  source "$dir/bash/docker-fzf-completion.bash" 2> /dev/null || :  ;;
            jira)    source "$dir/bash/jira-fzf-completion.bash" 2> /dev/null || :    ;;
        esac
    done
fi
}

_extra_fzf_completions_main $(dirname "$(readlink -f $0)")
unset _extra_fzf_completions_main
