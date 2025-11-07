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
      -- 05: ADD ACC,R4 - ACC ? ACC + R4 (ACC = R3 + R4)
      5 => "0110" & "000" & "100" & "000000000",
      -- 06: MOV R4,ACC - R4 ? ACC (salva soma em R4)
      6 => "1111" & "100" & "000" & "000000000",
      
      -- 07: LD ACC,1 - carregar 1 no acumulador
      7 => "1001" & "000" & "000" & "100000001",
      -- 08: ADD R3,ACC - R3 ? R3 + ACC (incrementa R3)
      8 => "0110" & "011" & "000" & "000000000",
      
      -- 09: LD ACC,30 - carregar 30 no acumulador
      9 => "1001" & "000" & "000" & "100011110",
      -- 10: BLT R3,ACC,4 - pula para endereço 4 se R3 < ACC
      -- BLT compara R3 com ACC, e salta para endereço nos 9 LSBs se R3 < ACC
      10 => "0101" & "011" & "000" & "000000100",
      
      -- 11: MOV ACC,R4 - ACC ? R4 (carrega resultado final)
      11 => "1111" & "000" & "100" & "000000000",
      -- 12: MOV R5,ACC - R5 ? ACC (salva em R5)
      12 => "1111" & "101" & "000" & "000000000",
      
      -- 13: fim - pode colocar NOP ou loop infinito
      13 => "0000000000000000000",
      
      others => "0000000000000000000"
   );
begin
   dado <= conteudo_rom(to_integer(endereco));
end architecture;