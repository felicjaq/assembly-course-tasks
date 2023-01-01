%include "io.mac"

section .data
	GAMMA db "1234"
    SYS_CLOSE equ 6
    SYS_OPEN equ 5
    SYS_WRITE equ 4
    SYS_READ equ 3
    STD_ERR equ 2
    STD_OUT equ 1
    STD_IN equ 0
    SYS_EXIT equ 1
    EXIT_STATUS equ 0
    WELCOME_MESSAGE: db "Gamma string: ", 0
    WELCOME_MESSAGE_LEN equ $ - WELCOME_MESSAGE

section .bss
	BUFFER resb 256
	X resb 10
	N resb 10
	REMAINDER resb 10
	SEC_REMAINDER resb 10
	LEN resb 10

global _start
section .text
    _start:
        read STD_IN, BUFFER, 256
	    dec eax
	    mov [LEN], eax
	    mov ax, [LEN]
	    mov bl, 4
	    div bl
	    mov [REMAINDER], ah
	    mov [N], al
	    lea esi, [BUFFER]
	    mov ecx, [N]
	    cmp ecx, 0
	    je badly

    alloop:
	    push ecx
	    lodsd
	    xor eax, [GAMMA]
	    mov [X], eax
        write STD_OUT, X, 10
        mov eax, 0
        pop ecx
        loop alloop

    badly:
        mov edi, SEC_REMAINDER
        mov ecx, [REMAINDER]
        cmp ecx, 0
        je end

    siloop:
        push ecx
        movsb
        pop ecx	
        loop siloop
        mov eax, 0
        cmp [REMAINDER], eax
        je end
        mov edx, 0
        xor [SEC_REMAINDER], edx
        mov eax, [SEC_REMAINDER]
        xor eax, [GAMMA]
        mov [X], eax
        write STD_OUT, X, [REMAINDER]
	
    end:
	    mov eax, SYS_EXIT
	    mov ebx, EXIT_STATUS 
	    int 0x80

 
