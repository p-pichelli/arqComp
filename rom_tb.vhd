library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end rom_tb;

architecture sim of rom_tb is
    component rom
       port(
          endereco : in  unsigned(7 downto 0);
          dado     : out unsigned(18 downto 0)
       );
    end component;

    signal endereco : unsigned(7 downto 0) := (others => '0');
    signal dado     : unsigned(18 downto 0);
begin
    DUT: rom
        port map(
            endereco => endereco,
            dado     => dado
        );

    stim_proc: process
    begin
        for i in 0 to 49 loop
            endereco <= to_unsigned(i, 8);
            wait for 10 ns;
        end loop;

        wait;
    end process;
end sim;
