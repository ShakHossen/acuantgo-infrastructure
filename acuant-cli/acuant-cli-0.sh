[ -z "$ORIGINAL_BASH_SOURCE" ] && ORIGINAL_BASH_SOURCE="${BASH_SOURCE:-${(%):-%x}}"
[ -z "$ORIGINAL_ARGS" ] && ORIGINAL_ARGS="$*"

# Common Core Utilities For AcuantCLI
ACUANT_CLI_CMD="acuantcli"
ACUANT_CLI_NAME="Acuant CI/CD Command Line Interface (CLI)"
ACUANT_CLI_VERSION="1.0.3"

abspath() { echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")" ; }
now() { date "+%Y/%m/%d %H:%M:%S"; }

# "msg" "lvl" "color"

std_msg_fmt(){ >&2 echo -e "${Blue}$(now)${Color_Off} ${IBlack}[$STAGE]${Color_Off} ${!2}${1}${Color_Off}:" "${@:3:4}" "${Color_Off}" ;}
info() { std_msg_fmt 'INFO' 'BGreen' "$@" ; return 0; }
warn() { std_msg_fmt 'WARN' 'BYellow' "$@" ; return 1; }
fail() { std_msg_fmt 'FAIL' 'BRed'  "$@" ; exit 1; }


req_env() { [ -n "$1" -a -n "${!1}" ] || fail "Missing required ENV: ${BYellow}$*"; }
req_bin() { [ -x "$(which $1)" ] || fail "Missing required BIN: ${BYellow}$*"; }
req_dir() { [ -n "${!1}" -a -d "${!1}" ] || fail "Missing required DIR: ${BYellow}$1=${!1}" "${@:2}"; }
req_file() { [ -n "$1" -a -n "${!1}" -a -f "${!1}" ] || fail "Missing required FILE: ${BYellow}$1=${!1}" "${@:2}"; }
req_sec()  { [ -n "$1" -a -n "${!1}" ] || fail "Missing required Secret (ENV): ${BYellow}$*"; }

default() {
    [[ -z "${!1}" ]] && export "$1=$2"; is_debug && >&2 echo "$1=\"${!1}\"";
    echo "  $1: \"\${$1}\"" >> "${CONFIG_MAP_TEMPLATE}";
}
concat() { nv="${!1} $2"; export "$1=$nv"; is_debug && >&2 echo "$1=\"${!1}\""; }
fn_exists() { declare -F "$1" > /dev/null; }
has_arg() { argvar="ARG_$(echo $1 | tr '[:lower:]' '[:upper:]')"; [ -z "${!argvar}" ] ; }
opt_hook() { fn_exists "hook:$1" && hook:$1 "${@:2}" || return 1; }
acuant_cli_plugin() { debug "Loading Plugin $(basename $ACUANT_CLI_PLUGIN)@$*" ; }
run_hook() {
    local old_stage="$STAGE"
    local hook_name=$1;
    local hook_fn;
    shift;
    debug2 "run hook '$hook_name'"
    for hook_fn in $(declare -F | cut -d ' ' -f 3 | grep "^hook:$hook_name" | sort) ; do
        debug2 "running hook '$hook_fn'"
        STAGE="[$(echo $hook_fn | cut -c 5-)]"
        $hook_fn "$@"
        STAGE="$old_stage"
        debug2 "completed hook '$hook_fn'"
    done
    STAGE="$old_stage"
}


#BEGIN_DEBUG_DEF
[[ "$ORIGINAL_ARGS" == *"-vv "* ]] && ARG_VERY_VERBOSE="true"
[[ "$ORIGINAL_ARGS" == *"-v "* ]] && ARG_VERBOSE="true" || ARG_VERBOSE="$ARG_VERY_VERBOSE"
is_debug() { [[ ! -z "$ARG_VERBOSE" ]] ;}
if [[ -z "$ARG_VERBOSE" ]] ; then
    debug() { return 0; }
else
    debug() { std_msg_fmt 'DEBUG' 'Blue' "$@" ; return 0; }
fi
if [[ -z "$ARG_VERY_VERBOSE" ]] ; then
    debug2() { return 0; }
else
    debug2() { std_msg_fmt 'TRACE' 'Blue'  "$@" ; return 0; }
fi
#END_DEBUG_DEF


CLI_BIN_DIR="$(dirname $(abspath $ORIGINAL_BASH_SOURCE))"
ACUANT_CLI_CMD="$(basename $ORIGINAL_BASH_SOURCE)"
STAGE="[$ACUANT_CLI_CMD]"
