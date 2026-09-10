segment .data
	cap db 'capitalize this!'
	capLen equ $ - cap
	
segment .bss
	dest: resb capLen
	
segment .text
global _start
	
_start:
	;lower 97 - 122 dec, 61 - 7A hex
    ;upper 65 - 90 dec, 41 - 5A hex

    mov rsi, cap        ;1. char src
    mov rdi, dest       ;1. char dst
    mov rcx, capLen     ;counter

cap_loop:
    mov al, [rsi]

    ;check if lowercase
    cmp al, 97          
    jl copy_char
    cmp al, 122
    jg copy_char 

    ;convert to upper if lower
    sub al, 32

copy_char:
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jnz cap_loop

final_print:
    mov rax, 1
    mov rdi, 1
    mov rsi, dest
    mov rdx, capLen
    syscall

    mov rax, 60
    mov rdi, 0
    syscall