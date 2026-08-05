## JTAG Ready Bootchain Image

If you find yourself constantly need to flash new bootchains for debug/test, it's preferred to
flash the JTAG ready bootchain, which contains a dummy "BOOTLOADER" that halts the MCPU. Basic
platform initialization and DDR training are done as usual, making it ideal for downloading any
bootloader payload.

### Build the bootchain
```shell
$ cd jtag-ready
$ PATH="<path-to-nsign>/build/src:$PATH" nsign
```

### Flashing

Refer to [README](./README.md)

### Run
Once powered on, you would observe the following:
```
OK pll config ok
die_num:0,die_ordinal:0
Firmware version:1.5;disable ECC
PHY0 training process:100%
PHY1 training process:100%
DDR type:LPDDR5;Size:16GB,Data Rate:6400MT/s
DDR self test OK
```

At this point, you can use JTAG to upload and kickstart or being debugging the MCPU.
Refer to [JTAG upload](./UART-Boot.md#jtag-upload) and [JTAG GDB](./UART-Boot.md#jtag-gdb-debugging)