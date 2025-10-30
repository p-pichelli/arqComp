library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(
        clk           : in  std_logic;
        rst           : in  std_logic;
        instr         : in  unsigned(18 downto 0);
        jump_en       : out std_logic;
        jump_addr_o   : out unsigned(7 downto 0);
        estado_o      : out std_logic
    );
end entity;

architecture arch_un_controle of un_controle is 
    signal opcode : unsigned(3 downto 0);
    signal estado : std_logic;
begin
    process(clk, rst)
    begin 
        if rst = '1' then 
            estado <= '0';
        elsif rising_edge(clk) then 
            estado <= not estado;
        end if;
    end process;

    estado_o <= estado;

    opcode <= instr(18 downto 15);
    jump_en     <= '1' when (estado = '1' and opcode = "1111") else '0';
    jump_addr_o <= instr(7 downto 0) when opcode = "1111" else (others => '0');
end architecture;