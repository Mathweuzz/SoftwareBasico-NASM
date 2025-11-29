// main.c - Passo C3: soma em NASM e mensagem impressa via NASM + puts
//
// Este programa:
// - Declara as funcoes `soma` e `imprime_mensagem`, implementadas em NASM.
// - Calcula soma(10, 32) e exibe o resultado com printf (stdio.h).
// - Chama `imprime_mensagem` para imprimir uma mensagem usando `puts` na libc.


#include <stdio.h>


// funcoes implementadas em funcoes.asm
extern long soma(long a, long b);
extern void imprime_mensagem(const char *msg);


int main(void) {
long a = 10;
long b = 32;
long r = soma(a, b);


printf("Resultado de %ld + %ld = %ld\n", a, b, r);


imprime_mensagem("Mensagem impressa a partir de NASM usando puts()");


return 0;
}