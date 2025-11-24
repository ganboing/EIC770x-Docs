.PHONY: clean all boot-uart

CROSS_COMPILE ?= /opt/toolchain/riscv64imafdc-linux-lp64d/bin/riscv64-unknown-linux-gnu-
TARGET_CC ?= $(CROSS_COMPILE)gcc
TARGET_AS ?= $(CROSS_COMPILE)as
TARGET_LD ?= $(CROSS_COMPILE)ld
TARGET_OBJCOPY ?= $(CROSS_COMPILE)objcopy

all: uart/bootchain.ihex

boot-uart: uart/bootchain.ihex
	./boot-uart.sh $<

uart/bootchain.ihex: spin-mcpu.bin
	command -v nsign || ( echo "nsign not found. Refer to README.md and ensure nsign is in PATH" >&2 ; exit 1 ; )
	cd uart && nsign

spin-mcpu.bin: spin-mcpu.elf
	$(TARGET_OBJCOPY) -O binary $< $@

spin-mcpu.elf: spin-mcpu.o
	$(TARGET_LD) --oformat elf64-littleriscv -o $@ $<

spin-mcpu.o: spin-mcpu.s
	$(TARGET_AS) --march=rv64gc -o $@ $<

spin-scpu.bin: spin-scpu.elf
	$(TARGET_OBJCOPY) -O binary $< $@

spin-scpu.elf: spin-scpu.o
	$(TARGET_LD) --oformat elf32-littleriscv -o $@ $<

spin-scpu.o: spin-scpu.s
	$(TARGET_AS) --march=rv32g -o $@ $<

clean:
	rm -f spin-mcpu.o spin-mcpu.elf spin-mcpu.bin
	rm -f spin-scpu.o spin-scpu.elf spin-scpu.bin
	rm -rf uart/out uart/bootchain.ihex

git-refresh:
	git submodule update --init sifive-release
