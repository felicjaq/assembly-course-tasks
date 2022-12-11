%include "io.mac"

global _start
section .text

    _start: 
        write welcome, welcome_len 
        read letter, letter_len 
        write input, input_len 
        write letter, letter_len 

    check_for_z_and_Z: 
        mov al,[letter] 
        cmp al, 0x7a 
        je print_letter 
        cmp al, 0x5a 
        je print_letter 

    incr: 
        mov eax, [letter] 
        inc eax 
        mov [letter], eax 

    print_letter: 
        write output, output_len 
        write letter, letter_len 

    end:
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80

section .bss
    letter resb 4 

section .data
    sys_write equ 4
    sys_read equ 3
    std_out equ 1
    std_in equ 0
    letter_len equ 4
    sys_exit equ 1
    exit_status equ 0
    welcome: db "Please enter a letter: ", 0
    welcome_len equ $ - welcome
    input: db "Your letter: ", 0
    input_len equ $ - input
    output: db "Modified letter: ", 0
    output_len equ $ - output