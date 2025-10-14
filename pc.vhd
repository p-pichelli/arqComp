library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        write_enable : in  std_logic;
        pc_in        : in  unsigned(7 downto 0);
        pc_out       : out unsigned(7 downto 0)
    );
end entity;

architecture behavior of pc is
    signal pc_reg : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                pc_reg <= pc_in;
            end if;
        end if;
    end process;

    pc_out <= pc_reg;
end architecture;
