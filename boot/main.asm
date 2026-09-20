[org 0x7c00]
bits 16

_start:
    ; Reset segment registers to a known state (0x0000)
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    mov si, message

_print_loop:
    lodsb ; Load next byte from [SI] into AL and increment SI
    test al, al ; Check if character is the null terminator
    jz _halt
    
    mov ah, 0x0e ; BIOS teletype function
    int 0x10
    jmp _print_loop

_halt:
    jmp $

message: 
    db "Hey", 0

times 510 - ($ - $$) db 0 ; Padding to fit exactly 510 bytes
dw 0xaa55 ; Magic boot signiture 2 bytes