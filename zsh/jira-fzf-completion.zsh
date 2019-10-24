#! /usr/bin/env zsh

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
local words
        setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
        # http://zsh.sourceforge.net/FAQ/zshfaq03.html
        # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
        words=(${(z)LBUFFER})
        local stop_iter=${#words[@]}
        local beg_iter=1
_fzf_complete_jira_list "$@"
# 
}


