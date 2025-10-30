Estruturação do binário:
- Opcode: 4 bits;
- Reg de saída: 3 bits;
- Reg de entrada: 3 bits;
- Endereço ou constante: 9 bits;

Opcode|Reg saida|Reg entrada|Endereço/constante

Opcodes:
- LD: 1001;
- ADD: 0110;
- SUB: 1010;
- AND: 1100;
- OR: 1011;
- J: 1110;
- MOV: 1111;
- ST: 0011;
- NOP: 0000;

Assembly:

00: LD  ACC,5        A. carregar 5 no acumulador
01: MOV R3,ACC       A. R3 ← 5

02: LD  ACC,8        B. carregar 8 no acumulador
03: MOV R4,ACC       B. R4 ← 8

04: MOV ACC,R3       C. início: ACC ← R3
05: ADD ACC,R4       C. ACC ← ACC + R4  (ACC = R3 + R4)
06: MOV R5,ACC       C. R5 ← ACC

07: LD  ACC,1        D. preparar constante 1 no ACC
08: MOV R1,ACC       D. R1 ← 1 (registrador auxiliar para -1)
09: MOV ACC,R5       D. ACC ← R5
10: SUB ACC,R1       D. ACC ← ACC - R1  (R5-1)
11: MOV R5,ACC       D. R5 ← ACC

12: J   20           E. pular para o endereço 20

13: LD  ACC,0        F. (nunca executado) zera ACC
14: MOV R5,ACC       F. (nunca executado) R5 ← 0

15: NOP
16: NOP
17: NOP
18: NOP
19: NOP

20: MOV ACC,R5       G. endereço 20: ACC ← R5
21: MOV R3,ACC       G. R3 ← R5

22: J   04           H. Salta para passo C (endereço 04)

23: LD  ACC,0        I. (não executado) zera ACC
24: MOV R3,ACC       I. (não executado) R3 ← 0