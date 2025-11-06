library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaBrunoPedro is
    port(
        a       : in  unsigned(15 downto 0);
        b       : in  unsigned(15 downto 0);
        controleoperacao : in  std_logic_vector(1 downto 0);
        resultado : out unsigned(15 downto 0);
        zero    : out std_logic;
        overflow: out std_logic;
        negative : out std_logic
    );
end ulaBrunoPedro;

architecture comportamento of ulaBrunoPedro is
    signal soma_ext, sub_ext : unsigned(16 downto 0);
begin
    soma_ext <= ('0' & a) + ('0' & b);
    sub_ext  <= ('0' & a) - ('0' & b);

    with controleoperacao select
        resultado <= soma_ext(15 downto 0) when "00",
                     sub_ext(15 downto 0)  when "01",
                     a and b                when "10",
                     a or  b                when others;

    zero <= '1' when resultado = 0 else '0';
    negative <= resultado(15);
    with controleoperacao select
        overflow <= soma_ext(16) when "00",
                     sub_ext(16)  when "01",
                     '0'          when others;
end comportamento;
