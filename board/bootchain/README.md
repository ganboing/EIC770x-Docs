## How EIC7700 boots

Some background regarding EIC7700 bootflow. It's a 1 DIE configuration, compared to EIC7702 (2 DIE).
Thus, the stock stable bootchain (w/o secure boot) comes only with 3 parts, without the die-2-die firmware (D2D/PMIX):

- Secondary Boot aka. "FIRMWARE": A tiny blob executed right after masked ROM to do basic initialization, such as PLL clock.
- DDR Init aka. "DDR": Blob for initializing DDR memory. Ver. 1.3 is the smallest blob with size ~270KB.
- U-Boot/OpenSBI payload aka. "BOOTLOADER": The actual bootloader.

These parts are packaged in a container image (bootchain) with ESWIN custom format that's similar to tar/cpio.
The program `nsign` is used to generate such container image. For each component in the image, there's
also metadata to describe its type FIRMWARE/DDR/BOOTLOADER, the load and entry point address, and the
CPU (SCPU or MCPU) that's responsible for running it. Masked ROM code has all the parsing functions burned
to the chip. In regular (production) boot configuration, such bootchain image is flashed to boot SPI, and
DIP switches are set to `[0 0 1 0]` (SCPU starts first, and boot from SPI w/o secure boot).

In detail: after power-on, the SCPU (32bit) starts executing Masked ROM, mainly for doing basic platform
initialization, security checking. Then it loads FIRMWARE, and does DDR training. Lastly it hands off to the
main processor, MCPU. Specifically, SCPU loads and executes FIRMWARE/DDR in SRAM, and after DDR is fully trained,
loads BOOTLOADER to DDR and handoff to MCPU.

### Building
The most stable "BOOTLOADER" so far is the OpenSBI+U-Boot combination. It's technically incorrect to use the term
BOOTLOADER here, as OpenSBI is arguably the most important piece of code that provide M mode SBI at runtime, THE
*firmware* essentiall, but we keep using ESWIN's terms here.

#### Getting the sources
* For OpenSBI, I've already added full support to upstream. Pick the most stable version
* For U-Boot, unfortunately we have to stay with the messy vendor u-boot based on v2024.01. Some fixes must be applied
on top of it to make it work for upstream OpenSBI, and other OSes that consumes the U-Boot device-tree directly.

Use [eic7x-dt-fix-hfp](https://github.com/ganboing/u-boot-eic7x/tree/eic7x-dt-fix-hfp) branch for Hifive Premier P550

Use [eic7x-dt-fix-megrez](https://github.com/ganboing/u-boot-eic7x/tree/eic7x-dt-fix-megrez) branch for Megrez

#### Build U-Boot and OpenSBI
Build U-Boot first
```shell
# cd to u-boot directory
# For Hifive Premier P550
make hifive_premier_p550_defconfig all
# For Megrez
make eic7700_milkv_megrez_defconfig all
```

Build OpenSBI, which will have u-boot embedded
```shell
# cd to opensbi directory
make \
  PLATFORM=generic \
  PLATFORM_RISCV_ABI=lp64 \
  PLATFORM_RISCV_ISA=rv64imafdch_zicsr_zifencei \
  FW_TEXT_START=0x80000000 \
  FW_PAYLOAD_OFFSET=0x200000 \
  FW_PAYLOAD_FDT_ADDR=0xf8000000 \
  FW_PAYLOAD_PATH=<path to u-boot-nodtb.bin> \
  FW_FDT_PATH=<path to u-boot.dtb>
```

The final `fw_payload.bin` in `platform/generic/firmware/fw_payload.bin` is the "BOOTLOADER" we want

### Flashing

If you are confident that your BOOTLOADER works, you can flash it by first packaging it in the "bootchain"
format using nsign:

#### Build nsign
```shell
# In some out-of-tree directory
$ git clone https://github.com/eswincomputing/Esbd-77serial-nsign.git
$ mkdir -p build
$ cd build && cmake ../ && cmake --build .
```

#### Create bootchain
Modify the `developer/config.txt` and replace `<your bootloader>` with the actual path to `fw_payload.bin`
```shell
$ cd developer
$ PATH="<path-to-nsign>/build/src:$PATH" nsign
```

After you've got the bootchain image ready, refer to https://www.sifive.com/document-file/hifive-premier-p550-image-update-procedure
on how to flash it.

### Hacking

For bootloader developers, it might be helpful to
* Replace the "BOOTLOADER" on the fly
* Recover from a "bricked" state easily
* Start JTAG debugging at the first instruction

Check out these 2 methods I prepared for you:
* [UART boot](./UART-Boot.md) (Great for casual testing and resue a bricked device)
* [JTAG-ready image](./JTAG-Ready.md) (Great for heavy testing/debugging and CI)