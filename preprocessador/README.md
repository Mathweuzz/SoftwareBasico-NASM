# Pré-processador do NASM

Esta pasta contém um exemplo de programa em NASM focado no uso do **pré-processador**, com ênfase em macros de linha e diretivas vistas em aula.

A ideia é construir o código em etapas, com commits bem definidos, para servir como material de estudo e histórico de evolução no repositório.

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

## Estrutura de arquivos

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

Neste passo, foi criado um programa mínimo em NASM 64 bits para Linux, apenas com:

* Uma mensagem armazenada em `section .data`.
* Um ponto de entrada `_start` em `section .text`.
* Chamadas de sistema (`syscall`) para:

  * `write(1, msg, tamanho)`
  * `exit(0)`

O objetivo era garantir que:

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

Neste passo, o programa `macros_linha.asm` foi refatorado para evitar valores "mágicos" diretamente no código, utilizando recursos do pré-processador do NASM.

#### `equ` – constantes associadas a rótulos (labels)

A diretiva `equ` permite associar um valor a um símbolo em tempo de montagem. Um uso muito comum é calcular o **tamanho de uma string** com base na posição atual do montador:

```nasm
msg db "Exemplo inicial de NASM com pre-processador", 10
msg_len equ $ - msg
```

* `$` representa o endereço atual na seção onde o código está sendo montado.
* `$ - msg` corresponde ao número de bytes desde o início de `msg` até o endereço atual, resultando no **tamanho da mensagem** em bytes.

Esse valor é então reutilizado no código:

```nasm
mov     rdx, msg_len       ; tamanho da mensagem calculado com equ
```

Assim, se o texto da mensagem for alterado, o tamanho será recalculado automaticamente na montagem, sem necessidade de ajuste manual.

#### `%define` – constantes simbólicas de pré-processador

A diretiva `%define` funciona como uma substituição textual (similar a `#define` em C), sendo útil para dar nomes mais expressivos a valores numéricos que seriam difíceis de lembrar:

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

Dessa forma, o código fica mais legível e menos propenso a erros, facilitando tanto a manutenção quanto o estudo do comportamento do programa.

---

### Passo 4 – Uso de `%assign` e expressões em tempo de montagem

Neste passo, o programa foi estendido para utilizar a diretiva `%assign`, permitindo trabalhar com valores inteiros avaliados em tempo de montagem.

Foram definidas duas mensagens:

```nasm
msg1 db "Exemplo inicial de NASM com pre-processador", 10
msg1_len equ $ - msg1

msg2 db "Segunda linha exibida pelo programa", 10
msg2_len equ $ - msg2
```

E, a partir delas, o pré-processador calcula:

```nasm
%assign TOTAL_MSGS 2
%assign TOTAL_LEN (msg1_len + msg2_len)
```

* `TOTAL_MSGS` representa a quantidade total de mensagens exibidas.
* `TOTAL_LEN` é a soma dos tamanhos das mensagens (em bytes), calculada usando os valores obtidos via `equ`.

#### Diferença entre `equ` e `%assign` (neste contexto)

* `equ`:

  * Associa um símbolo a uma expressão, normalmente ligada a endereços ou rótulos do próprio código.
  * Exemplo clássico: calcular tamanho de strings com `$ - label`.

* `%assign`:

  * Trabalha com valores inteiros no pré-processador, permitindo reatribuições e uso de expressões aritméticas.
  * Os símbolos definidos com `%assign` podem ser usados como constantes numéricas em instruções (por exemplo, carregando em registradores, configurando tamanhos de buffers, limites de laços, etc.).

No código, `TOTAL_LEN` é carregado em um registrador:

```nasm
mov     rbx, TOTAL_LEN
```

Esse uso ilustra que o valor calculado em tempo de montagem passa a se comportar como uma constante numérica normal dentro do programa.

---

Nos próximos passos, o programa será estendido para incluir:

* Condicionais de pré-processamento (`%if`, `%ifdef`, …).
* Geração explícita de código pré-processado (`.pre`) e listagens (`.lst`) usando os comandos do NASM.