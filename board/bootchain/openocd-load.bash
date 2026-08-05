#!/usr/bin/env bash

FIRMWARE="$1"
FW_BASE=0
FW_FMT="${FIRMWARE##*.}"

if [[ "$FW_FMT" == "bin" ]]; then
  FW_BASE=0x80000000
elif [[ "$FW_FMT" != "elf" ]]; then
  echo "Unsupported file format: $FIRMWARE" >&2
  exit 1
fi
LOAD_ARGS=( -c "load_image \"$FIRMWARE\" $FW_BASE $FW_FMT" )

LIN_BASE=0x80200000
#FDT_BASE=0x90000000

if [[ $# -ge 2 ]]; then
  LOAD_ARGS+=( -c "load_image \"$2\" $LIN_BASE bin" )
  #LOAD_ARGS+=( -c "load_image \"$3\" $FDT_BASE bin" )
fi
