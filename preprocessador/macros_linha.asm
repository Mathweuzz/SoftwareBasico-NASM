; macros_linha.asm - esqueleto básico para pré-processador NASM
;
; Versão do passo 2:
; - Programa mínimo em NASM 64 bits (Linux)
; - Ainda sem uso pesado de macros de linha
; - Apenas imprime uma mensagem simples e encerra

global _start

section .data
    msg db "Exemplo inicial de NASM", 10

section .text
_start:
    ; write(1, msg, tamanho)
    mov rax, 1 ; syscall write
    mov rdi, 1 ; file descriptor stout
    mov rsi, msg ; endereço da string
    mov rdx, 24 ; msg com o \n(creio que de isso)
    syscall

    ; exit(0)
    mov rax, 60 ; syscall exit
    xor rdi, rdi ; código de retorno 0
    syscall