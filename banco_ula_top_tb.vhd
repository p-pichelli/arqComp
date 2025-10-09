library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_ula_top_tb is
end entity;

architecture sim of banco_ula_top_tb is
    constant PERIOD : time := 20 ns;

    signal clk             : std_logic := '0';
    signal rst             : std_logic := '0';
    signal controle        : std_logic_vector(1 downto 0) := (others => '0');
    signal sel_read        : std_logic_vector(2 downto 0) := (others => '0');
    signal sel_write       : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_wr_en       : std_logic := '0';
    signal acc_wr_en       : std_logic := '0';
    signal ld_immediate    : std_logic := '0';
    signal immediate_value : unsigned(15 downto 0) := (others => '0');
    signal accum_out       : unsigned(15 downto 0);
    signal alu_out         : unsigned(15 downto 0);
    signal zero_flag       : std_logic;
begin
    dut : entity work.banco_ula_top(arch_banco_ula_top)
        port map (
            clk              => clk,
            reset              => rst,
            controleoperacao => controle,
            sel_read_reg     => sel_read,
            sel_write_reg    => sel_write,
            reg_wr_en        => reg_wr_en,
            acc_wr_en        => acc_wr_en,
            ld_immediate     => ld_immediate,
            immediate_value  => immediate_value,
            accum_out        => accum_out,
            alu_out          => alu_out,
            zero_flag        => zero_flag
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for PERIOD/2;
            clk <= '1';
            wait for PERIOD/2;
        end loop;
    end process;

    rst_process : process
    begin
        rst <= '1';
        wait for 3 * PERIOD;
        rst <= '0';
        wait;
    end process;

    stim_proc : process
    begin
        controle        <= "00";
        sel_read        <= "000";
        sel_write       <= "000";
        reg_wr_en       <= '0';
        acc_wr_en       <= '0';
        ld_immediate    <= '0';
        immediate_value <= (others => '0');

        wait until rst = '0';
        wait for PERIOD;

        -- carrega 0x00-3 no acumulador
        immediate_value <= to_unsigned(3, 16);
        ld_immediate    <= '1';
        acc_wr_en       <= '1';
        wait until rising_edge(clk);
        acc_wr_en       <= '0';
        ld_immediate    <= '0';

        -- r1 recebe o valor do acc
        sel_write <= "001"; --endereco de r1
        reg_wr_en <= '1';
        wait until rising_edge(clk);
        reg_wr_en <= '0';
        sel_write <= "000";

        -- atribui 0x0002 no acumulador
        immediate_value <= to_unsigned(2, 16);
        ld_immediate    <= '1';
        acc_wr_en       <= '1';
        wait until rising_edge(clk);
        acc_wr_en       <= '0';
        ld_immediate    <= '0';

        -- add A, r1
        sel_read  <= "001";
        controle  <= "00";  --op de adicao
        acc_wr_en <= '1';
        wait until rising_edge(clk);
        acc_wr_en <= '0';

    
        sel_write <= "010";
        reg_wr_en <= '1';
        wait until rising_edge(clk);
        reg_wr_en <= '0';
        sel_write <= "000";

        immediate_value <= to_unsigned(5, 16);
        ld_immediate    <= '1';
        acc_wr_en       <= '1';
        wait until rising_edge(clk);
        acc_wr_en       <= '0';
        ld_immediate    <= '0';

        -- sub A, r2 (tem q dar -5 ou 0xfffb na saida da ula)
        sel_read  <= "010";
        controle  <= "01";  --op de subtr
        acc_wr_en <= '1';
        wait until rising_edge(clk);
        acc_wr_en <= '0';

        wait for 10 * PERIOD;
        wait;
    end process;

end architecture sim;
