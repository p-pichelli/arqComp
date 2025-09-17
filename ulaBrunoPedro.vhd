library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaBrunoPedro is
    port(
        a       : in  unsigned(15 downto 0);
        b       : in  unsigned(15 downto 0);
        controleoperacao : in  std_logic_vector(1 downto 0);
        resultado : out unsigned(15 downto 0);
        zero    : out std_logic
    );
end ulaBrunoPedro;

architecture comportamento of ulaBrunoPedro is
begin
    with controleoperacao select
        resultado <= a + b when "00",
                     a - b when "01",
                     a and b when "10",
                     a or  b when others;
                      

    zero <= '1' when a - b = 0 else '0';
end comportamento;
