%include "io.mac"

global _start
section .text

    _start: 
        write welcome_first_message, welcome_first_message_len
        read first_number, number_size 
        write welcome_second_message, welcome_second_message_len 
        read second_number, number_size 
        jmp addition 
    ress:
        write result_message, result_message_len 
        write req, number_size 
        write res, number_size 
        write new_line, 1
        jmp end 

    addition:
        mov al, [first_number]
        sub al, '0' 
        mov bl, [second_number] 
        sub bl, '0' 
        mul bl 
        cmp eax, 10 
        jl last_digit 

        mov bl, 10 
        div bl 

        mov [tmp], ah 
        add al, '0' 
        mov [req], al 

        mov al, [tmp] 
        
    last_digit:   
        add al, '0'  
        mov [res], al 
        jmp ress 

    end: 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 

section .bss
    first_number resb 4 
    second_number resb 4 
    res resb 4 
    tmp resb 4
    req resb 4 

section .data
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    number_size equ 4
    sys_exit equ 1
    exit_status equ 0
    welcome_first_message: db "Please enter a first number: ", 0
    welcome_first_message_len equ $ - welcome_first_message
    welcome_second_message: db "Please enter a second number: ", 0
    welcome_second_message_len equ $ - welcome_second_message
    result_message: db "The product of numbers: ", 0
    result_message_len equ $ - result_message
    new_line: db 0xa