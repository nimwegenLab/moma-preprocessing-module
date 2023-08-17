#!/usr/bin/env bash

#
# Script dispatches the preprocessing of the dataset.
#

#set -u

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/setup_module.sh"

setup_module

### Start preprocessing with wrapper script
#eval "${MOMA_BIN_DIRECTORY}/moma_preprocess.sh" "$@"
source "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh"
#exit 1