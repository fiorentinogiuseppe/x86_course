
; fasm demonstration of writing simple ELF executable

format ELF executable 3
entry start

; ===============================================
segment readable executable

start:
    ; Your program begins here:
    inc     eax
    inc     eax
    dec     eax
    inc     eax

    ; Exit the process:
    mov	eax,1
	  xor	ebx,ebx
	  int	0x80
