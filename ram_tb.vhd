library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end entity;

architecture sim of ram_tb is
    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal wr_en     : std_logic := '0';
    signal addr      : unsigned(6 downto 0) := (others => '0');
    signal dado_in   : unsigned(15 downto 0) := (others => '0');
    signal dado_out  : unsigned(15 downto 0);

    signal tmp_a, tmp_b, tmp_c, tmp_d : unsigned(15 downto 0) := (others => '0');
begin
    dut: entity work.ram(a_ram)
        port map(
            clk      => clk,
            endereco => addr,
            wr_en    => wr_en,
            dado_in  => dado_in,
            dado_out => dado_out
        );

    -- clock
    clk_proc : process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc : process
    begin
        -- fase 0: init
        wr_en   <= '0';
        addr    <= (others => '0');
        dado_in <= (others => '0');
        wait for 5*CLK_PERIOD;

        ----------------------------------------------------------------
        -- Fase 1: várias escritas em endereços bem espaçados
        ----------------------------------------------------------------
        -- Usar valores ?esquisitos?, não iguais ao endereço

        -- Escrita 1: endereço 5, dado 0x1234
        addr    <= to_unsigned(5, 7);
        dado_in <= x"1234";
        wr_en   <= '1';
        wait for CLK_PERIOD;
        wr_en   <= '0';

        -- Escrita 2: endereço 42, dado 0xABCD
        wait for 2*CLK_PERIOD;
        addr    <= to_unsigned(42, 7);
        dado_in <= x"ABCD";
        wr_en   <= '1';
        wait for CLK_PERIOD;
        wr_en   <= '0';

        -- Escrita 3: endereço 100, dado 0x0F0F
        wait for 3*CLK_PERIOD;
        addr    <= to_unsigned(100, 7);
        dado_in <= x"0F0F";
        wr_en   <= '1';
        wait for CLK_PERIOD;
        wr_en   <= '0';

        -- Escrita 4: endereço 17, dado 0x55AA
        wait for 2*CLK_PERIOD;
        addr    <= to_unsigned(17, 7);
        dado_in <= x"55AA";
        wr_en   <= '1';
        wait for CLK_PERIOD;
        wr_en   <= '0';

        ----------------------------------------------------------------
        -- Fase 2: ?sujar? barramentos com outros valores antes de ler
        ----------------------------------------------------------------
        -- Evita o clássico erro de ler logo em seguida a escrita

        -- Joga valores aleatórios em dado_in e muda endereço sem wr_en
        wait for 5*CLK_PERIOD;
        tmp_a   <= x"DEAD";
        tmp_b   <= x"BEEF";
        tmp_c   <= x"CAFE";
        tmp_d   <= x"0123";

        dado_in <= tmp_a;
        addr    <= to_unsigned(63, 7);  -- endereço que nunca escrevemos
        wait for 2*CLK_PERIOD;

        dado_in <= tmp_b;
        addr    <= to_unsigned(7, 7);   -- outro endereço não usado
        wait for 2*CLK_PERIOD;

        dado_in <= tmp_c;
        addr    <= to_unsigned(0, 7);
        wait for 2*CLK_PERIOD;

        dado_in <= tmp_d;
        addr    <= to_unsigned(126, 7);
        wait for 2*CLK_PERIOD;

        ----------------------------------------------------------------
        -- Fase 3: leituras dos endereços onde escrevemos
        ----------------------------------------------------------------
        -- Agora sim, só leitura, olhando dado_out no waveform

        -- Leitura endereço 5 (espera-se 0x1234)
        addr <= to_unsigned(5, 7);
        wait for 2*CLK_PERIOD;  -- dá tempo da RAM propagar

        -- Leitura endereço 42 (espera-se 0xABCD)
        addr <= to_unsigned(42, 7);
        wait for 2*CLK_PERIOD;

        -- Leitura endereço 100 (espera-se 0x0F0F)
        addr <= to_unsigned(100, 7);
        wait for 2*CLK_PERIOD;

        -- Leitura endereço 17 (espera-se 0x55AA)
        addr <= to_unsigned(17, 7);
        wait for 2*CLK_PERIOD;

        -- Fim da simulação
        wait for 10*CLK_PERIOD;
        wait;
    end process;

end architecture;