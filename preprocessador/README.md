# Pré-processador do NASM

Esta pasta contém um exemplo de programa em NASM focado no uso do **pré-processador**,
com ênfase em macros de linha e diretivas vistas em aula.

## Objetivo

- Demonstrar o uso de:
  - Definição de constantes (`equ`, `%define`).
  - Atribuições no pré-processador (`%assign`).
  - Condicionais de pré-processamento (`%if`, `%ifdef`, `%else`, `%endif`).
- Gerar saídas que permitam visualizar como o código é expandido:
  - Código pré-processado (sem macros).
  - Arquivo *listing* com a expansão das diretivas.

## Arquivos (planejado)

- `macros_linha.asm`  
  Programa principal em NASM que utiliza diversas construções do pré-processador.

- `build/`  
  Diretório (criado durante a compilação) para armazenar:
  - Objetos (`.o`)
  - Executáveis
  - Código pré-processado (`.pre`)
  - Listagens (`.lst`)

A construção e uso destes arquivos serão detalhados conforme os passos forem sendo implementados e versionados.
