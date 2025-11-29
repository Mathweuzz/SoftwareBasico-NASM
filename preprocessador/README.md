# Pré-processador do NASM

Esta pasta contém um exemplo de programa em NASM focado no uso do
**pré-processador**, com ênfase em macros de linha e diretivas.

A ideia é construir o código em etapas, com commits bem definidos.

---

## Objetivo geral

* Demonstrar o uso de:

  * Definição de constantes (`equ`, `%define`).
  * Atribuições no pré-processador (`%assign`).
  * Condicionais de pré-processamento (`%if`, `%ifdef`, `%else`, `%endif`).
* Gerar saídas que permitam visualizar como o código é expandido:

  * Código pré-processado (sem macros).
  * Arquivo *listing* com a expansão das diretivas.

---

## Estrutura de arquivos (planejada)

* `macros_linha.asm`
  Programa principal em NASM que utiliza diversas construções do pré-processador.

* `build/`
  Diretório (criado durante a compilação) para armazenar:

  * Objetos (`.o`)
  * Executáveis
  * Código pré-processado (`.pre`)
  * Listagens (`.lst`)

---

## Passos de implementação

Abaixo está o resumo dos passos já implementados até o momento.

### Passo 2 – Esqueleto inicial do programa `macros_linha.asm`

Neste passo, foi criado um programa mínimo em NASM 64 bits para Linux, apenas
com:

* Uma mensagem armazenada em `section .data`.
* Um ponto de entrada `_start` em `section .text`.
* Chamadas de sistema (`syscall`) para:

  * `write(1, msg, tamanho)`
  * `exit(0)`

Ainda não havia uso de diretivas do pré-processador voltadas para macros de
linha; o objetivo era apenas garantir que:

* O ambiente de montagem e linkedição estava correto.
* O programa executava e imprimia algo na tela.

O binário é gerado com:

```bash
nasm -f elf64 macros_linha.asm -o build/macros_linha.o
ld build/macros_linha.o -o build/macros_linha
./build/macros_linha
```

---

### Passo 3 – Uso de `equ` e `%define` para constantes

Neste passo, o programa `macros_linha.asm` foi refatorado para evitar valores
"mágicos" diretamente no código, utilizando recursos do pré-processador do NASM.

#### `equ` – constantes associadas a rótulos (labels)

A diretiva `equ` permite associar um valor a um símbolo em tempo de montagem.
Um uso muito comum é calcular o **tamanho de uma string** com base na posição
atual do montador:

```nasm
msg db "Exemplo inicial de NASM com pre-processador", 10
msg_len equ $ - msg
```

* `$` representa o endereço atual na seção onde o código está sendo montado.
* `$ - msg` corresponde ao número de bytes desde o início de `msg` até o
  endereço atual, resultando no **tamanho da mensagem** em bytes.

Esse valor é então reutilizado no código:

```nasm
mov     rdx, msg_len       ; tamanho da mensagem calculado com equ
```

Assim, se o texto da mensagem for alterado, o tamanho será recalculado
automaticamente na montagem, sem necessidade de ajuste manual.

#### `%define` – constantes simbólicas de pré-processador

A diretiva `%define` funciona como uma substituição textual (similar a `#define`
em C), sendo útil para dar nomes mais expressivos a valores numéricos que seriam
difíceis de lembrar:

```nasm
%define SYS_WRITE  1
%define SYS_EXIT   60
%define STDOUT     1
```

Essas definições são usadas no código:

```nasm
mov     rax, SYS_WRITE     ; syscall: write
mov     rdi, STDOUT        ; file descriptor: stdout
mov     rax, SYS_EXIT      ; syscall: exit
```

Dessa forma, o código fica mais legível e menos propenso a erros, facilitando
tanto a manutenção quanto o estudo do comportamento do programa.

---

Nos próximos passos, o programa será estendido para incluir:

* Uso de `%assign` e expressões avaliadas em tempo de montagem.
* Condicionais de pré-processamento (`%if`, `%ifdef`, …).
* Geração explícita de código pré-processado (`.pre`) e listagens (`.lst`)
  usando os comandos do NASM.
