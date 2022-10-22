CFLAGS     = -Wall -Wextra -Wno-uninitialized -fdiagnostics-color=always -fno-pic -ffreestanding -fstack-protector-all -nostdlib -g -Iinclude -std=gnu2x -mcmodel=kernel $(FEATURES)
LDFLAGS    = -fdiagnostics-color=always -nostdlib -lgcc -T linkerScript.ld -static
SHELL=/bin/bash

compile =\
src/16/main.o \
src/16/realModePrintStr.o

link =\
build/16/main.o \
build/16/realModePrintStr.o

.SUFFIXES: .o .c .S

all: dirs $(compile)
	@echo "CCLD  $(subst build/,,$(link)) => bin/tfboot.bin"
	$(shell x86_64-elf-gcc $(LDFLAGS) $(link) -o bin/tfboot.bin  2> >(util/rederr.sh >&2);exit $$?)
	

dirs:
	@$(shell mkdir -p bin build&&cd build&&mkdir -p 16)

.c.o:
	@echo "CC    $(subst .o,.c,$@) => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -Werror=stack-usage=145 -c $(subst .o,.c,$@) -o build/$@

.S.o:
	@echo "AS    $(subst .o,.S,$@) => $@"
	@x86_64-elf-gcc $(CFLAGS) -mno-red-zone -c $(subst .o,.S,$@) -o build/$(subst src/,,$@)
clean:
	@rm -f $(link) bin/* || true

softclean:
	@rm -f $(link) || true