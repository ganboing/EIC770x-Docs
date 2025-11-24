#!/usr/bin/env bash

set -eu

DIR="$(readlink -f "$(dirname "$0")")"
FIRMWARE="$1"
FMT="${FIRMWARE##*.}"
BASE=0

if [[ "$FMT" == "bin" ]]; then
  BASE=0x80000000
elif [[ "$FMT" != "elf" ]]; then
  echo "Unsupported file format: $FIRMWARE" >&2
  exit 1
fi

openocd -f "$DIR/../jtag/openocd_mcpu.cfg"\
 -c "halt; load_image \"$FIRMWARE\" $BASE $FMT" \
 -c "riscv.cpu0 riscv set_ebreakm off" \
 -c "riscv.cpu0 riscv set_ebreaks off" \
 -c "riscv.cpu1 riscv set_ebreakm off" \
 -c "riscv.cpu1 riscv set_ebreaks off" \
 -c "riscv.cpu2 riscv set_ebreakm off" \
 -c "riscv.cpu2 riscv set_ebreaks off" \
 -c "riscv.cpu3 riscv set_ebreakm off" \
 -c "riscv.cpu3 riscv set_ebreaks off" \
 -c "resume; exit"
