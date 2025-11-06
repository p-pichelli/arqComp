library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(
        clk           : in  std_logic;
        rst           : in  std_logic;
        instr         : in  unsigned(18 downto 0);
        estado_i      : in  unsigned (1 downto 0);
        zero_flag_i   : in  std_logic;
        negative_flag_i : in  std_logic;
        overflow_flag_i : in  std_logic;
        jump_en       : out std_logic;
        jump_addr_o   : out unsigned(7 downto 0)
    );
end entity;


architecture arch_un_controle of un_controle is 
    signal opcode : unsigned(3 downto 0);
    signal bgt_cond : std_logic;
    signal blt_cond : std_logic;

begin
    opcode <= instr(18 downto 15);

    bgt_cond <= '1' when (zero_flag_i = '0' and negative_flag_i = overflow_flag_i) else '0';
    blt_cond <= '1' when (zero_flag_i = '0' and negative_flag_i /= overflow_flag_i) else '0';

    jump_en <= '1' when (estado_i = "10" and (
                          opcode = "1110" or  -- JMP incondicional
                          (opcode = "1000" and bgt_cond = '1') or  -- BGT condicional
                          (opcode = "0101" and blt_cond = '1')     -- BLT condicional
                         )) else '0';

    jump_addr_o <= instr(7 downto 0) when (opcode = "1110" or opcode = "1000") else (others => '0');
end architecture;
