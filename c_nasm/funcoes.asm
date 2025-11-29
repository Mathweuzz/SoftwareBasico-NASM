; funcoes.asm - Passo C3: funcoes em NASM chamadas a partir de C
;
; Assinaturas em C:
;   long soma(long a, long b);
;   void imprime_mensagem(const char *msg);
;
; Convencao SysV AMD64 (Linux x86_64):
;   - 1o argumento em RDI
;   - 2o argumento em RSI
;   - 3o argumento em RDX
;   - 4o argumento em RCX
;   - 5o argumento em R8
;   - 6o argumento em R9
;   - retorno em RAX (para tipos inteiros / ponteiros)

global soma
global imprime_mensagem

extern puts              ; funcao da libc usada por imprime_mensagem

section .text

; ---------------------------------------------------------------------------
; long soma(long a, long b);
;   - a em RDI
;   - b em RSI
;   - retorno em RAX
; ---------------------------------------------------------------------------

soma:
    mov     rax, rdi         ; rax = a
    add     rax, rsi         ; rax = a + b
    ret                      ; retorna em rax

; ---------------------------------------------------------------------------
; void imprime_mensagem(const char *msg);
;   - msg em RDI
;   - nao ha valor de retorno relevante (void)
;
; Chama a funcao `puts` da libc, que imprime a string e adiciona '\n'.
;
; Sobre alinhamento de pilha:
;   - Na SysV ABI, antes de um `call`, RSP deve estar alinhado em 16 bytes.
;   - Ao entrar em uma funcao C, RSP costuma estar (call) % 16 = 8.
;   - Dando um push (8 bytes), alinhamos para 16 no momento do `call puts`.
; ---------------------------------------------------------------------------

imprime_mensagem:
    push    rbp
    mov     rbp, rsp

    ; RDI ja contem o ponteiro msg vindo de C,
    ; que e exatamente o argumento esperado por puts(const char *s).
    call    puts

    pop     rbp
    ret
