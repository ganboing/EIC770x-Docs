#!/usr/bin/env bash

set -eu

UART=/dev/serial/by-id/usb-FTDI_Quad_RS232-HS-if02-port0
IHEX="$1"

# Dumped after `screen` exits
stty -F "$UART" 115200  \
-parenb -parodd -cmspar cs8 -hupcl -cstopb cread clocal -crtscts \
-ignbrk brkint ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl ixon -ixoff -iuclc -ixany -imaxbel -iutf8 \
-opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 \
-isig -icanon iexten -echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke -flusho -extproc

read -p "About to transfer bootchain image...
Make sure your board is reset properly, and press Enter (Ctrl-c to abort)"

cat "$UART" &
PID_CAT=$!

trap "kill -9 $PID_CAT" EXIT

pv -c < "$IHEX" > "$UART"
sleep 15
