ASM = nasm
CC = gcc

CFLAGS = -m16 -ffreestanding -fno-pie -fno-stack-protector -Wall -Wextra -Ikernel/inc
LDFLAGS = -m16 -nostdlib -static -T linker.ld -Wl,--oformat=binary

BOOT = boot/main.asm
KERNEL_SOURCES = $(wildcard kernel/src/*.c)

BOOT_BIN = bin/boot.bin
KERNEL_OBJECTS = $(KERNEL_SOURCES:kernel/src/%.c=bin/%.o)
KERNEL_BIN = bin/kernel.bin
OS_IMAGE = bin/os.img

all: $(OS_IMAGE)

$(BOOT_BIN): $(BOOT)
	mkdir -p bin
	$(ASM) -f bin $(BOOT) -o $(BOOT_BIN)

bin/%.o: kernel/src/%.c
	mkdir -p bin
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJECTS)
	$(CC) $(LDFLAGS) $(KERNEL_OBJECTS) -o $(KERNEL_BIN)

$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(OS_IMAGE)

run: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE)

clean:
	rm -rf bin