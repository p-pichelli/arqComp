library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_controller is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        pc_in       : in  unsigned(7 downto 0);
        write_enable : out std_logic;
        pc_out        : out unsigned(7 downto 0)
    );
end entity;

architecture behavior of pc_controller is
begin
    pc_out <= pc_in when write_enable = '0' else pc_in + 1;
end architecture;
