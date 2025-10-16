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
      0 => "0001000000000000000",
      1 => "0010000000000000001",
      2 => "0011000000000000010",
      3 => "0100000000000000011",
      4 => "0101000000000000100",
      5 => "1111000000000000010", --jump para endereco 2
      6 => "0110000000000000110",
      7 => "0111000000000000111",
      8 => "1000000000000001000",
      9 => "1001000000000001001",
      others => (others => '0')
   );
begin
   dado <= conteudo_rom(to_integer(endereco));
end architecture;
