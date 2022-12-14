%include "io.mac"
global _start
section .text
    _start:
        pop ebx 
        pop ebx 

        open 
        mov [file_d_in_1], eax 
        read [file_d_in_1], file_data_1, 256 
        mov [file_data_1_size], eax
        open 
        mov [file_d_in_2], eax 
        read [file_d_in_2], file_data_2, 256 
        mov [file_data_2_size], eax

        mov eax, sys_creat 
        pop ebx 
        mov ecx, 420 
        int 0x80
        mov [file_d_out], eax 
        write [file_d_out], file_data_1, [file_data_1_size] 
        write [file_d_out], file_data_2, [file_data_2_size] 

    end: 
        write std_out, success_message, success_message_len 
        close [file_d_in_1] 
        close [file_d_in_2] 
        close [file_d_out] 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 


section .bss
    file_d_in_1 resb 256 
    file_data_1 resb 256 
    file_d_in_2 resb 256 
    file_data_2 resb 256
    file_d_out resb 256 
    file_data_1_size resb 256
    file_data_2_size resb 256

section .data
    sys_creat equ 8
    sys_close equ 6
    sys_open equ 5
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    letter_len equ 4
    sys_exit equ 1
    exit_status equ 0
    success_message: db "The new file was successfully created.", 0xa
    success_message_len equ $ - success_message