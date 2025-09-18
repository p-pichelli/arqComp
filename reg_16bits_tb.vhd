library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_16bits_tb is 
end reg_16bits_tb;


architecture arch_reg_16bits_tb of reg_16bits_tb is
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, reset, write_enable  : std_logic;
    signal   data_in     : unsigned(15 downto 0) := "0000000000000000";   
    signal   data_out    : unsigned(15 downto 0);


    begin
        DUT: entity work.reg_16bits(arch_reg_16bits) 
            port map(clk => clk, rst => reset, wr_en => write_enable, data_in => data_in, data_out => data_out);


        reset_global: process 
        begin
            reset <= '1';
            wait for period_time*2;
            reset <= '0';
            wait;
        end process;

        sim_time_proc: process 
        begin
            wait for 10 us; --duracao da simulacao
            finished <= '1';
            wait;
        end process;

        clk_proc: process 
        begin
            while finished /= '1' loop
                clk <= '0';
                wait for period_time/2;
                clk <= '1';
                wait for period_time/2;
                end loop;
                wait;
        end process;

        --casos de teste aqui
        process 
        begin
            wait for 200 ns;
            write_enable <= '0';
            data_in <= "1111111111111111";
            wait for 100 ns;
            write_enable <= '1';
            data_in <= "1010101010101010";
            wait for 100 ns;
            data_in <= "0000000010001101";
            wait for 100 ns;
            write_enable <= '0';
            data_in <= "0000000011000111";
            wait;
        end process;

end architecture;