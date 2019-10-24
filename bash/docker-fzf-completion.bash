#!/usr/bin/env bash

if ! type _extra_fzf_completions_timeout >/dev/null 2>&1; then
    _extra_fzf_completions_timeout() {
        local timeout_interval=${EXTRA_FZF_COMPLETIONS_TIMEOUT:-7}
        timeout $timeout_interval $@
    }
fi

_fzf_complete_docker_run_post() {
    awk '{print $1":"$2}'
}

_fzf_complete_docker_run () {
    _fzf_complete "$EXTRA_FZF_COMPLETIONS_FZF_PREFIX -m --header-lines=1" "$@" < <(
        _extra_fzf_completions_timeout docker images
    )
}

_fzf_complete_docker_common_post() {
    awk -F"\t" '{print $1}'
}

_fzf_complete_docker_common () {
    _fzf_complete "$EXTRA_FZF_COMPLETIONS_FZF_PREFIX --reverse -m" "$@" < <(
        _extra_fzf_completions_timeout docker images --format "{{.Repository}}:{{.Tag}}\t {{.ID}}"
    )
}

_fzf_complete_docker_container_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container () {
    _fzf_complete "$EXTRA_FZF_COMPLETIONS_FZF_PREFIX -m --header-lines=1" "$@" < <(
        _extra_fzf_completions_timeout docker ps -a
    )
}

_fzf_complete_docker() {
local cur prev words cword
        _get_comp_words_by_ref -n : cur prev words cword
        local stop_iter=$cword
        local beg_iter=0
        if ! type $_fzf_orig_completion_docker > /dev/null 2>&1; then
            _completion_loader "$@"
            complete -F _fzf_complete_docker -o default -o bashdefault docker
        fi
    for ((i=$beg_iter; i<$stop_iter;i++)); do
        case "${words[$i]}" in
            run)
                _fzf_complete_docker_run "$@"
                return
            ;;
            exec|rm)
                _fzf_complete_docker_container "$@"
                return
            ;;
            save|load|push|pull|tag|rmi)
                _fzf_complete_docker_common "$@"
                return
            ;;
        esac
    done
_fzf_handle_dynamic_completion docker "$@"
}


export _fzf_orig_completion_docker=_docker
complete -F _fzf_complete_docker -o default -o bashdefault docker
