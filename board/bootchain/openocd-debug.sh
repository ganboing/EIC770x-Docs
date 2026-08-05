#!/usr/bin/env bash

set -eux

DIR="$(readlink -f "$(dirname "$0")")"
source "$DIR/openocd-load.bash"

exec openocd -f "$DIR/../jtag/openocd_mcpu.cfg"\
 -c "halt" "${LOAD_ARGS[@]}" \
 -c "halt"
