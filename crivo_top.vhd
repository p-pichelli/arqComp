library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crivo_top is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        primo_out : out unsigned(15 downto 0); 
        pc_out    : out unsigned(7 downto 0);
        intr_out  : out unsigned(18 downto 0);
        accum_out : out unsigned(15 downto 0);
        debug_bit: out std_logic
    );
end entity;

architecture arch_crivo_top of crivo_top is
    signal pc_s        : unsigned(7 downto 0);
    signal instr_s     : unsigned(18 downto 0);
    signal estado_s    : unsigned(1 downto 0);
    signal acc_s       : unsigned(15 downto 0);
    signal alu_s       : unsigned(15 downto 0);
    signal z_s, ov_s, n_s, ctz5_s : std_logic;
begin
    u_proc : entity work.processador(arch_processador)
        port map(
            clk              => clk,
            rst              => rst,
            pc_out           => pc_s,
            instr_out        => instr_s,
            estado_out       => estado_s,
            accum_out        => acc_s,
            alu_out          => alu_s,
            zero_flag_out    => z_s,
            overflow_flag_out=> ov_s,
            negative_flag_out=> n_s,
            ctz5_flag_out    => ctz5_s,
            debug_bit => debug_bit
        );

    primo_out <= acc_s;
    accum_out <= acc_s;
    pc_out <= pc_s;
end architecture;