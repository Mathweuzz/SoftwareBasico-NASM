# Software Básico – Exercícios em NASM

Este repositório reúne implementações e experimentos da disciplina de Software Básico,
utilizando **NASM (Netwide Assembler)** e, em alguns casos, integração com a linguagem **C**.

O objetivo é documentar passo a passo a construção dos programas, com commits bem
granulares, para servir como material de estudo e histórico de evolução.

## Estrutura do repositório

- `preprocessador/`  
  Exemplos relacionados ao **pré-processador do NASM**, com uso de macros de linha,
  constantes simbólicas, condicionais de pré-processamento, geração de código expandido etc.

- `c_nasm/`  
  Exemplos de integração entre **C e NASM**, mostrando como funções em assembly podem
  ser chamadas a partir de programas em C, utilizando bibliotecas padrão (como `stdio.h`).

Cada pasta terá o seu próprio `README.md` explicando o contexto, os comandos de compilação e detalhes de implementação.
