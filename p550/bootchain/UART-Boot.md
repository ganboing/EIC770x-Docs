## HiFive P550 UART Boot Guide

Some background regarding P550 bootflow. For P550, it's a 1 DIE configuration (EIC7702 is 2 DIE).
Thus, the stock stable bootchain (w/o secure boot) comes only with 3 parts:

- Secondary Boot: A tiny blob right after firmware to do basic initialization, such as PLL clock. "FIRMWARE"
- DDR Init: Blob for initializing DDR memory. ~200KB. "DDR"
- U-Boot/OpenSBI payload: The actual bootloader. "BOOTLOADER"

These parts are packaged in a container image (bootchain) with ESWIN custom format that's similar to tar/cpio.
The program `nsign` is used to generate such container image. For each component in the image, there's
also metadata to describe its type FIRMWARE/DDR/BOOTLOADER, the load and entry point address, and the
CPU (SCPU or MCPU) that's responsible for running it. In regular boot configuration, such image is
flashed to boot SPI, and DIP switches are set to `[0 0 1 0]`. After power-on, the SCPU (32bit) starts
executing Masked ROM, where there's logic to check DIP switch states and parse, then load the blobs
from the bootchain. 

For bootloader developers, it might be helpful to a. replace the "BOOTLOADER" at will, and b. start JTAG
debugging as early as possible. EIC7700(X)/P550 has the ability to boot from UART. In UART boot mode, the
bootchain image is read from UART, bypassing boot SPI. Hence, there's zero possibility of bricking the device.
UART boot mode requires a slightly modified version of `nsign` configuration, which is provided here
[config.txt](https://github.com/ganboing/EIC770x-Docs/blob/main/p550/bootchain/uart/config.txt) I also did a
trick to use a dummy bootload payload which spins the MCPU such that you can JTAG debug from the very first
instruction. 
