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
        negative : out std_logic;
        ctz5      : out std_logic
    );
end ulaBrunoPedro;

architecture comportamento of ulaBrunoPedro is
    signal soma_ext, sub_ext : unsigned(15 downto 0);
    signal overflow_soma, overflow_sub : std_logic;

begin
    soma_ext <= a + b;
    sub_ext  <= a - b;

    with controleoperacao select
        resultado <= soma_ext(15 downto 0) when "00",
                     sub_ext(15 downto 0)  when "01",
                     a and b                when "10",
                     a or  b                when others;

    zero <= '1' when resultado = 0 else '0';
    negative <= resultado(15);

    overflow_soma <= '1' when (a(15) = b(15) ) and (a(15) /= b(15)) else '0';
    overflow_sub  <= '1' when (a(15) /= b(15) ) and (a(15) /= sub_ext(15)) else '0';

    with controleoperacao select
        overflow <= overflow_soma when "00",
                     overflow_sub  when "01",
                     '0'          when others;

    ctz5 <= '1' when resultado(4 downto 0) = "00000" else '0';
end comportamento;
