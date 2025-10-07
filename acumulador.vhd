library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        write_enable : in  std_logic;
        data_in      : in  unsigned(15 downto 0);
        data_out     : out unsigned(15 downto 0)
    );
end acumulador;

architecture uso_reg of acumulador is
    component reg_16bits
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal reg_out : unsigned(15 downto 0);
begin
    REG_INST : reg_16bits
        port map (
            clk      => clk,
            rst      => rst,
            wr_en    => write_enable,
            data_in  => data_in,
            data_out => reg_out
        );

    data_out <= reg_out;
end uso_reg;
