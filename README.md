# Software Básico – Exercícios em NASM

Este repositório reúne implementações e experimentos da disciplina de **Software Básico**,
utilizando o montador **NASM (Netwide Assembler)** e, em alguns casos, integração com a
linguagem **C**.

O objetivo é documentar passo a passo a construção dos programas, com commits bem
granulares, para servir como material de estudo e histórico de evolução.

---

## Pré-requisitos

- Sistema operacional baseado em Unix (ex.: Linux / Manjaro).
- NASM instalado.
- GCC instalado (para os exemplos que integram C + NASM).

---

## Estrutura do repositório

- `preprocessador/`  
  Exemplos relacionados ao **pré-processador do NASM**, com uso de:
  - macros de linha,
  - constantes simbólicas (`equ`, `%define`, `%assign`),
  - condicionais de pré-processamento (`%if`, `%ifdef`),
  - geração de código expandido (`.pre`) e listagens (`.lst`).

- `c_nasm/`  
  Exemplos de integração entre **C e NASM**, mostrando como funções em assembly podem
  ser chamadas a partir de programas em C, utilizando bibliotecas padrão (como `stdio.h`)
  e funções da libc (ex.: `puts`).

Cada pasta possui o seu próprio `README.md` explicando:

- o contexto do exercício,
- as funções implementadas,
- os comandos de compilação/execução,
- e, quando aplicável, o uso de `Makefile`.

---

## Como utilizar

Na raiz do repositório:

```bash
git clone https://github.com/Mathweuzz/SoftwareBasico-NASM.git
cd SoftwareBasico-NASM
````

Depois, siga as instruções específicas em:

* `preprocessador/README.md`
* `c_nasm/README.md`

