%include "io.mac"

section .data
    SYS_SEEK equ 19
    SYS_CLOSE equ 6
    SYS_OPEN equ 5
    SYS_WRITE equ 4
    SYS_READ equ 3
    STD_ERR equ 2
    STD_OUT equ 1
    STD_IN equ 0
    SYS_EXIT equ 1
    EXIT_STATUS equ 0
    NEW_LINE db 0xa
    X_MESSAGE: db "Enter the first number, please.: ", 0
    X_MESSAGE_LEN: equ $ - X_MESSAGE
    Y_MESSAGE: db "Enter the second number, please.: ", 0
    Y_MESSAGE_LEN: equ $ - Y_MESSAGE
    RESULT_MESSAGE: db "Sum of numbers: ", 0
    RESULT_MESSAGE_LEN: equ $ - RESULT_MESSAGE

section .bss
	X resb 4
	Y resb 4
	X_LEN resb 4
	Y_LEN resb 4
	RESULT resb 4

global _start
section .text
    _start:
        write STD_OUT, X_MESSAGE, X_MESSAGE_LEN
        read STD_IN, X, 4
        mov [X_LEN], eax
        
        write STD_OUT, Y_MESSAGE, Y_MESSAGE_LEN
        read STD_IN, Y, 4
        mov [Y_LEN], eax
        
        mov al, [X_LEN]
        cmp al, 3
        je convert_x

        mov al, [X]
        and al, 0x0f	
        mov [X], al
        jmp second_digit

    convert_x:
        mov ax, [X]
        xchg al, ah
        and ax, 0x0f0f
        shl ah, 4
        xor ah, al
        mov [X], ah
        
    second_digit:
        mov al, [Y_LEN]
        cmp al, 3
        je convert_y

        mov al, [Y]
        and al, 0x0f
        mov [Y], al
        jmp get_sum

    convert_y:
        mov ax, [Y]
        xchg al, ah
        and ax, 0x0f0f
        shl ah, 4
        xor ah, al
        mov [Y], ah

    get_sum:
        call addition
        write STD_OUT, RESULT_MESSAGE, RESULT_MESSAGE_LEN
        write STD_OUT, RESULT, 4
        write STD_OUT, NEW_LINE, 1

    end: 
        mov eax, SYS_EXIT 
        mov ebx, EXIT_STATUS 
        int 0x80	

    addition:
        mov al, [X]
        mov bl, [Y]
        add al, bl
        daa
        jc convert_res
        mov ah, al
        and al, 0x0f
        shr ah, 4
        xchg al, ah
            
        cmp al, 0
        je one_digit
        add ax, 0x3030
        mov [RESULT], ax
        jmp addition_return

    one_digit:
        add ah, 0x30
        mov [RESULT], ax
        jmp addition_return

    convert_res:
        mov ah, al
        and al, 0x0f
        shr ah, 4
        xchg al, ah

        add ax, 0x3030
        shl eax, 8
        mov al, 0x31
        mov [RESULT], eax

    addition_return:
        ret