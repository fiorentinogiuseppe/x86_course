org 0x7c00  ; Diretiva Assembler que define onde o codigo sera colocado dentro do executavel
bits 16     ; Indica que usaremos os codigos para 32bits

mov ax, 0 ; Inicia ax com 0
; Iniciar os outros registradores com 0 tambem
mov ds, ax
mov es, ax

; Configurando a stack
mov ss, ax
mov sp, 0x7c00

mov si, welcome
call print_string

; ================
; Main
; ================

; top-level label
mainloop:
  mov si, prompt
  call print_string

  mov di, buffer
  call get_string

  mov si, buffer
  cmp byte [si], 0  ; Verifica se eh uma linha em branco
  je mainloop

  mov si, buffer
  mov di, cmd_hi  ; "Ciao"
  call strcmp
  jc .helloworld

  mov si, buffer
  mov di, cmd_help  ; "aiuto"
  call strcmp
  jc .help

  mov si, badcommand
  call print_string
  jmp mainloop

  ;local labels
  .helloworld:
    mov si, msg_helloworld
    call print_string

    jmp mainloop

  ;local labels
  .help:
    mov si, msg_help
    call print_string

    jmp mainloop

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

; top-level label
print_string:
  lodsb       ; Carrega um byte do SI
  ; Nao entendi muito
  or al, al
  jz .done

  mov ah, 0x0E   ; shifht out code
  int 0x10       ; chamada de serviço bios

  jmp print_string

  ;local labels
  .done:
    ret           ; retira o endereco de retorno da pilha e retorna o controle para esse local.

; top-level label
get_string:
  xor cl, cl

  ;local labels
  .loop:
    ; Espera ate uma key ser pressionada
    mov ah, 0
    int 0x16      ; The BIOS keyboard functions

    ; Se for o backspace lida com isso
    cmp al, 0x08  ; backspace code
    je .backspace

    ; Se for o enter terminamos
    cmp al, 0x0D  ; retorno do carro
    je .done

    ; Espera os 63 carecteres e/ou backspace e enter
    cmp cl, 0x3F  ; Verifica se 63 caracteres foram inseridos
    je .loop

    mov ah, 0x0E  ; shifht out
                  ;  O shift in e shift out, 0xE e 0XF, são relacionados ao ato
                  ; de pressionar a tecla shift do computador, para entrar no
                  ; modo de letras maiúsculas e para voltar ao modo de letras minúsculas.
    int 0x10      ; chamada de serviço bios para printar o caracter

    stosb         ; O stosb armazena um byte do registro AL no buffer
    inc cl
    jmp .loop

  ;local labels
  .backspace:
    ; Verifica se esta no inicio da string
    cmp cl, 0
    je .loop

    ; Remove o caracter e decrementa a contagem
    dec di           ; Registro do índice de destino.
                     ; Usado para "string", "memory array copying" e "setting"
                     ; e para endereçamento de ponteiro remoto com ES.
    mov byte [di], 0 ; armazene o valor 0 no byte no local di
    dec cl

    ; Faz o backspace na tela
    mov ah, 0x0E  ; shifht out code
    mov al, 0x08  ; backspace code
    int 10h       ; chamada de serviço bios

    ; Coloca o char vazio na tela
    mov al, ' '   ; blank charactere
    int 10h       ; chamada de serviço bios

    ; Backspace novamente
    mov al, 0x08  ; backspace code
    int 10h       ; chamada de serviço bios

    jmp .loop     ; go to

  ;local labels
  .done:
    mov al, 0     ; null code
    stosb         ; O stosb armazena um byte do registro AL no buffer

    mov ah, 0x0E  ; shifht out code
    mov al, 0x0D  ; retorno do carro
    int 0x10      ; chamada de serviço bios

    mov al, 0x0A  ; new line
    int 0x10      ; chamada de serviço bios

    ret           ; retira o endereco de retorno da pilha e retorna o controle para esse local.

; top-level label
strcmp:

  ;local labels
  .loop:
    mov al, [si]   ; pega 1byte de si
    mov bl, [di]   ; pega 1byte de si

    ; verifica se sao iguais. se forem diferentes jump para .notequal
    cmp al, bl
    jne .notequal

    ; caso contrario
    ; verifica se sao null. se forem pula para .done
    cmp al, 0
    je .done

    ; caso contrario
    ; incremente di, si e volta para o loop
    inc di
    inc si
    jmp .loop

  ;local labels
  .notequal:
    ; limpa a flag de carry resultado da comparacao
    clc
    ret

  ;local labels
  .done:
    ; coloca a flag de carry para 1
    stc
    ret

  times 510-($-$$) db 0 ; $ siginifica endereco atual e $$ siginifica primeiro endereco da secao atual
                        ; A diferenca ($-$$) gera um offset de deslocamento do iniciao ao endereco da instrucao atual
                        ; A diference 510-($-$$) Obtera o deslocamento da instrucao atual para o quinquagesimo decimo byte
                        ; time preenchera do inicio ao bite 510 com zeros
  dw 0AA55h ; MBR(Master Boot Record) Boot signature 0AA55 para little-endian
