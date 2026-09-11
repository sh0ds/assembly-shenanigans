
segment .data
PAY_PER_DELIVERY equ 12
HOURLY_BONUS equ 340
LATE_PENALTY equ 45
PAYOUT db 'Your payout:', 0x0a
PAYOUTLEN equ $ - PAYOUT

segment .bss
revASCII: resb 21       ; reserve for itoa (64-bit unsigned integer = 20 decimal digits + newline -> 21 bytes)
ASCII: resb 21

segment .text
global _start

_start:

mov rdi, 4200		    ; fuel_cost
mov esi, 812043		    ; deliveries
mov edx, 41			    ; hours_on_road
mov ecx, 17			    ; late_deliveries
mov r8b, 6			    ; co_drivers
 
call delivery_payout

mov rdi, rax

call itoa
mov r9, rax             ; save string length

; write syscall
mov rax, 1
mov rdi, 1
mov rsi, PAYOUT
mov rdx, PAYOUTLEN
syscall

; write syscall
mov rax, 1
mov rdi, 1
mov rsi, ASCII
mov rdx, r9
syscall

; exit syscall
mov rax, 60
mov rdi, 0
syscall

delivery_payout:
; final_payout = (deliveries * PAY_PER_DELIVERY) + (hours_on_road * HOURLY_BONUS)
;				 - fuel_cost - (late_deliveries * LATE_PENALTY)

; then final_payout is split evenly among (co_drivers + 1) people,
; and any remainder from that split is added as a tip on top of 
; the calling driver's share (they get quotient + remainder)
   
    movsxd rsi, esi             ; sign-extend to 64-bit
    imul rsi, PAY_PER_DELIVERY  ; rsi = 9.744.516

    movsxd rdx, edx             ; sign-extend to 64-bit
    imul rdx, HOURLY_BONUS      ; rdx = 13.940

    add rsi, rdx                ; rsi = 9.758.456
    
    ;sign-extension to 64-bit before multiplying prevents overflow

    sub rsi, rdi                ; rsi = 9.754.256
     
    movsxd rcx, ecx             ; sign-extend to 64-bit
    imul rcx, LATE_PENALTY      ; rcx = 765

    sub rsi, rcx                ; rsi = 9.753.491

    movzx rax, r8b              ; zero-extend codrivers into rax
    inc rax                     ; codrivers + 1
    mov rcx, rax                ; rcx = 7

    mov rax, rsi                ; rax = 9.753.491
    cqo                         ; rdx = 0
    idiv rcx                    ; rdx:rax / rcx
                                ; rdx = 6, rax = 1.393.355
    add rax, rdx                ; rax = 1.393.361
    ret
    
itoa:
    ;converting integer to ascii to print the final payout on screen

    mov rbx, 0                  ; counter

    .start:
    xor rdx, rdx                ; clear rdx for division
    mov rax, rdi                ; mov input to rax
    mov rcx, 10                 ; rcx -> divisor (10)
    div rcx                     ; rdx:rax / rcx (rax = int / 10, rdx = int % 10)
    mov rdi, rax                ; mov rax (number - last char) to rdi
    add rdx, '0'                ; add ascii 0 (48)
    mov [revASCII + rbx], dl    ; mov ascii char to string
    inc rbx                     ; increase counter
    cmp rax, 0                  ; is quotient 0?
    jne itoa.start
    ;fallthrough
    mov r8, rbx                 ; r8 -> digit count
    dec rbx                     ; rbx -> last char of source
    mov rdi, ASCII              ; rdi -> first char of dest
    mov rcx, r8                 ; rcx -> counter for loop

    .reversal:
    mov al, [revASCII + rbx]    ; load last char
    mov [rdi], al               ; copy to first dest char
    dec rbx                     ; move back 1 char in source
    inc rdi                     ; move ahead 1 char in dest
    dec rcx                     ; decrease counter
    jnz itoa.reversal           ; loop until string is reversed
    ;fallthrough                
    mov byte [rdi], 0x0a        ; add newline at the end
    inc rdi                     ; rdi -> 1 char after end
    mov rax, rdi                
    sub rax, ASCII              ; first char - 1 char after end = length
    ret                         ; returns string length