BITS 64

segment .data
    prompt db 'Please input a string:', 0x0a
    prLen equ $ - prompt
    yourString db 'Your String:', 0x0a
    ySLen equ $ - yourString
    newline db 0x0a
    ySReversed db 'Your reversed string:', 0x0a
    ySRLen equ $ - ySReversed

segment .bss
    input: resb 64
    revString: resb 64

segment .text
    global _start

_start:
    ;write prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prLen
    syscall

    ;read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 64
    syscall
    mov r12, rax            ; save input length

    mov r13, r12
    dec r13

    ;write yourString
    mov rax, 1
    mov rdi, 1
    mov rsi, yourString
    mov rdx, ySLen
    syscall

    ;write input
    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, r13
    syscall

    ;write newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;write ySReversed
    mov rax, 1
    mov rdi, 1
    mov rsi, ySReversed
    mov rdx, ySRLen
    syscall

    cmp r13, 0
    je final_print

pointers:
    mov rsi, input
    add rsi, r13
    dec rsi                 ; rsi -> last char of source
    mov rdi, revString      ; rdi -> first char of dest
    mov rcx, r13            ; rcx -> counter for loop

reverse_loop:
    mov al, [rsi]           ; load last char
    mov [rdi], al           ; copy to first dest char
    dec rsi                 ; move back 1 char in source
    inc rdi                 ; move ahead 1 char in dest
    dec rcx                 ; decrease counter
    jnz reverse_loop        ; loop until string is reversed

final_print:
    ;write revString
    mov rax, 1
    mov rdi, 1
    mov rsi, revString
    mov rdx, r13
    syscall

    ;exit syscall
    mov rax, 60
    mov rdi, 0
    syscall
