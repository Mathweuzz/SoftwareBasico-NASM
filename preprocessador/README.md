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
  * Listagens (`.lst`).

---

## Passos de implementação

Abaixo está o resumo dos passos já implementados até o momento.

### Passo 2 – Esqueleto inicial do programa `macros_linha.asm`

Neste passo foi criado um programa mínimo em NASM 64 bits para Linux, apenas com:

* Uma mensagem armazenada em `section .data`.
* Um ponto de entrada `_start` em `section .text`.
* Chamadas de sistema (`syscall`) para:

  * `write(1, msg, tamanho)`
  * `exit(0)`.

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

### Passo 4 – Uso de `%assign` e expressões em tempo de montagem

Neste passo, o programa foi estendido para utilizar a diretiva `%assign`,
permitindo trabalhar com valores inteiros avaliados em tempo de montagem.

Foram definidas duas mensagens:

```nasm
msg1 db "Exemplo inicial de NASM com pre-processador", 10
msg1_len equ $ - msg1

msg2 db "Segunda linha exibida pelo programa", 10
msg2_len equ $ - msg2
```

Para a quantidade de mensagens, foi usado `%assign`:

```nasm
%assign TOTAL_MSGS 2
```

Como `TOTAL_MSGS` é um valor literal (não depende de labels), ele é adequado
para ser manipulado puramente no pré-processador.

Já o tamanho total das mensagens depende de `msg1_len` e `msg2_len`, que são
calculados a partir de endereços. Por isso, aqui foi usado `equ`:

```nasm
TOTAL_LEN equ msg1_len + msg2_len
```

* `TOTAL_MSGS` representa a quantidade total de mensagens exibidas.
* `TOTAL_LEN` é a soma dos tamanhos das mensagens (em bytes).

#### Diferença entre `equ` e `%assign` (neste contexto)

* `equ`:

  * Associa um símbolo a uma expressão avaliada na fase de montagem,
    normalmente ligada a endereços ou rótulos do próprio código.
  * Exemplo clássico: calcular tamanho de strings com `$ - label`.

* `%assign`:

  * Trabalha com valores inteiros puros no pré-processador, permitindo
    reatribuições e uso de expressões aritméticas **sem** depender de labels.
  * Ideal para contadores, flags e configurações numéricas decididas em tempo
    de pré-processamento.

No código, `TOTAL_LEN` pode ser carregado em um registrador como uma constante
numérica normal:

```nasm
mov     rbx, TOTAL_LEN
```

---

### Passo 5 – Condicionais de pré-processamento (`%if`, `%ifdef`)

Neste passo, foram introduzidas diretivas condicionais do pré-processador para
alterar o código montado de acordo com valores e símbolos definidos.

#### Uso de `%if` com `TOTAL_MSGS`

Foi utilizado `%if TOTAL_MSGS > 1` para definir uma mensagem extra e o código
que a imprime **apenas** quando há mais de uma mensagem configurada:

```nasm
%if TOTAL_MSGS > 1
    msg_multi db "INFO: ha mais de uma mensagem definida.", 10
    msg_multi_len equ $ - msg_multi
%endif
```

E no trecho de código executável:

```nasm
%if TOTAL_MSGS > 1
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg_multi
    mov     rdx, msg_multi_len
    syscall
%endif
```

Se `TOTAL_MSGS` for ajustado para 1, essa parte simplesmente deixa de existir no
código montado.

#### Uso de `%ifdef` com `DEBUG`

Também foi incluído um bloco opcional de depuração, controlado pelo símbolo
`DEBUG`:

```nasm
%ifdef DEBUG
    debug_msg db "DEBUG: execucao em modo de depuracao ativa.", 10
    debug_msg_len equ $ - debug_msg
%endif
```

E no código:

```nasm
%ifdef DEBUG
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, debug_msg
    mov     rdx, debug_msg_len
    syscall
%endif
```

Esse bloco só é incluído quando o arquivo é montado com o símbolo `DEBUG`
definido. Exemplos de montagem:

* Versão "normal":

```bash
nasm -f elf64 macros_linha.asm -o build/macros_linha.o
ld build/macros_linha.o -o build/macros_linha
./build/macros_linha
```

* Versão com DEBUG ativado:

```bash
nasm -DDEBUG -f elf64 macros_linha.asm -o build/macros_linha_debug.o
ld build/macros_linha_debug.o -o build/macros_linha_debug
./build/macros_linha_debug
```

Na versão DEBUG, uma mensagem adicional de depuração é exibida ao final.

---

### Passo 6 – Geração de código pré-processado (`.pre`) e listagem (`.lst`)

Neste passo, o foco é gerar arquivos auxiliares a partir do `macros_linha.asm`
para visualizar como o pré-processador do NASM expande o código.

São gerados dois tipos de artefatos principais:

1. **Arquivo pré-processado (`.pre`)**

   * Contém o código após a expansão das diretivas do pré-processador (como
     `%define`, `%assign`, `%if`, `%ifdef` etc.).
   * É útil para enxergar exatamente o que o montador "enxerga" depois da fase
     de pré-processamento.

2. **Arquivo de listagem (`.lst`)**

   * Contém um *listing* com endereços, bytes gerados e a associação com as
     linhas do código fonte.
   * Ajuda a entender como cada instrução é codificada e onde as labels estão
     posicionadas.

#### Comandos utilizados

Assumindo que estamos dentro do diretório `preprocessador/` e que o subdiretório
`build/` já existe:

```bash
# 1) Gerar apenas a saída do pré-processador (.pre)
nasm -E macros_linha.asm > build/macros_linha.pre

# 2) Gerar objeto + listagem (.lst)
nasm -f elf64 -l build/macros_linha.lst macros_linha.asm -o build/macros_linha.o

# 3) Lincar (caso queira atualizar o executável também)
ld build/macros_linha.o -o build/macros_linha
```

#### Como interpretar

* `build/macros_linha.pre`:

  * É um arquivo de texto puro.
  * Nele, as expansões de `%if`/`%ifdef` já estão resolvidas, assim como as
    substituições de `%define` e os valores calculados com `equ`.

* `build/macros_linha.lst`:

  * Mostra, linha a linha, o endereço e os bytes gerados para cada instrução.
  * Facilita a depuração em baixo nível e o entendimento de como o código é
    organizado em memória.

Esses arquivos complementam a compreensão do funcionamento do pré-processador e
do processo de montagem no NASM.
