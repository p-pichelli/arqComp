library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_top_tb is
end entity;

architecture sim of uc_top_tb is

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal pc_value  : unsigned(7 downto 0);
    signal instr_out : unsigned(18 downto 0);
    signal estado    : unsigned (1 downto 0);
begin
    dut: entity work.uc_top(arch_uc_top)
        port map(
            clk       => clk,
            rst       => rst,
            pc_value  => pc_value,
            instr_out => instr_out,
            estado    => estado
        );

    clk_proc: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    rst_proc: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait;
    end process;

    stop_proc: process
    begin
        wait for 5 us;
        wait;
    end process;
end architecture;