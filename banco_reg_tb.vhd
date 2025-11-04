library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_tb is
end entity;

architecture sim of banco_reg_tb is
    constant WIDTH       : natural := 16;
    constant CLK_PERIOD  : time    := 10 ns;

    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal wr_en         : std_logic := '0';

    signal in_write_reg  : std_logic_vector(2 downto 0) := (others => '0');
    signal in_read_reg   : std_logic_vector(2 downto 0) := (others => '0');
    signal in_write_data : unsigned(WIDTH-1 downto 0)    := (others => '0');
    signal out_read_data : unsigned(WIDTH-1 downto 0);

    type mem_t is array (0 to 5) of unsigned(WIDTH-1 downto 0);
    constant WRITE_VALS : mem_t := (
        x"1111", x"2222", x"3333", x"4444", x"5555", x"6666"
    );

    -- Função auxiliar para converter índice 0..5 em std_logic_vector(2 downto 0)
    function idx3(i : integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(i, 3));
    end function;

begin
    -- DUT
    DUT: entity work.banco_reg(arch_banco_reg)
        port map (
            in_write_reg  => in_write_reg,
            in_read_reg   => in_read_reg,
            in_write_data => in_write_data,
            clock         => clk,
            reset         => rst,
            wr_en         => wr_en,
            out_read_data => out_read_data
        );

    -- Clock 100 MHz (10 ns)
    clk_proc : process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Reset inicial
    rst_proc : process
    begin
        rst <= '1';
        wait for 3*CLK_PERIOD;  -- segura reset por 3 ciclos
        rst <= '0';
        wait;
    end process;

    -- Estímulos e verificações
    stim_proc : process
    begin
        -- Garante estado inicial estável
        wr_en         <= '1';
        in_write_reg  <= "111";  -- nenhum registrador é escrito (seletor inválido)
        in_read_reg   <= (others => '0');
        in_write_data <= (others => '0');
        wait for 2*CLK_PERIOD;

        -- Escrita em cada um dos 6 registradores
        for i in 0 to 5 loop
            -- prepara dados e endereço
            in_write_data <= WRITE_VALS(i);
            in_write_reg  <= idx3(i);    -- seleciona qual registrador escreverá
            wait until rising_edge(clk); -- captura ocorre nesta borda

            -- desabilita escrita (nenhum wr_enX ativo quando seletor é 110/111)
            in_write_reg <= "111";
            wait until rising_edge(clk); -- separa ciclos para evitar reescritas
        end loop;

        -- Leitura e checagem de cada registrador
        for i in 0 to 5 loop
            in_read_reg <= idx3(i);
            wait for 1 ns; -- tempo de propagação combinacional do mux de leitura
            assert out_read_data = WRITE_VALS(i)
                report "Leitura incorreta no reg " & integer'image(i) &
                       ": got=" & to_hstring(out_read_data) &
                       " exp=" & to_hstring(WRITE_VALS(i))
                severity error;
        end loop;

        -- Checa que leituras com códigos inválidos retornam zero (others)
        in_read_reg <= "110"; wait for 1 ns;
        assert out_read_data = to_unsigned(0, WIDTH)
            report "Mux de leitura (110) deveria ser zero, got=" & to_hstring(out_read_data)
            severity error;

        in_read_reg <= "111"; wait for 1 ns;
        assert out_read_data = to_unsigned(0, WIDTH)
            report "Mux de leitura (111) deveria ser zero, got=" & to_hstring(out_read_data)
            severity error;

        report "Teste do banco de registradores concluido com sucesso" severity note;
        wait;
    end process;

end architecture;