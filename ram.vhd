library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
   port(
      clk      : in  std_logic;
      wr_en    : in  std_logic;
      endereco : in  unsigned(7 downto 0);    
      dado_in  : in  unsigned(15 downto 0);
      dado_out : out unsigned(15 downto 0)
   );
end entity;

architecture a_ram of ram is
   type mem_t is array (0 to 255) of unsigned(15 downto 0);
   signal conteudo_ram : mem_t := (others => (others => '0'));
begin
   process(clk)
   begin
      if rising_edge(clk) then
         if wr_en = '1' then
            conteudo_ram(to_integer(endereco)) <= dado_in;
         end if;
         dado_out <= conteudo_ram(to_integer(endereco));
      end if;
   end process;
end architecture;