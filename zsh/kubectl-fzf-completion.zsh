#! /usr/bin/env zsh

if ! type _extra_fzf_completions_timeout >/dev/null 2>&1; then
    _extra_fzf_completions_timeout() {
        local timeout_interval=${EXTRA_FZF_COMPLETIONS_TIMEOUT:-7}
        timeout $timeout_interval $@
    }
fi

if [[ -z $EXTRA_FZF_COMPLETIONS_FZF_PREFIX ]]; then
    export EXTRA_FZF_COMPLETIONS_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
fi

_fzf_complete_kubectl_pods () {
    local namespace=$1
    shift
    local args=$@
    args+=$prefix
    local oprefix=$prefix
    prefix=
    _fzf_complete "$EXTRA_FZF_COMPLETIONS_FZF_PREFIX -m --header-lines=1" "$args[@]" < <(
        if [[ -n $namespace ]]; then
            _extra_fzf_completions_timeout kubectl -n $namespace get pods
        else
            _extra_fzf_completions_timeout kubectl get pods
        fi
    )
    prefix=$oprefix
}

_fzf_complete_kubectl_pods_post() {
    awk '{print $1}'
}


_fzf_complete_kubectl() {
    local words
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
    # http://zsh.sourceforge.net/FAQ/zshfaq03.html
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    words=(${(z)LBUFFER})
    local stop_iter=${#words[@]}
    local beg_iter=1

    # find namespace
    local namespace=""

    for ((i=$beg_iter; i<$stop_iter; i++)); do
        tok=${words[i]}
        n_tok=${words[i+1]}
        case "$tok" in
            -n|--namespace)
                namespace=$n_tok
                ;;
            -n=*|--namespace=*)
                namespace=${tok##--namespace=}
                namespace=${namespace##-n=}
                ;;
            get|logs|describe|port-forward|delete)
                cmd=$tok
                ;;
        esac
    done

    if [[ -z $cmd ]]; then
        
        return
    fi

    _fzf_complete_kubectl_pods "$namespace" "$@"
}


