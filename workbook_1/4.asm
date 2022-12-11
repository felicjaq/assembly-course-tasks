%include "io.mac"

global _start
section .text

    _start: 
        write welcome_first_message, welcome_first_message_len 
        read first_number, number_size
        write welcome_second_message, welcome_second_message_len 
        read second_number, number_size 
        call division 
        write result_message, result_message_len 
        write result, number_size 
        write new_line, 1 
        write remnant_message, remnant_message_len 
        write remnant, number_size 
        write new_line, 1 
        jmp end 

    division:
        mov al, [first_number] 
        sub al, '0' 
        mov bl, [second_number] 
        sub bl, '0' 
        div bl 
        add al, '0' 
        add ah, '0'
        mov [result], al 
        mov [remnant], ah 
        ret 

    end: 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 

section .bss
    first_number resb 4 
    second_number resb 4 
    result resb 4 
    remnant resb 4 

section .data
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    number_size equ 2
    sys_exit equ 1
    exit_status equ 0
    welcome_first_message: db "Please enter a first number: ", 0
    welcome_first_message_len equ $ - welcome_first_message
    welcome_second_message: db "Please enter a second number: ", 0
    welcome_second_message_len equ $ - welcome_second_message
    result_message: db "The result: ", 0
    result_message_len equ $ - result_message
    remnant_message: db "The remainder: ", 0
    remnant_message_len equ $ - remnant_message
    new_line: db 0xa