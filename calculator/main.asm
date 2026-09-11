BITS 64
DEFAULT REL

segment .data

    inputMsg1 db "Enter first number:", 0x0a
    lenInputMsg1 equ $ - inputMsg1
    inputMsg2 db "Enter second number:", 0x0a
    lenInputMsg2 equ $ - inputMsg2
    outputMsg db "Result:", 0x0a
    lenOutputMsg equ $ - outputMsg
    errorMsg db "Invalid Input, try again:", 0x0a
    lenErrorMsg equ $ - errorMsg

    msgAdd db "Enter '+' for addition", 0x0a
    lenMsgAdd equ $ - msgAdd
    msgSub db "Enter '-' for subtraction", 0x0a
    lenMsgSub equ $ - msgSub
    msgMul db "Enter '*' for multiplication", 0x0a
    lenMsgMul equ $ - msgMul
    msgDiv db "Enter '/' for division", 0x0a
    lenMsgDiv equ $ - msgDiv
    choiceMsg db "Choice:", 0x0a
    lenChoiceMsg equ $ - choiceMsg
    errChoice db "Invalid choice, try again:", 0x0a
    lenErrChoice equ $ - errChoice

segment .bss
    num1: resd 1
    num2: resd 1
    choice: resb 1


segment .text
global _start

_start:

choice_selection:
    mov rax, 1
    mov rdi, 1
    mov rsi, msgAdd
    mov rdx, lenMsgAdd
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msgSub
    mov rdx, lenMsgSub
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msgMul
    mov rdx, lenMsgMul
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msgDiv
    mov rdx, lenMsgDiv
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, choiceMsg
    mov rdx, lenChoiceMsg
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, choice
    mov rdx, 1
    syscall

    cmp byte [choice], '+'
    je do_add
    cmp byte [choice], '-'
    je do_sub
    cmp byte [choice], '*'
    je do_mul
    cmp byte [choice], '/'
    je do_div

    ; invalid choice — show error and loop back
    mov rax, 1
    mov rdi, 1
    mov rsi, errChoice
    mov rdx, lenErrChoice
    syscall
    jmp choice_selection

do_add:
    ; TODO: read num1, num2, add them
    jmp exit

do_sub:
    ; TODO: read num1, num2, subtract them
    jmp exit

do_mul:
    ; TODO: read num1, num2, multiply them
    jmp exit

do_div:
    ; TODO: read num1, num2, divide them
    jmp exit ; for now, loop later


exit:
    mov rax, 60
    mov rdi, 0
    syscall
