library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaBrunoPedro is
    port(
        a       : in  unsigned(15 downto 0);
        b       : in  unsigned(15 downto 0);
        controleoperacao : in  std_logic_vector(3 downto 0);
        resultado : out unsigned(15 downto 0);
        zero    : out std_logic
    );
end ulaBrunoPedro;

architecture comportamento of ulaBrunoPedro is

signal soma, subtracao, and_result, or_result, xor_result, not_a, not_b : std_logic_vector(15 downto 0);
signal carry : std_logic_vector(15 downto 0);
signal temp_result : std_logic_vector(15 downto 0);
begin
--Operações
--Soma
carry(0) <= '0';

op_soma: for i in 0 to 15 generate
    begin
        soma(i) <= a(i) xor b(i) xor carry(i);
        carry_gen: if i < 15 generate
            begin
                carry(i+1) <= (a(i) and b(i)) or (carry(i) and (a(i) xor b(i)));
            end generate;
end generate;

op_subtracao: for i in 0 to 15 generate
    begin
        subtracao(i) <= a(i) xor (not b(i)) xor carry(i);
        carry_gen_sub: if i < 15 generate
            begin
                carry(i+1) <= (a(i) and (not b(i))) or (carry(i) and (a(i) xor (not b(i))));
            end generate;
end generate;
end comportamento;