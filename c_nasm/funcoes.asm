; funcoes.asm - Passo C2: funcao soma em NASM
;
; Assinatura em C:
;   long soma(long a, long b);
;
; Convenção SysV AMD64 (Linux x86_64):
;   - 1º argumento (a) em RDI
;   - 2º argumento (b) em RSI
;   - retorno em RAX

global soma

section .text
soma:
    ; rax = a + b
    mov     rax, rdi      ; rax = a
    add     rax, rsi      ; rax = a + b
    ret                   ; retorna em rax
