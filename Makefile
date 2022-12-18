CFLAGS     = -Wall -Wextra -Wno-uninitialized -fdiagnostics-color=always -fno-pic -ffreestanding -fstack-protector-all -nostdlib -g -Iinclude -std=gnu2x -mcmodel=kernel $(FEATURES)
LDFLAGS    = -fdiagnostics-color=always -nostdlib -T linkerScript.ld -static
SHELL=/bin/bash

override compile_S   := $(shell find src -type f -name '*.S' | sort)
override compile_c   := $(shell find src -type f -name '*.c')
compile=$(subst src/,build/,$(subst ./,,$(subst .c,.o,$(subst .S,.o,$(compile_S) $(compile_c)))))
vpath %.S src/sect1/16/
vpath %.S src/sect2/16/
.SUFFIXES: .o .c .S

all: bin/tfboot.bin
bin/tfboot.bin: build/tfboot.bin
	@echo "DISK  build/tfboot.bin => bin/tfboot.bin"
	$(shell dd if=/dev/zero of=bin/tfboot.bin bs=256 count=2)
	$(shell printf "\x55\xAA" > temp)
	$(shell dd if=temp of=bin/tfboot.bin bs=1 count=2 seek=510)
	$(shell dd if=/dev/zero of=bin/tfboot.bin bs=1 count=512 seek=1024)
	$(shell rm temp)
	$(shell cat < build/tfboot.bin 1<> bin/tfboot.bin)

build/tfboot.bin: $(compile)
	@echo "CCLD  $(subst build/,,$(compile)) => build/tfboot.bin"
	$(shell x86_64-elf-gcc $(LDFLAGS) $(compile) -o build/tfboot.bin  2> >(util/rederr.sh >&2);exit $$?)
	

build/sect1/16/%.o: %.c $(shell find . -type f -name '*.h')
	@mkdir -p $(@D)
	@echo "CC    $< => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -Werror=stack-usage=145 -c $< -o $@

build/sect1/16/%.o: %.S
	@mkdir -p $(@D)
	@echo "AS    $< => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -c $< -o $@

build/sect2/16/%.o: %.c $(shell find . -type f -name '*.h')
	@mkdir -p $(@D)
	@echo "CC    $< => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -Werror=stack-usage=145 -c $< -o $@

build/sect2/16/%.o: %.S
	@mkdir -p $(@D)
	@echo "AS    $< => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -c $< -o $@


clean:
	@rm -f $(compile) bin/* || true

softclean:
	@rm -f $(compile) || true