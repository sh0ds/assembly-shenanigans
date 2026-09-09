section .data
    string db 'Hello, World!'
    strLen equ $ - string

section .bss
    revString: resb strLen

section .text
    global _start

_start:
    mov rsi, string
    add rsi, strLen - 1     ; rsi -> last char of source
    mov rdi, revString      ; rdi -> first char of dest
    mov rcx, strLen         ; rcx -> counter for loop

reverse_loop:
    mov al, [rsi]           ; load last char
    mov [rdi], al           ; copy to first dest char
    dec rsi                 ; move back 1 char in source
    inc rdi                 ; move ahead 1 char in dest
    dec rcx                 ; decrease counter
    jnz reverse_loop        ; loop until string is reversed

    ;write syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, revString
    mov rdx, strLen
    syscall

    ;exit syscall
    mov rax, 60
    mov rdi, 0
    syscall