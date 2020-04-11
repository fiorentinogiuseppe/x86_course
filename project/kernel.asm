; http://www.eecg.toronto.edu/~amza/www.mindsec.com/files/x86regs.html x86 registradores
; https://upload.wikimedia.org/wikipedia/commons/1/15/Table_of_x86_Registers_svg.svg

org 0x7c00  ; Diretiva Assembler que define onde o codigo sera colocado dentro do executavel
bits 16     ; Indica que usaremos os codigos para 16bits

  mov ax, 0 ; Inicia ax com 0
  ; Iniciar os outros registradores com 0 tambem
  mov ds, eax
  mov es, eax

  ; Configurando a stack
  mov ss, eax
  mov esp, 0x7c00

  mov esi, welcome
  call print_string

; ================
; Main
; ================



; ================
; Variables
; ================
welcome db 'Benvenuto viaggiatore!', 0x0D, 0x0A, 0
msg_helloworld db 'Ciao, viaggiatore!', 0x0D, 0x0A, 0
badcommand db 'Comando errato inserito.', 0x0D, 0x0A, 0
prompt db '>', 0
cmd_hi db 'ciao', 0
cmd_help db 'aiuto', 0
msg_help db 'PINO sistema operativo: comandi: ciao, aiuto', 0x0D, 0x0A, 0
buffer times 64 db 0

; ================
; calls
; ================

print_string:
  lodsb

  or al, al
  jz .done

  mov ah, 0x0E
  int 0x10

  jmp print_string

.done:
  ret

get_string:
    xor cl, cl

.loop:
  mov ah, 0
  int 0x16

  cmp al, 0x08
  je .backspace

  cmp al, 0x0D
  je .done

  cmp cl, 0x3F
  je .loop

  mov ah, 0x0E
  int 0x10

  stosb
  inc cl
  jml .loop
