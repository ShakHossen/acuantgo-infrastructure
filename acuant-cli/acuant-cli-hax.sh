#!/usr/bin/env bash

[ -z "$ORIGINAL_BASH_SOURCE" ] && ORIGINAL_BASH_SOURCE="${BASH_SOURCE:-${(%):-%x}}"
[ -z "$ORIGINAL_ARGS" ] && ORIGINAL_ARGS="$@"

# Guess if we should use colors or not - Jenkins doesn't do well with them.
[[ -z "$USE_COLORS" ]] && [[ -z "$BUILD_NUMBER" ]] && test -t && USE_COLORS="1"

if [[ ! -z "$USE_COLORS" ]]; then
#BEGIN_INCLUDE acuant-cli-colors.sh
source $(dirname $BASH_SOURCE)/acuant-cli-colors.sh
#END_INCLUDE
fi

#BEGIN_INCLUDE acuant-cli-0.sh
source $(dirname $BASH_SOURCE)/acuant-cli-0.sh
#END_INCLUDE


# Not actually using entire AcuantCLI (yet)
