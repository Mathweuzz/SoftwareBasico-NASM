; macros_linha.asm - exemplo com uso de equ, %define e %assign
;
; Versão do Passo 4:
;   - Programa em NASM 64 bits (Linux)
;   - Uso de:
;       - equ      : para calcular tamanhos de mensagens
;       - %define  : para constantes simbólicas (syscalls, descritores)
;       - %assign  : para valores inteiros avaliados em tempo de montagem

;
; definições simbolicas
;
%define SYS_WRITE 1 ; numero da syscall write
%define SYS_EXIT 60 ; numero da syscall exit
%define STDOUT 1 ; descritor de arquivo para saida padrao - stdout

global _start

section .data
    ; primeira mensagem
    msg1 db "Exemplo inicial de NASM com pre-processador", 10
    msg1_len equ $ - msg1

    ; segunda mensagem
    msg2 db "Segunda linha exibida pelo programa", 10
    msg2_len equ $ - msg2

    ; use de %assign para valores inteiro do pre-processador
    ; TOTAL_MSGS: quantidade total de mensagens que o programa exibe
    ; TOTAL_LEN: soma dos tamanhos das mensagens em bytes
    ;
    ; esses valores são calculador pelo pre-processador e podem ser usado como constantes

    %assign TOTAL_MSGS 2
    %assign TOTAL_LEN (msg1_len + msg2_len)

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

    ; exemplo de usod de TOTAL_LEN
    mov rbx, TOTAL_LEN ; TOTAL_LEN é um valor inteiro calculado em montegem

    ; exit(0)
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall