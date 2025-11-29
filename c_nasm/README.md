# Exemplo de integração C + NASM

Este diretório contém exemplos de integração entre a linguagem C e o
montador **NASM**, utilizando a convenção de chamada do Linux x86_64.

A ideia é mostrar, passo a passo, como:

- Escrever funções em assembly NASM.
- Declarar essas funções em C.
- Compilar e ligar tudo usando `gcc`.
- Utilizar funções da biblioteca padrão de C (por exemplo, `stdio.h`) em
  conjunto com código em assembly.

---

## Estrutura (planejada)

- `main.c`  
  Arquivo principal em C, responsável pela função `main`, que chama
  funções implementadas em assembly.

- `funcoes.asm`  
  Implementação, em NASM, de funções que serão chamadas a partir do C.

- `Makefile` (opcional, em passos posteriores)  
  Facilita o processo de compilação e linkedição.

Cada passo será registrado com um commit específico, para que o histórico
sirva como material de estudo.
