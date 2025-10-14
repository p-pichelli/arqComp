library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end pc_tb;

architecture sim of pc_tb is
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal pc_out       : unsigned(7 downto 0);
    signal pc_in        : unsigned(7 downto 0);
    signal write_enable : std_logic;

begin
    PC_inst: entity work.pc
        port map(
            clk          => clk,
            rst          => rst,
            write_enable => write_enable,
            pc_in        => pc_in,
            pc_out       => pc_out
        );

    Controller_inst: entity work.pc_controller
        port map(
            clk          => clk,
            rst          => rst,
            pc_out       => pc_out,
            write_enable => write_enable,
            pc_in        => pc_in
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
