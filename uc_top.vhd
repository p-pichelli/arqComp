library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_top is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        pc_value  : out unsigned(7 downto 0);
        instr_out : out unsigned(18 downto 0);
        estado    : out std_logic  --0=fetch; 1=decode/execute
    );
end entity;

architecture arch_uc_top of uc_top is
    signal pc_out_s    : unsigned(7 downto 0);
    signal pc_in_s     : unsigned(7 downto 0);
    signal pc_we_s     : std_logic;

    signal instr_s     : unsigned(18 downto 0);

    signal jump_en_s   : std_logic;
    signal jump_addr_s : unsigned(7 downto 0);
    signal estado_s    : std_logic;

    signal next_pc       : unsigned(7 downto 0);
begin
    u_pc : entity work.pc
        port map(
            clk          => clk,
            rst          => rst,
            write_enable => pc_we_s,
            pc_in        => pc_in_s,
            pc_out       => pc_out_s
        );

    u_rom : entity work.rom
        port map(
            endereco => pc_out_s,
            dado     => instr_s
        );

    u_un_ctrl : entity work.un_controle
        port map(
            clk         => clk,
            rst         => rst,
            instr       => instr_s,
            jump_en     => jump_en_s,
            jump_addr_o => jump_addr_s,
            estado_o    => estado_s
        );

    pc_we_s <= estado_s;
        
     --pc e atualizado so qnd estado = '1'
    next_pc <= jump_addr_s when (jump_en_s = '1') else (pc_out_s + 1);

    pc_in_s <= next_pc;

    pc_value  <= pc_out_s;
    instr_out <= instr_s;
    estado    <= estado_s;
end architecture;