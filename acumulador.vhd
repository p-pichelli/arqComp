library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        write_enable  : in  std_logic;
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end acumulador;

architecture comportamento of acumulador is
    signal reg : unsigned(15 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
end comportamento;
