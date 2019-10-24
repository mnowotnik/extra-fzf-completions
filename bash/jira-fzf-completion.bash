#!/usr/bin/env bash

if ! type _extra_fzf_completions_timeout >/dev/null 2>&1; then
    _extra_fzf_completions_timeout() {
        local timeout_interval=${EXTRA_FZF_COMPLETIONS_TIMEOUT:-7}
        timeout $timeout_interval $@
    }
fi

_fzf_complete_jira_list_post() {
    cat
}

_fzf_complete_jira_list () {
    _fzf_complete "$EXTRA_FZF_COMPLETIONS_FZF_PREFIX --reverse -m" "$@" < <(
        _extra_fzf_completions_timeout jira ls
    )
}

_fzf_complete_jira() {
    local cur prev words cword
    _get_comp_words_by_ref -n : cur prev words cword
    local stop_iter=$cword
    local beg_iter=0
    if ! type $_fzf_orig_completion_jira > /dev/null 2>&1; then
        _completion_loader "$@"
        complete -F _fzf_complete_jira -o default -o bashdefault jira
    fi
    _fzf_complete_jira_list "$@"
# _fzf_handle_dynamic_completion jira "$@"
}

export _fzf_orig_completion_jira=_jira
complete -F _fzf_complete_jira -o default -o bashdefault jira
