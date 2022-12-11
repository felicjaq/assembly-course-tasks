%include "io.mac"

global _start
section .text

    %macro push_letter 1 
        movzx ax, byte[string+%1] 
        push ax 
    %endmacro

    %macro replace_letter 1 
        pop ax 
        mov [tmp], ax 
        lea ebx, [string] 
        mov al, [tmp] 
        mov byte[ebx+%1], al 
    %endmacro

    _start:
        write welcome_message, welcome_message_len 
        read string, max_string_len 
        push_letter 0 
        push_letter 3 
        push_letter 2 
        push_letter 7 

        replace_letter 2 
        replace_letter 7 
        replace_letter 0 
        replace_letter 3 

        write result_message, result_message_len 
        write string, max_string_len 

    end: 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 

section .bss 
    string resb 20
    tmp resb 4

section .data
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    number_size equ 2
    sys_exit equ 1
    exit_status equ 0
    max_string_len equ 20
    welcome_message: db "Please enter a line: ", 0
    welcome_message_len equ $ - welcome_message
    result_message: db "Modified line: ", 0
    result_message_len equ $ - result_message