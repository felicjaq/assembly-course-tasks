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
    USAGE_PROGRAMM: db "./5 ", 0
    USAGE_PROGRAMM_LEN: equ $ - USAGE_PROGRAMM
    USAGE_SUFFIX: db "<file_name>", 0xa
    USAGE_SUFFIX_LEN: equ $ - USAGE_SUFFIX
    ERROR_MESSAGE: db "Error...", 0xa
    ERROR_MESSAGE_LEN: equ $ - ERROR_MESSAGE
    SUCCESS_MESSAGE: db "Second line of the file: ", 0
    SUCCESS_MESSAGE_LEN equ $ - SUCCESS_MESSAGE
    ONE_LINE_MESSAGE: db "There is only one line in your file.", 0xa
    ONE_LINE_MESSAGE_LEN equ $ - ONE_LINE_MESSAGE
    SPACE: db " ", 0
    NEW_LINE equ 0xa
    END_OF_TEXT equ 0x3

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
        
        mov ecx, [file_size] 
        mov edi, file_data 
        mov eax, 0xa 
        cld 
        repne scasb 
        je new_line
        jmp one_line

    new_line:
        mov esi, file_data
        add esi, [file_size]
        sub esi, ecx
        inc ecx
        write STD_OUT, SUCCESS_MESSAGE, SUCCESS_MESSAGE_LEN

    write_symbols:	
        push ecx
        mov eax, 0xa
        cld
        scasb
        ; call check_for_eof
        je end
        lodsb
        cmp al, 0
        je end
        mov [tmp], al
        write STD_OUT, tmp, 1
        pop ecx
        loop write_symbols   
        jmp end

    ; check_for_eof:
    ;     mov eax, 0x3
    ;     cld
    ;     scasb
    ;     je end
    ;     ret

    one_line:
        write STD_OUT, ONE_LINE_MESSAGE, ONE_LINE_MESSAGE_LEN

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

        


