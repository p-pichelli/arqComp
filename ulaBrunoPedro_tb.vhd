library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaBrunoPedro_tb is end entity;

architecture sim of ulaBrunoPedro_tb is 
    signal in_a : unsigned (15 downto 0);
    signal in_b : unsigned (15 downto 0);
    signal in_ctrl : std_logic_vector(1 downto 0) := "00";
    signal out_res : unsigned (15 downto 0);
    signal out_is_equal : std_logic;

begin
    DUT: entity work.ulaBrunoPedro(comportamento) 
        port map (a => in_a, b => in_b, controleoperacao => in_ctrl, resultado => out_res, zero => out_is_equal);
    
    in_ctrl <= "01" after 20 ns, "10" after 40 ns, "11" after 80 ns;

    in_a <= x"0001" ,       -- soma
    x"0007" after 10 ns ,   -- soma 
    x"0004" after 20 ns,    -- subtr
    x"FFFC" after 30 ns,    -- subtr -- 1, 7, 4, -4 em hex

    x"0000" after 40 ns,    -- AND
    x"0000" after 50 ns,    -- AND
    x"0001" after 60 ns,    -- AND
    x"0005" after 70 ns,    -- AND

    x"0000" after 80 ns,    -- OR
    x"0000" after 90 ns,    -- OR
    x"0001" after 100 ns,    -- OR
    x"0005" after 110 ns,    -- OR

    x"0000" after 120 ns;    

    in_b <= x"0002", 
    x"FFFB" after 10 ns, 
    x"FFF0" after 20 ns, 
    x"FFF0" after 30 ns,    -- 2, -5, -10, -10 em hex

    x"0000" after 40 ns,    -- AND
    x"0001" after 50 ns,    -- AND
    x"0001" after 60 ns,    -- AND
    x"0001" after 70 ns,    -- AND

    x"0000" after 80 ns,    -- OR
    x"0001" after 90 ns,    -- OR
    x"0001" after 100 ns,    -- OR
    x"0001" after 110 ns,    -- OR

    x"0000" after  120 ns;    
end architecture;

