%include "io.mac"
global _start
section .text
    _start:
        pop ebx 
        pop ebx 

        open 2, 420
        mov [file_d], eax 
        read [file_d], file_data, 256 
        mov [file_size], eax 

        mov esi, file_data 
        mov edi, file_data 
        mov ecx, [file_size]
        inc ecx 

    growing_symbols:
        push ecx 
        lodsb 
        
        cmp al, 0x61 
        jl skip_symbol 

        cmp al, 0x7A 
        jg skip_symbol 

        sub al, 0x20 

    skip_symbol:  
        stosb 
        pop ecx
        loop growing_symbols 

    end: 
        mov eax, sys_lseek 
        mov ebx, [file_d] 
        mov ecx, 0 
        mov edx, seek_set 
        int 0x80 

        write std_out, success_message, success_message_len 
        write [file_d], file_data, file_size
        close [file_d] 

        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 



section .bss
    file_d resb 256 
    file_data resb 256 
    file_size resb 256 

section .data
    sys_lseek equ 19
    sys_creat equ 8
    sys_close equ 6
    sys_open equ 5
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    letter_len equ 4
    sys_exit equ 1
    seek_set equ 0
    exit_status equ 0
    success_message: db "The file was successfully overwritten.", 0xa
    success_message_len equ $ - success_message