%include "io.mac"
global _start
section .text
    _start: 
        pop ebx 
        pop ebx 
        pop ebx 

        mov eax, sys_open 
        xor ecx, ecx  
        int 0x80 
       
        mov [file_d], eax 
        read [file_d], hex_data, 256 

        mov [file_size], eax 

        mov esi, hex_data 
        write std_out, hex_message, hex_message_len 
        mov ecx, [file_size] 
        inc ecx 
        xor edx, edx 
        
    to_hex:
        cmp ecx, edx 
        jb end 
        lodsb 
        mov bl, 0x10
        div bl

        cmp al, 0x0a 
        jl first ; 
        add al, 0x07 

    first:
        add al, 0x30 
        mov [first_symbol], al

        cmp ah, 0x0a 
        jl second
        add ah, 0x07 

    second:
        add ah, 0x30 
        mov [second_symbol], ah 

        push ecx 
        write std_out, first_symbol, 1
        write std_out, second_symbol, 1
        write std_out, space, 1
        pop ecx 
        inc edx

        loop to_hex 

    end: 
        mov eax, sys_close 
        mov ebx, [file_d] 
        int 0x80 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 


section .bss
    hex_data resb 256 
    file_d resb 256 
    file_size resb 2 
    first_symbol resb 2  
    second_symbol resb 2  

section .data
    sys_close equ 6
    sys_open equ 5
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    letter_len equ 4
    sys_exit equ 1
    exit_status equ 0
    hex_message: db "The contents of the file are in HEX format: ", 0
    hex_message_len equ $ - hex_message
    space: db " ", 0