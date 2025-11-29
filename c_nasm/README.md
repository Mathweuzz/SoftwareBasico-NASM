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

* `Makefile`
  Facilita o processo de compilação e linkedição (`make`, `make run`, `make clean`).

Cada passo é registrado com um commit específico, para que o histórico sirva como material de estudo.

---

## Passo C1 – Interface entre C e NASM

Neste módulo, trabalhamos com duas funções implementadas em assembly (NASM) que
são chamadas a partir de um programa em C.

Assinaturas em C:

```c
// Soma dois números inteiros long.
long soma(long a, long b);

// Imprime uma mensagem simples.
void imprime_mensagem(const char *msg);
```

No arquivo `main.c`, essas funções são declaradas como `extern`:

```c
extern long soma(long a, long b);
extern void imprime_mensagem(const char *msg);
```

A implementação fica em `funcoes.asm`.

### Convenção de chamada (Linux x86_64 – SysV ABI)

Para funções chamadas a partir de C em um ambiente Linux 64 bits, é utilizada a
convenção de chamada padrão SysV AMD64. Os registradores de parâmetros são:

* 1º argumento: `RDI`
* 2º argumento: `RSI`
* 3º argumento: `RDX`
* 4º argumento: `RCX`
* 5º argumento: `R8`
* 6º argumento: `R9`

O valor de retorno (para tipos inteiros e ponteiros) é colocado em `RAX`.

Exemplo para `long soma(long a, long b)`:

* `a` chega em `RDI`.
* `b` chega em `RSI`.
* o resultado deve ser colocado em `RAX`.

---

## Passo C2 – Exemplo mínimo: `soma` em NASM

Neste passo foi criado um exemplo mínimo de integração C + NASM:

* `funcoes.asm` implementa a função:

```nasm
long soma(long a, long b);
```

usando os registradores `RDI` (a), `RSI` (b) e retornando o resultado em `RAX`.

* `main.c` declara `extern long soma(long a, long b);` e chama `soma(10, 32)`,
  exibindo o resultado com `printf`.

### Comandos de compilação (sem Makefile)

Dentro do diretório `c_nasm/`:

```bash
# Montar o assembly
nasm -f elf64 funcoes.asm -o funcoes.o

# Compilar e ligar com gcc (desabilitando PIE para compatibilizar com o .o do NASM)
gcc -no-pie main.c funcoes.o -o prog_soma

# Executar
./prog_soma
```

Saída esperada:

```text
Resultado de 10 + 32 = 42
```

---

## Passo C3 – `imprime_mensagem`: NASM chamando `puts` da libc

Neste passo, o exemplo foi estendido com uma segunda função em assembly:

```c
void imprime_mensagem(const char *msg);
```

Implementação em `funcoes.asm`:

* A função recebe o ponteiro `msg` em `RDI` (convenção SysV AMD64).
* Chama a função `puts` da libc (`extern puts`) para imprimir a mensagem
  seguida de uma quebra de linha.
* Cuida do alinhamento de pilha antes do `call puts` (princípios da ABI).

No `main.c`:

* `soma(10, 32)` continua sendo chamada e o resultado é exibido com `printf`.
* Em seguida, `imprime_mensagem("Mensagem impressa a partir de NASM usando puts()")`
  é chamada, demonstrando uma função em NASM que usa uma função da biblioteca C.

### Comandos de compilação (sem Makefile)

```bash
nasm -f elf64 funcoes.asm -o funcoes.o
gcc -no-pie main.c funcoes.o -o prog_c_nasm
./prog_c_nasm
```

Saída esperada:

```text
Resultado de 10 + 32 = 42
Mensagem impressa a partir de NASM usando puts()
```

---

## Passo C4 – Makefile para automatizar a compilação

Para facilitar a compilação e execução, foi criado um `Makefile` simples com
os seguintes alvos:

* `make` ou `make all`
  Monta `funcoes.asm`, compila `main.c` e gera o binário final `prog_c_nasm`.

* `make run`
  Garante que o binário esteja compilado e o executa.

* `make clean`
  Remove os arquivos objeto e o executável gerado.

### Uso básico do Makefile

Dentro do diretório `c_nasm/`:

```bash
# Compilar tudo\ nmake

# Executar o programa
make run

# Limpar objetos e binario
make clean
```

Isso evita ter que lembrar dos detalhes de `gcc -no-pie` e dos nomes de todos
os arquivos a cada alteração no código.
