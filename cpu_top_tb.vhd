library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_top_tb is
end cpu_top_tb;

architecture sim of cpu_top_tb is
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal instr        : unsigned(18 downto 0);
begin
    DUT: entity work.cpu_top
        port map(
            clk   => clk,
            rst   => rst,
            instr => instr
        );

    clk_process: process
    begin
        loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 200 ns;
        wait;
    end process;
end sim;
