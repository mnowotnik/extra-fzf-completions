# zsh

# Timeout in seconds
export EXTRA_FZF_COMPLETIONS_TIMEOUT=7
export EXTRA_FZF_COMPLETIONS_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
if [[ -n "$EXTRA_FZF_COMPLETIONS" ]]; then
    for completion in ${EXTRA_FZF_COMPLETIONS[@]}; do
        case $completion in
            kubectl) source "${0:A:h}/zsh/kubectl-fzf-completion.zsh" 2>/dev/null || : ;;
            docker)  source "${0:A:h}/zsh/docker-fzf-completion.zsh" 2>/dev/null || :  ;;
            jira)    source "${0:A:h}/zsh/jira-fzf-completion.zsh" 2>/dev/null || :    ;;
        esac
    done
fi
