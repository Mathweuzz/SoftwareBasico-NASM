// main.c - Passo C2: exemplo minimo de integracao C + NASM
//
// Este programa:
//   - Declara a funcao `soma` implementada em assembly (funcoes.asm).
//   - Chama `soma(10, 32)`.
//   - Imprime o resultado usando printf.

#include <stdio.h>

// funcao implementada em funcoes.asm
extern long soma(long a, long b);

int main(void) {
    long a = 10;
    long b = 32;
    long r = soma(a, b);

    printf("Resultado de %ld + %ld = %ld\n", a, b, r);
    return 0;
}
