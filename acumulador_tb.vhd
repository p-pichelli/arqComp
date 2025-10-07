library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador_tb is
end acumulador_tb;

architecture sim of acumulador_tb is
    component acumulador is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            write_enable: in  std_logic;
            data_in     : in  unsigned(15 downto 0);
            data_out    : out unsigned(15 downto 0)
        );
    end component;

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal write_enable : std_logic := '0';
    signal data_in      : unsigned(15 downto 0) := (others => '0');
    signal data_out     : unsigned(15 downto 0);
begin
    DUT: acumulador
        port map (
            clk          => clk,
            rst          => rst,
            write_enable => write_enable,
            data_in      => data_in,
            data_out     => data_out
        );

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        data_in <= to_unsigned(25, 16);
        write_enable <= '1';
        wait for 10 ns;
        write_enable <= '0';
        wait for 10 ns;

        data_in <= to_unsigned(100, 16);
        wait for 10 ns;

        write_enable <= '1';
        wait for 10 ns;
        write_enable <= '0';
        data_in <= to_unsigned(0, 16);

        wait for 30 ns;

        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 30 ns;

        wait;
    end process;
end sim;
