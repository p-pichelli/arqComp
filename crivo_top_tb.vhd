library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crivo_top_tb is
end entity;

architecture sim of crivo_top_tb is
    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal pc_obs : unsigned(7 downto 0);
    signal acc_obs: unsigned(15 downto 0);
    signal out_obs: unsigned(15 downto 0);
begin
    dut: entity work.crivo_top(arch_crivo_top)
        port map(
            clk          => clk,
            rst          => rst,
            primo_out => out_obs,
            accum_out => acc_obs,
            pc_out => pc_obs
        );

    clk_proc: process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    rst_proc: process
    begin
        rst <= '1';
        wait for 5*CLK_PERIOD;
        rst <= '0';
        wait;
    end process;

    stop_proc: process
    begin
        wait for 500 us; 
        wait;
    end process;
end architecture;