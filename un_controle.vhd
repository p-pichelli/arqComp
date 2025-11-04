library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(
        clk           : in  std_logic;
        rst           : in  std_logic;
        instr         : in  unsigned(18 downto 0);
        estado_i      : in  unsigned (1 downto 0);
        jump_en       : out std_logic;
        jump_addr_o   : out unsigned(7 downto 0)
    );
end entity;

architecture arch_un_controle of un_controle is 
    signal opcode : unsigned(3 downto 0);
begin
    opcode <= instr(18 downto 15);
    jump_en     <= '1' when (estado_i = "01" and opcode = "1110") else '0';
    jump_addr_o <= instr(7 downto 0) when opcode = "1110" else (others => '0');
end architecture;