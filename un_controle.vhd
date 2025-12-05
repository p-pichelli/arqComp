library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(
        clk           :     in  std_logic;
        rst           :     in  std_logic;
        instr         :     in  unsigned(18 downto 0);
        estado_i      :     in  unsigned (1 downto 0);
        zero_flag_i   :     in  std_logic;
        negative_flag_i :   in  std_logic;
        overflow_flag_i :   in  std_logic;
        ctz5_flag_i   :     in  std_logic;
        jump_en       :     out std_logic;
        jump_addr_o   :     out unsigned(7 downto 0);
        halt_en_o:          out std_logic;
        bank_reg_wr_en_o :  out std_logic;
        acc_wr_en_o :       out std_logic;
        isAluOperation_o :  out std_logic;
        aluOperation_o:     out std_logic_vector(1 downto 0);
        ram_wr_en_o:          out std_logic
    );
end entity;


architecture arch_un_controle of un_controle is 
    signal opcode : unsigned(3 downto 0);
    signal bgt_cond : std_logic;
    signal blt_cond : std_logic;
    signal bvc_cond : std_logic;
    signal ctz5_cond : std_logic;

begin
    opcode <= instr(18 downto 15);

    isAluOperation_o <= '1' when estado_i = "10" AND (opcode = "0110" or  --ADD
                          (opcode = "1010") or  --SUB
                           opcode = "1100" or  
                           opcode = "1011") else '0';  

    aluOperation_o <= "00" when opcode = "0110" else  -- ADD
                "01" when opcode = "1010" else  --SUB
                "10" when opcode = "1100" else  
                "11" when opcode = "1011" else  
                "00";  

    bgt_cond <= '1' when (zero_flag_i = '0' and negative_flag_i = overflow_flag_i) else '0';
    blt_cond <= '1' when (zero_flag_i = '0' and negative_flag_i /= overflow_flag_i) else '0';
    bvc_cond <= '1' when (overflow_flag_i = '0') else '0';
    ctz5_cond <= '1' when (ctz5_flag_i = '1') else '0';
    
    jump_en <= '1' when (estado_i = "10" and (
                          opcode = "1110" or  -- JMP incondicional
                          (opcode = "1000" and bgt_cond = '1') or  -- BGT condicional
                          (opcode = "0101" and blt_cond = '1') or    -- BLT condicional
                          (opcode = "0111" and bvc_cond = '1') or    -- BVC
                          (opcode = "0010" and ctz5_cond = '1')
                          )) 
                          else '0';

    jump_addr_o <= instr(7 downto 0) when (opcode = "1110" or opcode = "1000" or opcode = "0101" or opcode = "0111" or opcode = "0010") else (others => '0');
    halt_en_o <= '1' when opcode = "0001" else '0';

    bank_reg_wr_en_o <= '0' when jump_en = '1' else '1';
    acc_wr_en_o  <= '0' when jump_en = '1' else '1';
    ram_wr_en_o <= '1' when opcode = "0011" else '0';

end architecture;
