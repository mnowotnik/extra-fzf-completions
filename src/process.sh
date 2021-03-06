#!/usr/bin/env bash

tmpl=$1
tool=$2
shell=$3

unset init_sub beginning_sub finish_sub

if [[ -f src/$tool.custom.sh ]]; then
    source src/$tool.custom.sh
fi

if ! type timeout >/dev/null 2>&1; then

    read -d '' timeout_sub <<- EOM
if ! type _extra_fzf_completions_timeout >/dev/null 2>&1; then
# based on http://www.bashcookbook.com/bashinfo/source/bash-4.0/examples/scripts/timeout3 
_extra_fzf_completions_timeout() {
local timeout_interval=\${EXTRA_FZF_COMPLETIONS_TIMEOUT:-7}
(
    ((t = \$timeout_interval))

    while ((t > 0)); do
        sleep \$interval
        kill -0 \$\$ || exit 0
        ((t -= interval))
    done

    # Be nice, post SIGTERM first.
    # The 'exit 0' below will be executed if any preceeding command fails.
    kill -s SIGTERM \$\$ && kill -0 \$\$ || exit 0
    sleep \$delay
    kill -s SIGKILL \$\$
) 2> /dev/null &

\$@
}
fi
EOM

    export timeout_sub

    else
        read -d '' timeout_sub <<- EOM
if ! type _extra_fzf_completions_timeout >/dev/null 2>&1; then
    _extra_fzf_completions_timeout() {
        local timeout_interval=\${EXTRA_FZF_COMPLETIONS_TIMEOUT:-7}
        timeout \$timeout_interval \$@
    }
fi
EOM
    export timeout_sub

fi

if [[ "$shell" == "zsh" ]]; then
    export shebang_sub="#! /usr/bin/env zsh"
    if ! [[ -v beginning_sub ]]; then
        read -d '' beginning_sub <<-EOM
    local words
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
    # http://zsh.sourceforge.net/FAQ/zshfaq03.html
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    words=(\${(z)LBUFFER})
    local stop_iter=\${#words[@]}
    local beg_iter=1
EOM
    beginning_sub="    $beginning_sub"
    fi

    export beginning_sub
    if ! [[ -v finish_sub ]]; then
        export finish_sub=
    fi

    elif [[ "$shell" == "bash" ]]; then

    export shebang_sub="#!/usr/bin/env bash"

    if ! [[ -v beginning_sub ]]; then
    read -d '' beginning_sub <<-EOM
    local cur prev words cword
    _get_comp_words_by_ref -n : cur prev words cword
    local stop_iter=\$cword
    local beg_iter=0
    if ! type \$_fzf_orig_completion_$tool > /dev/null 2>&1; then
        _completion_loader "\$@"
        complete -F _fzf_complete_$tool -o default -o bashdefault $tool
    fi
EOM
    beginning_sub="    $beginning_sub"
    fi

    export beginning_sub

    if ! [[ -v init_sub ]]; then
    read -d '' init_sub <<- EOM
export _fzf_orig_completion_$tool=_$tool
complete -F _fzf_complete_$tool -o default -o bashdefault $tool
EOM
    fi

    export init_sub

    if ! [[ -v finish_sub ]]; then
        export finish_sub="_fzf_handle_dynamic_completion $tool \"\$@\""
    fi
else 
    exit 1
fi
cat $tmpl | envsubst '${shebang_sub},${beginning_sub},${init_sub},${finish_sub},${timeout_sub}'
