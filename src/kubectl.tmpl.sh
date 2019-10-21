$shebang_sub

$timeout_sub

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
$beginning_sub

    # find namespace
    local namespace=""

    for ((i=0; i<${#tokens}; i++)); do
        tok=${tokens[i]}
        n_tok=${tokens[i+1]}
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

    local args=("$namespace")
    args+=$@
    _fzf_complete_kubectl_pods "$args[@]"

# $finish_sub
}

$init_sub
