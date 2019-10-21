$shebang_sub

$timeout_sub

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
$beginning_sub
    for ((i=0; i<$stop_iter;i++)); do
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
$finish_sub
}


$init_sub
