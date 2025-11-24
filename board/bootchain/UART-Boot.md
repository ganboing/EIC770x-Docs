## HiFive P550 UART Boot Guide

Some background regarding P550 bootflow. For P550, it's a 1 DIE configuration (EIC7702 is 2 DIE).
Thus, the stock stable bootchain (w/o secure boot) comes only with 3 parts:

- Secondary Boot aka. "FIRMWARE": A tiny blob right after firmware to do basic initialization, such as PLL clock.
- DDR Init aka. "DDR": Blob for initializing DDR memory. ~200KB.
- U-Boot/OpenSBI payload aka. "BOOTLOADER": The actual bootloader.

These parts are packaged in a container image (bootchain) with ESWIN custom format that's similar to tar/cpio.
The program `nsign` is used to generate such container image. For each component in the image, there's
also metadata to describe its type FIRMWARE/DDR/BOOTLOADER, the load and entry point address, and the
CPU (SCPU or MCPU) that's responsible for running it. In regular boot configuration, such image is
flashed to boot SPI, and DIP switches are set to `[0 0 1 0]`. After power-on, the SCPU (32bit) starts
executing Masked ROM, where there's logic to check DIP switch states and parse, then load the blobs
from the bootchain and invoke them in a pre-defined order: FIRMWARE->DDR->BOOTLOADER

For bootloader developers, such as OpenSBI/U-Boot or EDK2, it might be helpful to a. replace the "BOOTLOADER"
at will, and b. start JTAG debugging as early as possible. EIC7700(X)/P550 has the ability to boot from UART.
In UART boot mode, the bootchain image is read from UART, bypassing boot SPI. Hence, there's zero possibility
of bricking the device. UART boot mode requires a slightly modified version of `nsign` configuration,
which is provided here [config.txt](https://github.com/ganboing/EIC770x-Docs/blob/main/p550/bootchain/uart/config.txt)
I also did a trick to use a dummy bootload payload which spins the MCPU such that you can JTAG debug from the
very first instruction. 

### Instruction
#### Setup Boot Mode
Connect the USB-C cable to FT4232 on P550. Verify you can see the following Serial Ports:
```
/dev/serial/by-id/
├── usb-FTDI_Quad_RS232-HS-if00-port0 -> ../../ttyUSB1
├── usb-FTDI_Quad_RS232-HS-if01-port0 -> ../../ttyUSB2
├── usb-FTDI_Quad_RS232-HS-if02-port0 -> ../../ttyUSB3
└── usb-FTDI_Quad_RS232-HS-if03-port0 -> ../../ttyUSB4
```
***
Attach to BMC console at port3
```
screen /dev/serial/by-id/usb-FTDI_Quad_RS232-HS-if03-port0 115200
```
***
Take note of the current DIP switch state.

Here my board was using Software Controlled DIP Switch State with value `[0 0 1 0]` (Boot from SPI)
```
#cmd: bootsel-g
Get: Bootsel Controlled by: SW, bootsel[3 2 1 0]:0 0 1 0
```
***
Set the DIP switch to Software Controlled and with value `[0 0 0 0]` (Boot from UART)
```
#cmd: bootsel-s sw 0
Set: Bootsel Controlled by: SW, bootsel[3 2 1 0]:0 0 0 0
```
#### Build nsign
```
# In some out-of-tree directory
$ git clone https://github.com/eswincomputing/Esbd-77serial-nsign.git
$ mkdir -p build
$ cd build && cmake ../ && cmake --build .
```
#### Build bootchain image for UART boot
```
$ git submodule update --init
$ PATH="<path-to-nsign>/build/src:$PATH" make
```
#### Verify bootchain image
Make sure it looks something like this
```
$ head -n20 uart/bootchain.ihex 
:020000043000CA
:10C0000045535742030000000100000000020000F9
:10C01000000000004C05000000000000000070005F
:10C02000000000000000000000000000010000000F
:10C03000600A000000000000A828040000000000C2
:10C0400000001000000000000000000000000000E0
:10C050000100000020360400000000000004000081
:10C06000000000000000300100000000000000009F
:04C0700000000000CC
:00000001FF
:020000043000CA
:10800000575345BB000000000000000000000000C6
...
```
#### Ready to boot
```
$ make boot-uart 
./boot-uart.sh uart/bootchain.ihex
About to transfer bootchain image...
Make sure your board is reset properly, and press Enter (Ctrl-c to abort)
R........ER................ER........................Epll config ok
R................ER.........................................................
............................................................................
 128KiB 0:00:17 [7.12KiB/s] [=====>                        ] 17% ETA 0:01:21
........................................R...................................
............................................................................
 256KiB 0:00:36 [6.77KiB/s] [==========>                   ] 34% ETA 0:01:08
............................................................................
............................................................R...............
 384KiB 0:00:55 [6.77KiB/s] [===============>              ] 51% ETA 0:00:51
............................................................................
............................................................................
 512KiB 0:01:14 [6.77KiB/s] [====================>         ] 69% ETA 0:00:33
...................................R........................................
............................................................................
 640KiB 0:01:33 [6.77KiB/s] [=========================>    ] 86% ETA 0:00:14
............................................................................
............R...............................................................
 740KiB 0:01:48 [6.83KiB/s] [=============================>] 100%
....................................................Edie_num:0,die_ordinal:0
Firmware version:1.5;disable ECC
PHY0 training process:100%
PHY1 training process:100%
DDR type:LPDDR5;Size:16GB,Data Rate:6400MT/s
DDR self test OK
R................ER........................................................E
```

#### JTAG openocd+gdb
At this point the MCPU has been kicked and it's spinning at the first `c.j $pc` instruction.
It's now a good time to attach JTAG with openocd. Refer to [JTAG Guide](../../README.md#jtag)
and [openocd config](../jtag/openocd_mcpu.cfg). Once the openocd has JTAG connected, gdb is
easy:
```
$ gdb -ex 'target extended-remote :3333'
GNU gdb (GDB) 14.1
...
0x0000000080000000 in ?? ()
(gdb) info threads
  Id   Target Id                                                      Frame 
* 1    Thread 1 "riscv.cpu0" (Name: riscv.cpu0, state: debug-request) 0x0000000080000000 in ?? ()
  2    Thread 2 "riscv.cpu1" (Name: riscv.cpu1, state: debug-request) 0x0000000080000000 in ?? ()
  3    Thread 3 "riscv.cpu2" (Name: riscv.cpu2, state: debug-request) 0x0000000080000000 in ?? ()
  4    Thread 4 "riscv.cpu3" (Name: riscv.cpu3, state: debug-request) 0x0000000080000000 in ?? ()
(gdb) disassemble $pc,+8
Dump of assembler code from 0x80000000 to 0x80000008:
=> 0x0000000080000000:	j	0x80000000
   0x0000000080000002:	j	0x80000000
   0x0000000080000004:	j	0x80000000
   0x0000000080000006:	j	0x80000000
End of assembler dump.
(gdb) 

```
