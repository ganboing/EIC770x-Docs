## HiFive P550 UART Boot Guide

Some background regarding P550 bootflow. For P550, it's a 1 DIE configuration (EIC7702 is 2 DIE).
Thus, the stock stable bootchain (w/o secure boot) comes only with 3 parts:

- Secondary Boot aka. "FIRMWARE": A tiny blob right after firmware to do basic initialization, such as PLL clock.
- DDR Init aka. "DDR": Blob for initializing DDR memory. Ver. 1.3 is the smallest blob with size ~270KB.
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
of bricking the device. UART boot mode requires a slightly modified version of `nsign` configuration, which is
provided here [config.txt](./uart/config.txt) I managed to compress the DDR init blob with xz, and use a inplace
[xz-decompress loader](https://github.com/ganboing/xz-loader) to reduce the size to < 80KB, which greatly reduce
the time loading the binary blobs through UART. I also did a trick to use a dummy bootload payload which spins
the MCPU such that you can JTAG debug from the very first instruction. 

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
$ cd uart
$ PATH="<path-to-nsign>/build/src:$PATH" nsign
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
#### Ready to boot (using minicom, preferred for debugging)
First modify the `pu updir` field in `.minirc.p550` to point to the current directory (full path)
Then, copy it to your home directory.
Configure option `pu xonxoff` is crucial in this file. It enables software flow control, such that
we don't overwhelm the ROM code with data on serial port when it's not ready to receive it.
```
# First reset the board, and
$ minicom p550
```
Notice that you won't be seeing any output except for the minicom banner. This is expected
```
Welcome to minicom 2.8

OPTIONS: I18n 
Port /dev/serial/by-id/usb-FTDI_Quad_RS232-HS-if02-port0

Press CTRL-A Z for help on special keys
```
Now, Ctrl-A s, and send the `bootchain.ihex` using the ascii method
```
 +-[Upload]--+
 | zmodem    |
 | ymodem    |
 | xmodem    |
 | kermit    |
 | ascii     |
 +-----------+
```
Once it starts uploading, You'll observe the `ER...ER...Epll` string coming up pretty quickly.
This is good indication that the upload is working.
```
+----------------[ascii upload - Press CTRL-C to quit]-----------------+
|ASCII upload of "bootchain.ihex"                                      |
|                                                                      |
|xxx Kbytes transferred at xx CPSR..ER....ER......................Epll |
|config ok                                                             |
|205.9 Kbytes transferred at 5141 CPS... Done.                         |
|                                                                      |
| READY: press any key to continue...                                  |
+----------------------------------------------------------------------+
```
The uploading typically finishes in ~30s.
Make sure you see the `READY: press any key to continue...`, then press any key.
```
Welcome to minicom 2.8

OPTIONS: I18n
Port /dev/serial/by-id/usb-FTDI_Quad_RS232-HS-if02-port0

Press CTRL-A Z for help on special keys
                 
.E
```
Notice the `.E` at the end. The `E` indicates the end of a bootchain component read (not error).
At this point, secondary boot and DDR init are all done, and the 64-bit MCPU has been kicked and
it's spinning at the first `c.j $pc` instruction. It's now ready for us to upload the bootloader (opensbi+u-boot)

#### JTAG upload
If you just want to upload the bootloader `fw_payload.elf` and let it run, just open a separate terminal, and
```
$ ./openocd-load.sh .../platform/generic/firmware/fw_payload.elf
Open On-Chip Debugger 0.12.0+dev-02088-gcbc32c383-dirty (2025-12-09-09:43)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : [riscv.cpu0] Hardware thread awareness created
Info : clock speed 5000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x00000913 (mfg: 0x489 (SiFive Inc), part: 0x0000, ver: 0x0)
...
Info : datacount=2 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Core 3 made part of halt group 1.
Info : Examined RISC-V core; found 4 harts
Info :  hart 3: XLEN=64, misa=0x80000000009411ad
Info : [riscv.cpu3] Examination succeed
Info : [riscv.cpu0] starting gdb server on 3333
Info : Listening on port 3333 for gdb connections
Info : Disabling abstract command writes to CSRs.
Info : Disabling abstract command writes to CSRs.
Info : Disabling abstract command writes to CSRs.
Info : Disabling abstract command writes to CSRs.
260880 bytes written at address 0x80000000
13744 bytes written at address 0x80040000
1902664 bytes written at address 0x80200000
downloaded 2177288 bytes in 14.378442s (147.878 KiB/s)
```
You should see on the `minicom` terminal the opensbi/u-boot prints. If not, then it very likely crashed on early boot.
Follow the next section for debugging.

#### JTAG gdb debugging
In separate terminal:
```
$ ./openocd-debug.sh .../platform/generic/firmware/fw_payload.elf
Open On-Chip Debugger 0.12.0+dev-02088-gcbc32c383-dirty (2025-12-09-09:43)
...
260880 bytes written at address 0x80000000
13744 bytes written at address 0x80040000
1902664 bytes written at address 0x80200000
downloaded 2177288 bytes in 14.334698s (148.329 KiB/s)
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
```
In another separate terminal:
```
$ riscv64-unknown-linux-gnu-gdb -ex 'target extended-remote :3333' .../platform/generic/firmware/fw_payload.elf
GNU gdb (GDB) 16.3.90.20250610-git
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "--host=x86_64-pc-linux-gnu --target=riscv64-unknown-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from platform/generic/firmware/fw_payload.elf...
Remote debugging using :3333
_start () at .../firmware/fw_base.S:50
50		MOV_3R	s0, a0, s1, a1, s2, a2
(gdb)
```
Now you can playaround with breakpoints, step/resume...
Note: It's better to use `hbreak` to set breakpoints in OpenSBI.

#### Backup: Automate booting (for scripting)
```
$ ./boot-uart.sh uart/bootchain.ihex
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
