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
    USAGE_PREFIX: db "Usage: ", 0
    USAGE_PREFIX_LEN: equ $ - USAGE_PREFIX
    USAGE_PROGRAMM: db "./1 ", 0
    USAGE_PROGRAMM_LEN: equ $ - USAGE_PROGRAMM
    USAGE_SUFFIX: db "<file_name>", 0xa
    USAGE_SUFFIX_LEN: equ $ - USAGE_SUFFIX
    ERROR_MESSAGE: db "Error...", 0xa
    ERROR_MESSAGE_LEN: equ $ - ERROR_MESSAGE
    SUCCESS_MESSAGE: db "The file has been successfully overwritten.", 0xa
    SUCCESS_MESSAGE_LEN equ $ - SUCCESS_MESSAGE
    SPACE: db " ", 0
    x_o db 195

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
        mov ecx, 2 
        int 0x80 
       
        mov [file_d], eax 
        read [file_d], file_data, 256 
        mov [file_size], eax 

        mov eax, SYS_SEEK
        mov ebx, [file_d] 
        xor ecx, ecx
        xor edx, edx
        int 0x80 

        mov ecx, [file_size]
        call destroy_data
        write STD_OUT, SUCCESS_MESSAGE, SUCCESS_MESSAGE_LEN

    end: 
        mov eax, SYS_CLOSE 
        mov ebx, [file_d] 
        int 0x80 
        mov eax, SYS_EXIT 
        mov ebx, EXIT_STATUS 
        int 0x80 
    
    destroy_data:
        push ecx
        mov ax, [x_o]
        mov bl, 7
        mul bl
        add ax, 17
        mov bx, 256
        div bx
        mov [x_o], dx	
        write [file_d], x_o, 1
        pop ecx
        loop destroy_data
        ret

    usage: 
        write STD_ERR, ERROR_MESSAGE, ERROR_MESSAGE_LEN 
        write STD_ERR, USAGE_PREFIX, USAGE_PREFIX_LEN
        write STD_ERR, USAGE_PROGRAMM, USAGE_PROGRAMM_LEN
        write STD_ERR, USAGE_SUFFIX, USAGE_SUFFIX_LEN
        jmp end
