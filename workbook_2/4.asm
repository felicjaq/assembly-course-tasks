%include "io.mac"
global _start
section .text
    _start:
        pop ebx 
        pop ebx 

        open 
        mov [file_d], eax 
        read [file_d], file_data, 256 
        dec eax 
        mov [block_size], eax 

        write std_out, success_message, success_message_len
        mov esi, file_data 
        mov ax, [block_size] 
        mov bl, 4 
        div bl 

        mov [block_size], al
        cmp ah, 0

        jne incr 
	    je no_incr
	
	incr:
        mov ecx, [block_size]
        inc ecx
        mov [block_size], ecx
	
    no_incr:
        mov ecx, [block_size]
        mov esi, file_data

    convert:
		push ecx 
		lodsd 
		xor [block], eax
		pop ecx
		loop convert 

        mov eax, [block] 
        mov ecx, 32

    to_binary:
        push ecx 
		push ecx
		rol eax, 1 
		push eax
		jnc write_zero_digit
		jmp write_one_digit
		
	write_zero_digit:
		write std_out, digit_zero, 1
		jmp skip
			
	write_one_digit:
		write std_out, digit_one, 1
				
	skip: 
		pop eax
		pop ecx
		pop ecx
        
		loop to_binary 
    
    end: 
        close [file_d] 
        mov eax, sys_exit 
        mov ebx, exit_status 
        int 0x80 


section .bss
    file_d resb 256 
    file_data resb 256 
    file_size resb 256
    block_size resb 4 
    block resb 4
    tmp resb 4

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
    success_message: db "The file checksum in binary form: ", 0
    success_message_len equ $ - success_message
    digit_one db "1"
    digit_zero db "0"