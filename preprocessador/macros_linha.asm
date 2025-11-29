; macros_linha.asm - uso de equ, %define, %assign e condicionais (%if, %ifdef)
;
; Versão do Passo 5:
;   - Usa:
;       - equ       : tamanhos de mensagens
;       - %define   : constantes simbólicas (syscalls, descritores)
;       - %assign   : valores inteiros no pré-processador
;       - %if       : condição baseada em TOTAL_MSGS
;       - %ifdef    : habilitar código extra em modo DEBUG

; ---------------------------------------------------------------------------
; Definições simbólicas (pré-processador)
; ---------------------------------------------------------------------------

%define SYS_WRITE  1       ; número da syscall write
%define SYS_EXIT   60      ; número da syscall exit
%define STDOUT     1       ; descritor de arquivo para saída padrão (stdout)

global _start

section .data
    ; Primeira mensagem
    msg1 db "Exemplo inicial de NASM com pre-processador", 10
    msg1_len equ $ - msg1

    ; Segunda mensagem
    msg2 db "Segunda linha exibida pelo programa", 10
    msg2_len equ $ - msg2

    ; Valores inteiros calculados em tempo de montagem
    %assign TOTAL_MSGS 2
    %assign TOTAL_LEN (msg1_len + msg2_len)

    ; -----------------------------------------------------------------------
    ; Exemplo de %if: só define msg_multi se TOTAL_MSGS > 1
    ; -----------------------------------------------------------------------
    %if TOTAL_MSGS > 1
        msg_multi db "INFO: ha mais de uma mensagem definida.", 10
        msg_multi_len equ $ - msg_multi
    %endif

    ; -----------------------------------------------------------------------
    ; Exemplo de %ifdef: bloco so existente em modo DEBUG
    ;    - Ativado com: nasm -DDEBUG ...
    ; -----------------------------------------------------------------------
    %ifdef DEBUG
        debug_msg db "DEBUG: execucao em modo de depuracao ativa.", 10
        debug_msg_len equ $ - debug_msg
    %endif

section .text
_start:
    ; write(STDOUT, msg1, msg1_len)
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg1
    mov     rdx, msg1_len
    syscall

    ; write(STDOUT, msg2, msg2_len)
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg2
    mov     rdx, msg2_len
    syscall

    ; Se TOTAL_MSGS > 1, msg_multi foi definida e o código abaixo existe
    %if TOTAL_MSGS > 1
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, msg_multi
        mov     rdx, msg_multi_len
        syscall
    %endif

    ; Exemplo de uso de TOTAL_LEN: apenas carregado em um registrador
    mov     rbx, TOTAL_LEN

    ; Bloco extra só em modo DEBUG
    %ifdef DEBUG
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, debug_msg
        mov     rdx, debug_msg_len
        syscall
    %endif

    ; exit(0)
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    syscall