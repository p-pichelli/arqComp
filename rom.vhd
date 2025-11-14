library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port(
      endereco : in  unsigned(7 downto 0);
      dado     : out unsigned(18 downto 0)
   );
end entity;

architecture a_rom of rom is
   type mem is array (0 to 255) of unsigned(18 downto 0);
   
   constant conteudo_rom : mem := (
     -- 00: LD ACC,0 - carregar 0 no acumulador
      0 => "1001" & "000" & "000" & "100000000",
      -- 01: MOV R3,ACC - R3 ? ACC (R3 = 0)
      1 => "1111" & "011" & "000" & "000000000",
      
      -- 02: LD ACC,0 - carregar 0 no acumulador
      2 => "1001" & "000" & "000" & "100000000",
      -- 03: MOV R4,ACC - R4 ? ACC (R4 = 0)
      3 => "1111" & "100" & "000" & "000000000",
      
      -- 04: MOV ACC,R3 - início do loop: ACC ? R3
      4 => "1111" & "000" & "011" & "000000000",

      5 => "0000" & "000" & "000" & "000000000",
      -- 06: ADD ACC,R4 - ACC ? ACC + R4 (ACC = R3 + R4)
      6 => "0110" & "000" & "100" & "000000000",
      7 => "0000" & "000" & "000" & "000000000",

      -- 06: MOV R4,ACC - R4 ? ACC (salva soma em R4)
      8 => "1111" & "100" & "000" & "000000000",
      
      -- 07: LD ACC,1 - carregar 1 no acumulador
      9 => "1001" & "000" & "000" & "100000001",
      10 => "0000" & "000" & "000" & "000000000",

      -- 08: ADD ACC,R3 - R3 ? R3 + ACC (ACC = R3 + ACC) (incrementa R3)
      11 => "0110" & "000" & "011" & "000000000",
      12 => "0000" & "000" & "000" & "000000000",
      -- MOV R3, ACC
      13 => "1111" & "011" & "000" & "000000000",


      
      -- 09: LD ACC,30 - carregar 30 no acumulador
      14 => "1001" & "000" & "000" & "100011110",
      -- 10: BLT R3,ACC,4 - pula para endereço 4 se R3 < ACC
      -- BLT compara R3 com ACC, e salta para endereço nos 9 LSBs se R3 < ACC
      15 => "0000" & "000" & "000" & "000000000",
      16 => "0101" & "000" & "011" & "000000100",
      
      -- 11: MOV ACC,R4 - ACC ? R4 (carrega resultado final)
      17 => "1111" & "000" & "100" & "000000000",
      -- 12: MOV R5,ACC - R5 ? ACC (salva em R5)
      18 => "1111" & "101" & "000" & "000000000",
      
      -- 13: fim - pode colocar NOP ou loop infinito
      19 => "0000000000000000000",
      
      others => "0000000000000000000"
   );
begin
   dado <= conteudo_rom(to_integer(endereco));
end architecture;