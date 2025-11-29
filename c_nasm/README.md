# Exemplo de integração C + NASM

Este diretório contém exemplos de integração entre a linguagem C e o montador **NASM**, utilizando a convenção de chamada do Linux x86_64.

A ideia é mostrar, passo a passo, como:

* Escrever funções em assembly NASM.
* Declarar essas funções em C.
* Compilar e ligar tudo usando `gcc`.
* Utilizar funções da biblioteca padrão de C (por exemplo, `stdio.h`) em conjunto com código em assembly.

---

## Estrutura

* `main.c`
  Arquivo principal em C, responsável pela função `main`, que chama funções implementadas em assembly.

* `funcoes.asm`
  Implementação, em NASM, de funções que serão chamadas a partir do C.

* `Makefile` (a ser criado em passos posteriores)
  Facilitará o processo de compilação e linkedição.

Cada passo será registrado com um commit específico, para que o histórico sirva como material de estudo.

---

## Passo C1 – Interface entre C e NASM

Neste módulo, iremos trabalhar com duas funções implementadas em assembly (NASM) que serão chamadas a partir de um programa em C.

As assinaturas em C serão:

```c
// Soma dois números inteiros long.
long soma(long a, long b);

// Imprime uma mensagem simples (sem quebra de linha automática).
void imprime_mensagem(const char *msg);
```

No arquivo `main.c`, essas funções serão declaradas como `extern`:

```c
extern long soma(long a, long b);
extern void imprime_mensagem(const char *msg);
```

A implementação delas ficará em `funcoes.asm`.

---

### Convenção de chamada (Linux x86_64 – SysV ABI)

Para funções chamadas a partir de C em um ambiente Linux 64 bits, utilizaremos a convenção de chamada padrão SysV AMD64. Os registradores de parâmetros são:

* 1º argumento: `RDI`
* 2º argumento: `RSI`
* 3º argumento: `RDX`
* 4º argumento: `RCX`
* 5º argumento: `R8`
* 6º argumento: `R9`

O valor de retorno (para tipos inteiros e ponteiros) é colocado em `RAX`.

Isso significa que, por exemplo, na função `soma(long a, long b)`:

* O parâmetro `a` chegará em `RDI`.
* O parâmetro `b` chegará em `RSI`.
* O resultado deverá ser devolvido em `RAX`.

Da mesma forma, em `imprime_mensagem(const char *msg)`, o ponteiro `msg` chegará em `RDI`.

Nos próximos passos, iremos:

1. Criar um `main.c` simples que chama `soma` e exibe o resultado com `printf`.
2. Implementar `soma` em `funcoes.asm`.
3. Compilar e ligar tudo com `gcc`.
4. Depois, estender o exemplo para incluir `imprime_mensagem` e, por fim, adicionar um `Makefile` para automatizar o processo.
