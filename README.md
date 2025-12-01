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
- BVC: 0111;
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
- BVC (branch if overflow clear) : fará um branch para o endereço especificado caso o flag do overflow esteja em 0: BVC 4;
- NOP: no operation, não faz nada:
  NOP;

---- PASSO 1: colocar os valores de 1 a 32 ----

; 00
LD ACC, 1 ; i = 1

; 01
MOV R1, ACC ; R1 = 1

; 02
LD ACC, 32 ; ACC = 32

; 03
MOV R2, ACC ; R2 = 32

; INICIO DO LOOP (preenchimento RAM[1..32])

; 04
LD ACC, 0 ; ACC = 0

; 05
MOV R3, ACC ; R3 = 0

; 06
ADD R1, ACC ; R1 = R1 + ACC ; ACC = i + 1 (pelo comentário)

; 07
MOV R1, ACC ; R1 = ACC

; 08
MOV ACC, R1 ; ACC = R1

; 09
SUB R2, ACC ; R2 = R2 - ACC ; ACC = ACC - R2 (comentário)

; 10
MOV R2, ACC ; R2 = ACC

; 11
ST ACC, ACC ; RAM[ACC] = ACC (endereço=ACC, dado=ACC)

; 12
SUB R3, ACC ; R3 = R3 - ACC ; ativar a flag negative

; 13
BLT R3, ACC, 4 ; BLT, R2, ACC, end4 (pelo seu comentário)

; 14
NOP

---- PASSO 2: eliminar os múltiplos de 2, 3, 5, 7, 11 ----

; **\*** eliminar múltiplos de 2

; 15
LD ACC, 2 ; LD ACC, 2

; 16
MOV R1, ACC ; MOV R1, ACC

; INICIO DO LOOP (múltiplos de 2)

; 17
LD ACC, 2 ; LD ACC, 2

; 18
ADD R1, ACC ; ADD R1, ACC

; 19
MOV R1, ACC ; MOV R1, ACC

; 20
ST ACC, R3 ; ST ACC, R3 ; RAM[ACC] = R3 = 0

; 21
MOV R2, ACC ; MOV R2, ACC

; 22
LD ACC, 32 ; LD ACC, 32

; 23
SUB R2, ACC ; SUB R2, ACC

; 24
BLT R2, ACC, 17 ; BLT R2, ACC ; end 17

; **\*** eliminar múltiplos de 3

; 25
LD ACC, 3 ; LD ACC, 3

; 26
MOV R1, ACC ; MOV R1, ACC

; INICIO DO LOOP (múltiplos de 3)

; 27
LD ACC, 3 ; LD ACC, 3

; 28
ADD R1, ACC ; ADD R1, ACC

; 29
MOV R1, ACC ; MOV R1, ACC

; 30
ST ACC, R3 ; ST ACC, R3 ; RAM[ACC] = R3 = 0

; 31
MOV R2, ACC ; MOV R2, ACC

; 32
LD ACC, 32 ; LD ACC, 32

; 33
SUB R2, ACC ; SUB R2, ACC

; 34
BLT R2, ACC, 27 ; BLT R2, ACC ; end 27

; **\*** eliminar múltiplos de 5

; 35
LD ACC, 5 ; LD ACC, 5

; 36
MOV R1, ACC ; MOV R1, ACC

; INICIO DO LOOP (múltiplos de 5)

; 37
LD ACC, 5 ; LD ACC, 5

; 38
ADD R1, ACC ; ADD R1, ACC

; 39
MOV R1, ACC ; MOV R1, ACC

; 40
ST ACC, R3 ; ST ACC, R3 ; RAM[ACC] = R3 = 0

; 41
MOV R2, ACC ; MOV R2, ACC

; 42
LD ACC, 32 ; LD ACC, 32

; 43
SUB R2, ACC ; SUB R2, ACC

; 44
BLT R2, ACC, 37 ; BLT R2, ACC ; end 37

; **\*** eliminar múltiplos de 7

; 45
LD ACC, 7 ; LD ACC, 7

; 46
MOV R1, ACC ; MOV R1, ACC

; INICIO DO LOOP (múltiplos de 7)

; 47
LD ACC, 7 ; LD ACC, 7

; 48
ADD R1, ACC ; ADD R1, ACC

; 49
MOV R1, ACC ; MOV R1, ACC

; 50
ST ACC, R3 ; ST ACC, R3 ; RAM[ACC] = R3 = 0

; 51
MOV R2, ACC ; MOV R2, ACC

; 52
LD ACC, 32 ; LD ACC, 32

; 53
SUB R2, ACC ; SUB R2, ACC

; 54
BLT R2, ACC, 47 ; BLT R2, ACC ; 47

; **\*** eliminar múltiplos de 11

; 55
LD ACC, 11 ; LD ACC, 11

; 56
MOV R1, ACC ; MOV R1, ACC

; INICIO DO LOOP (múltiplos de 11)

; 57
LD ACC, 11 ; LD ACC, 11

; 58
ADD R1, ACC ; ADD R1, ACC

; 59
MOV R1, ACC ; MOV R1, ACC

; 60
ST ACC, R3 ; ST ACC, R3 ; RAM[ACC] = R3 = 0

; 61
MOV R2, ACC ; MOV R2, ACC

; 62
LD ACC, 32 ; LD ACC, 32

; 63
SUB R2, ACC ; SUB R2, ACC

; 64
BLT R2, ACC, 57 ; BLT R2, ACC ; 57

---- PASSO 3: LOOP FINAL ----

; 65
LD ACC, 1 ; LD ACC, #1

; 66
MOV R1, ACC ; R1 = ACC

; 67
LD ACC, 32 ; ACC = 32

; 68
MOV R2, ACC ; R2 = 32

; INICIO DO LOOP FINAL

; 69
LD ACC, 0 ; ACC = 0

; 70
MOV R3, ACC ; R3 = 0

; 71
ADD R1, ACC ; ADD R1, ACC ; ACC = i + 1

; 72
MOV R1, ACC ; MOV R1, ACC

; 73
MOV ACC, R1 ; MOV ACC, R1

; 74
SUB R2, ACC ; SUB R2, ACC ; ACC = ACC - R2

; 75
MOV R2, ACC ; MOV R2, ACC

; 76
SUB R3, ACC ; SUB R3, ACC ; ativar a flag negative

; 77
BLT R3, ACC, 69 ; BLT R2, ACC, end69 (pelo comentário)

; 78
NOP
