%include "io.mac"

section .data
    SYS_CLOSE equ 6
    SYS_OPEN equ 5
    SYS_WRITE equ 4
    SYS_READ equ 3
    STD_ERR equ 2
    STD_OUT equ 1
    STD_IN equ 0
    SYS_EXIT equ 1
    EXIT_STATUS equ 0
    USAGE_PREFIX: db "Usage: ", 0
    USAGE_PREFIX_LEN: equ $ - USAGE_PREFIX
    USAGE_PROGRAMM: db "./3 ", 0
    USAGE_PROGRAMM_LEN: equ $ - USAGE_PROGRAMM
    USAGE_SUFFIX: db "<file_name>", 0xa
    USAGE_SUFFIX_LEN: equ $ - USAGE_SUFFIX
    ERROR_MESSAGE: db "Error...", 0xa
    ERROR_MESSAGE_LEN: equ $ - ERROR_MESSAGE
    SUCCESS_MESSAGE: db "File size: ", 0
    SUCCESS_MESSAGE_LEN equ $ - SUCCESS_MESSAGE
    SPACE: db " ", 0
    NEW_LINE: db 0xa

section .bss
    file_data resb 256 
    file_d resb 256 
    file_size resb 4 
    tmp resb 4 


global _start
section .text
    _start:
        pop ebx 
        cmp ebx, 2  
        jne usage 
        pop ebx 
        pop ebx 

        mov eax, SYS_OPEN 
        xor ecx, ecx   
        int 0x80 
       
        mov [file_d], eax 
        read [file_d], file_data, 256 
        mov [file_size], eax 

        write STD_OUT, SUCCESS_MESSAGE, SUCCESS_MESSAGE_LEN 
        
        movzx eax, byte[file_size] 
        xor ecx, ecx 

    to_decimal:
        cmp al, 0 
        je write_digits
        inc ecx 
        mov bl, 10 
        div bl 
        push eax
        xor ah, ah
        jmp to_decimal 

    write_digits:
        pop eax
        push ecx 
        add ah, '0'
        mov [tmp], ah
        write STD_OUT, tmp, 1 
        pop ecx 
        loop write_digits

    end: 
        write STD_OUT, NEW_LINE, 1
        mov eax, SYS_CLOSE 
        mov ebx, [file_d]
        int 0x80 
        mov eax, SYS_EXIT 
        mov ebx, EXIT_STATUS 
        int 0x80 

    usage: 
        write STD_ERR, ERROR_MESSAGE, ERROR_MESSAGE_LEN 
        write STD_ERR, USAGE_PREFIX, USAGE_PREFIX_LEN
        write STD_ERR, USAGE_PROGRAMM, USAGE_PROGRAMM_LEN
        write STD_ERR, USAGE_SUFFIX, USAGE_SUFFIX_LEN
        jmp end

        


