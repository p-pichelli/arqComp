library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture sim of processador_tb is
    constant CLK_PERIOD : time := 10 ns;
    
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '0';
    signal pc_obs         : unsigned(7 downto 0);
    signal instr_obs      : unsigned(18 downto 0);
    signal estado_obs     : unsigned(1 downto 0);
    signal accum_obs      : unsigned(15 downto 0);
    signal alu_obs        : unsigned(15 downto 0);
    signal zero_flag_obs  : std_logic;
    
begin
    dut: entity work.processador(arch_processador)
        port map(
            clk           => clk,
            rst           => rst,
            pc_out        => pc_obs,
            instr_out     => instr_obs,
            estado_out    => estado_obs,
            accum_out     => accum_obs,
            alu_out       => alu_obs,
            zero_flag_out => zero_flag_obs
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
        wait for 5 * CLK_PERIOD;
        rst <= '0';
        wait;
    end process;
    
    obs_proc: process
    begin
        wait for 10 us;  
        wait;
    end process;
    
end architecture;