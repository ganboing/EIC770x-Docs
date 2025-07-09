# EIC770x Documentation Collection

## JTAG on Hifive Premier P550:
- JTAG_MCU: MCU (STM32)
- JTAG0: MCPU (4x P550 cluster) + LPCPU (1x E21) + NPU (10x E21)
- JTAG1: SCPU (1x E21)
- JTAG2: DSP (4x Tensilica Vision Q7?)

## JTAG connections on Hifive Premier P550:
- JTAG_MCU: FT4232 Channel B
- JTAG0: FT4232 Channel A
- JTAG1: GPIO 40pin
- JTAG2: GPIO 40pin

## External Connection of JTAG1/2
![FT2232 connection](./ft2232-jtag.png)
- Above is the diagram connecting [FT2232H Mini Module](https://ftdichip.com/wp-content/uploads/2020/07/DS_FT2232H_Mini_Module.pdf)
- Ensure VCC <-> VBUS is bridged
- Ensure VCC3V3 <-> VIO is bridged
- JTAG1 has no reset pin
- JTAG2 has TRST

# OpenOCD configuration

## JTAG0:
```
# JTAG adapter setup
adapter speed 5000

#gdb_port 3333
#tcl_port 6666
#telnet_port 4444

adapter driver ftdi
ftdi vid_pid 0x0403 0x6011
ftdi channel 0

ftdi layout_init 0x0008 0x000b

reset_config none
transport select jtag

set chain_length 5
set _CHIPNAME riscv
jtag newtap $_CHIPNAME cpu -irlen $chain_length

set _TARGETNAME_0 $_CHIPNAME.cpu0
set _TARGETNAME_1 $_CHIPNAME.cpu1
set _TARGETNAME_2 $_CHIPNAME.cpu2
set _TARGETNAME_3 $_CHIPNAME.cpu3

target create $_TARGETNAME_0 riscv -chain-position $_CHIPNAME.cpu -coreid 0
target create $_TARGETNAME_1 riscv -chain-position $_CHIPNAME.cpu -coreid 1
target create $_TARGETNAME_2 riscv -chain-position $_CHIPNAME.cpu -coreid 2
target create $_TARGETNAME_3 riscv -chain-position $_CHIPNAME.cpu -coreid 3
target smp $_TARGETNAME_0 $_TARGETNAME_1 $_TARGETNAME_2 $_TARGETNAME_3

init
```
## JTAG0 OpenOCD Sample output
```
Open On-Chip Debugger 0.12.0-dirty (2024-08-21-02:49)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : clock speed 5000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x00000913 (mfg: 0x489 (SiFive Inc), part: 0x0000, ver: 0x0)
Info : datacount=2 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Core 0 made part of halt group 1.
Info : Examined RISC-V core; found 4 harts
Info :  hart 0: XLEN=64, misa=0x80000000009411ad
Info : datacount=2 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Core 1 made part of halt group 1.
Info : Examined RISC-V core; found 4 harts
Info :  hart 1: XLEN=64, misa=0x80000000009411ad
Info : datacount=2 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Core 2 made part of halt group 1.
Info : Examined RISC-V core; found 4 harts
Info :  hart 2: XLEN=64, misa=0x80000000009411ad
Info : datacount=2 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Core 3 made part of halt group 1.
Info : Examined RISC-V core; found 4 harts
Info :  hart 3: XLEN=64, misa=0x80000000009411ad
Info : starting gdb server for riscv.cpu0 on 3333
Info : Listening on port 3333 for gdb connections
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
```
## JTAG1:
```
adapter speed 5000
adapter driver ftdi

ftdi vid_pid 0x0403 0x6010
ftdi channel 1
ftdi layout_init 0x0008 0x000b

reset_config none
transport select jtag

set chain_length 5
set _CHIPNAME riscv
jtag newtap $_CHIPNAME cpu -irlen $chain_length -expected-id 0x00002913

set _TARGETNAME $_CHIPNAME.cpu

target create $_TARGETNAME riscv -chain-position $_CHIPNAME.cpu

init
```
## JTAG1 OpenOCD Sample output
```
Open On-Chip Debugger 0.12.0-dirty (2024-08-21-02:49)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : clock speed 5000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x00002913 (mfg: 0x489 (SiFive Inc), part: 0x0002, ver: 0x0)
Info : datacount=1 progbufsize=16
Info : Disabling abstract command reads from CSRs.
Info : Examined RISC-V core; found 1 harts
Info :  hart 0: XLEN=32, misa=0x40901105
Info : starting gdb server for riscv.cpu on 3333
Info : Listening on port 3333 for gdb connections
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
```
## JTAG2:
```
adapter speed 5000
adapter driver ftdi

ftdi vid_pid 0x0403 0x6010
ftdi channel 0
ftdi layout_init 0x0008 0x000b
ftdi layout_signal nTRST -data 0x10 -oe 0x10

reset_config trst_only
#reset_config none
transport select jtag

set chain_length 5
jtag newtap dsp3 cpu -irlen $chain_length -expected-id 0x20a73007
jtag newtap dsp2 cpu -irlen $chain_length -expected-id 0x20a73005
jtag newtap dsp1 cpu -irlen $chain_length -expected-id 0x20a73003
jtag newtap dsp0 cpu -irlen $chain_length -expected-id 0x20a73001

# Not sure how to create targets. They are possibly Tensilica Vision Q7

init
```
## JTAG2 OpenOCD Sample output
```
Open On-Chip Debugger 0.12.0-dirty (2024-08-21-02:49)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : clock speed 5000 kHz
Info : JTAG tap: dsp3.cpu tap/device found: 0x20a73007 (mfg: 0x003 (Fairchild), part: 0x0a73, ver: 0x2)
Info : JTAG tap: dsp2.cpu tap/device found: 0x20a73005 (mfg: 0x002 (AMI), part: 0x0a73, ver: 0x2)
Info : JTAG tap: dsp1.cpu tap/device found: 0x20a73003 (mfg: 0x001 (AMD), part: 0x0a73, ver: 0x2)
Info : JTAG tap: dsp0.cpu tap/device found: 0x20a73001 (mfg: 0x000 (<invalid>), part: 0x0a73, ver: 0x2)
Warn : gdb services need one or more targets defined
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
```
