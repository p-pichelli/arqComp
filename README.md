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
- BLT: 0101;
- BGT: 1000;
- NOP: 0000;

Assembly:
- LD: Carrega no acumulador uma constante ou endereço: 
LD ACC, Constante/Endereço;
- ADD: Soma o ACC e um Reg, salvando no primeiro termo:
ADD ACC, R3 e ADD R3, ACC;
- SUB: Subtrai ACC de um Reg, salvando no primeiro termo:
SUB ACC, R4 e SUB R4, ACC;
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
- BLT (branch if lesser than): fará um branch para o endereço especificado, terceiro termo, se o valor no primeiro termo, um Reg, for menor que o segundo, o ACC: BLT R3, ACC, 2;
- BGT (branch if greater than): fará um branch para o endereço especificado, terceiro termo, se o valor no primeiro termo, um Reg, for maior que o segundo, o ACC: BGT R3, ACC, 10;
- NOP: no operation, não faz nada:
NOP;


00: LD  ACC,0        A. carregar 0 no acumulador
01: MOV R3,ACC       A. R3 ← 0

02: LD  ACC,0        B. carregar 0 no acumulador
03: MOV R4,ACC       B. R4 ← 0

04: MOV ACC,R3       C. início: ACC ← R3
05: ADD ACC,R4       C. ACC ← ACC + R4  (ACC = R3 + R4)
06: MOV R4,ACC       C. R4 ← ACC

07: LD  ACC,1        D. carregar 1 no acumulador
08: ADD R3,ACC       D. R3 + 1

09: MOV ACC,30       E. carregar 30 no acumulador
10: BLT R3,ACC,4     E. pula para o endereço 4 se R3 < ACC

11: MOV ACC,R4       F. ACC ← R4
12: MOV R5,ACC       E. R5 ← ACC