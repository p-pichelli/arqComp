Estruturação do binário:
- Opcode: 4 bits;
- Reg de saída: 3 bits;
- Reg de entrada: 3 bits;
- Endereço ou constante: 9 bits, exclusivamente para LD, o MSB aponta se é endereço ou constante;

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
- LD: Carrega no acumulador uma constante ou endereço: 
LD ACC, Constante/Endereço;
- ADD: Soma o ACC e um Reg, salvando no Reg:
ADD ACC, R3 e ADD R3, ACC (ambos salvam no R3 pelo fato do ACC ser sempre a entrada B da ULA);
- SUB: Subtrai ACC de um Reg, salvando no Reg:
SUB ACC, R4 e SUB R4, ACC (ambos salvam no R4);
- AND: Operação de AND entre um Reg e o ACC:
AND R3, ACC e AND ACC, R3;
- OR: Operação de OR entre ACC e um Reg:
OR R1, ACC e OR ACC, R1;
- J: Escreve no PC um determinado endereço, sendo esse o próximo a ser executado:
J 4;
- MOV: Copia um Reg para o ACC ou vice-versa:
MOV R3, ACC (R3 recebe ACC) e MOV ACC, R3 (ACC recebe R3);
- ST: Escreve um Reg no endereço salvo no ACC ou vice-versa:
ST R3, ACC (escreve ACC no endereço do conteúdo de R3) e ST ACC, R3 (escreve R3 no endereço do conteúdo de ACC);
- NOP: no operation, não faz nada:
NOP;


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