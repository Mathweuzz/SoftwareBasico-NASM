; macros_linha.asm
; ---------------------------------------------------------------------------
; Exemplo de uso do pré-processador do NASM:
;   - equ       : cálculo de tamanhos e expressões ligadas a labels
;   - %define   : constantes simbólicas para syscalls e descritores
;   - %assign   : valores inteiros puros de pré-processamento
;   - %if       : condicionais baseadas em valores numéricos
;   - %ifdef    : inclusão condicional de código (ex.: DEBUG)
;
; O programa:
;   1) Imprime duas mensagens principais.
;   2) Opcionalmente imprime uma mensagem extra se TOTAL_MSGS > 1.
;   3) Opcionalmente imprime uma mensagem de depuração se DEBUG estiver definido.
;   4) Encerra com exit(0).
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Definições simbólicas (pré-processador)
; ---------------------------------------------------------------------------

%define SYS_WRITE  1        ; número da syscall write (Linux x86_64)
%define SYS_EXIT   60       ; número da syscall exit  (Linux x86_64)
%define STDOUT     1        ; descritor de arquivo para saída padrão (stdout)

global _start

; ---------------------------------------------------------------------------
; Seção de dados
; ---------------------------------------------------------------------------

section .data
    ; Primeira mensagem
    msg1 db "Exemplo inicial de NASM com pre-processador", 10
    msg1_len equ $ - msg1

    ; Segunda mensagem
    msg2 db "Segunda linha exibida pelo programa", 10
    msg2_len equ $ - msg2

    ; Contador de mensagens definido em tempo de pré-processamento
    %assign TOTAL_MSGS 2

    ; Tamanho total das mensagens calculado em tempo de montagem
    TOTAL_LEN equ msg1_len + msg2_len

    ; -----------------------------------------------------------------------
    ; Exemplo de %if: só define msg_multi se TOTAL_MSGS > 1
    ; -----------------------------------------------------------------------
    %if TOTAL_MSGS > 1
        msg_multi db "INFO: ha mais de uma mensagem definida.", 10
        msg_multi_len equ $ - msg_multi
    %endif

    ; -----------------------------------------------------------------------
    ; Exemplo de %ifdef: bloco só existente em modo DEBUG
    ;   - Ativado com: nasm -DDEBUG ...
    ; -----------------------------------------------------------------------
    %ifdef DEBUG
        debug_msg db "DEBUG: execucao em modo de depuracao ativa.", 10
        debug_msg_len equ $ - debug_msg
    %endif

; ---------------------------------------------------------------------------
; Seção de código
; ---------------------------------------------------------------------------

section .text
_start:
    ; -----------------------------------------------------------------------
    ; write(STDOUT, msg1, msg1_len)
    ; -----------------------------------------------------------------------
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg1
    mov     rdx, msg1_len
    syscall

    ; -----------------------------------------------------------------------
    ; write(STDOUT, msg2, msg2_len)
    ; -----------------------------------------------------------------------
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg2
    mov     rdx, msg2_len
    syscall

    ; -----------------------------------------------------------------------
    ; Se TOTAL_MSGS > 1, msg_multi foi definida e o código abaixo existe
    ; -----------------------------------------------------------------------
    %if TOTAL_MSGS > 1
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, msg_multi
        mov     rdx, msg_multi_len
        syscall
    %endif

    ; -----------------------------------------------------------------------
    ; Exemplo de uso de TOTAL_LEN:
    ;   - Aqui apenas carregamos o valor em RBX.
    ;   - Em programas reais, isso poderia ser usado para dimensionar buffers,
    ;     laços, etc.
    ; -----------------------------------------------------------------------
    mov     rbx, TOTAL_LEN

    ; -----------------------------------------------------------------------
    ; Bloco extra só em modo DEBUG
    ; -----------------------------------------------------------------------
    %ifdef DEBUG
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, debug_msg
        mov     rdx, debug_msg_len
        syscall
    %endif

    ; -----------------------------------------------------------------------
    ; exit(0)
    ; -----------------------------------------------------------------------
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    syscall
