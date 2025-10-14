library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_top is
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;
        instr : out unsigned(18 downto 0)
    );
end entity;

architecture arch of cpu_top is
    signal pc_out_sig : unsigned(7 downto 0);
    signal pc_in_sig  : unsigned(7 downto 0);
    signal write_enable_sig : std_logic;
begin
    PC_inst: entity work.pc
        port map(
            clk          => clk,
            rst          => rst,
            write_enable => write_enable_sig,
            pc_in        => pc_in_sig,
            pc_out       => pc_out_sig
        );

    Controller_inst: entity work.pc_controller
        port map(
            clk          => clk,
            rst          => rst,
            pc_out       => pc_out_sig,
            write_enable => write_enable_sig,
            pc_in        => pc_in_sig
        );

    ROM_inst: entity work.rom
        port map(
            endereco => pc_out_sig,
            dado     => instr
        );
end architecture;
