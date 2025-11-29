;macros_linha.asm - exemplo com uso de equi e %define
;
; versao do passo 3:
; - programa minimo em NASM 64 bits
; - uso de
;       - equ : para calcular o tamanho da mensagem
;       - %define : para criar constantes simbolicas (syscalls, descritores)
;

;
; definições simbolicas (pre processador)
;
%define SYS_WRITE 1 ; numero da syscall write
%define SYS_EXIT 60 ; numero da syscall exit
%define STDOUT 1 ; descritor de arquivo para saida padrao - stdout

global _start

section .data 
    msg db "Exemplo inicial de NASM com pre-processador", 10
    ; equ calcula o tamanho da mensagem em tempo de montagem
    ; $ = endereco atual
    ; $ - msg = quantidade de bytes desde o inicio de msg
    msg_len equ $ - msg

section .text
_start:
    ; write(STDOUT, msg, msg_len)
    mov rax, SYS_WRITE ; sycall write
    mov rdi, STDOUT ; file descripto stdout
    mov rsi, msg ; endereço da string
    mov rdx, msg_len ; tamanho da mensagem calculado com equ
    syscall

    ;exit(0)
    mov rax, SYS_EXIT ; syscall exit
    xor rdi, rdi ; codigo de retorno 0
    syscall