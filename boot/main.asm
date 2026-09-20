[org 0x7c00]
bits 16

_start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; set up a safe stack area below the bootloader
    mov ss, ax
    mov sp, 0x7c00

    ; Save the boot drive
    mov [boot_drive], dl

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]

    ; load main function
    mov bx, 0x1000

    int 0x13
    jc disk_error

    ; go to main
    jmp 0x0000:0x1000

disk_error:
    hlt
    jmp disk_error

boot_drive db 0

; add padding to make bin file 512 bytes wide
times 510 - ($ - $$) db 0
dw 0xaa55