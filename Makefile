ASM = nasm
ASMFLAGS = -f bin

BOOT = boot/main.asm
OUTPUT = bin/os.bin

all: $(OUTPUT)

$(OUTPUT): $(BOOT)
	mkdir -p bin
	$(ASM) $(ASMFLAGS) $(BOOT) -o $(OUTPUT)

run: $(OUTPUT)
	qemu-system-i386 -drive format=raw,file=$(OUTPUT)

clean:
	rm -rf bin