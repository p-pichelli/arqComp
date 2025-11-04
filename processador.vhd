library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;
        pc_out        : out unsigned(7 downto 0);
        instr_out     : out unsigned(18 downto 0);
        estado_out    : out unsigned(1 downto 0);
        accum_out     : out unsigned(15 downto 0);
        alu_out       : out unsigned(15 downto 0);
        zero_flag_out : out std_logic
    );
end entity;

architecture arch_processador of processador is
    signal pc_s        : unsigned(7 downto 0);
    signal instr_s     : unsigned(18 downto 0);
    signal estado_s    : unsigned(1 downto 0);
    
    signal opcode_s       : unsigned(3 downto 0);
    signal reg_dest_s     : std_logic_vector(2 downto 0);
    signal reg_src_s      : std_logic_vector(2 downto 0);
    signal imm_const_s    : unsigned(8 downto 0);
    signal is_const_s     : std_logic;
    
    signal controleop_s   : std_logic_vector(1 downto 0);
    signal sel_read_s     : std_logic_vector(2 downto 0);
    signal sel_write_s    : std_logic_vector(2 downto 0);
    signal reg_wr_en_s    : std_logic;
    signal acc_wr_en_s    : std_logic;
    signal ld_imm_s       : std_logic;
    signal imm_val_s      : unsigned(15 downto 0);
    
    signal accum_s        : unsigned(15 downto 0);
    signal alu_s          : unsigned(15 downto 0);
    signal zero_s         : std_logic;
    
begin
    uc_inst : entity work.uc_top(arch_uc_top)
        port map(
            clk       => clk,
            rst       => rst,
            pc_value  => pc_s,
            instr_out => instr_s,
            estado    => estado_s
        );
    
    datapath_inst : entity work.banco_ula_top(arch_banco_ula_top)
        port map(
            clk              => clk,
            reset            => rst,
            controleoperacao => controleop_s,
            sel_read_reg     => sel_read_s,
            sel_write_reg    => sel_write_s,
            reg_wr_en        => reg_wr_en_s,
            acc_wr_en        => acc_wr_en_s,
            ld_immediate     => ld_imm_s,
            immediate_value  => imm_val_s,
            accum_out        => accum_s,
            alu_out          => alu_s,
            zero_flag        => zero_s
        );
    
    opcode_s    <= instr_s(18 downto 15);
    reg_dest_s  <= std_logic_vector(instr_s(14 downto 12));
    reg_src_s   <= std_logic_vector(instr_s(11 downto 9));
    imm_const_s <= instr_s(8 downto 0);
    is_const_s  <= imm_const_s(8);  
    
    imm_val_s <= resize(imm_const_s(7 downto 0), 16);
    
    ld_imm_s <= '1' when (estado_s /= "00" and opcode_s = "1001") else '0';
    
    controleop_s <= "00" when opcode_s = "0110" else  --ADD
                    "01" when opcode_s = "1010" else  -- SUB
                    "10" when opcode_s = "1100" else  -- AND
                    "11" when opcode_s = "1011" else  -- OR
                    "00";  -- default
    
    sel_read_s <= reg_src_s when (opcode_s = "0110" or opcode_s = "1010" or 
                                   opcode_s = "1100" or opcode_s = "1011") else
                  reg_dest_s when opcode_s = "1111" else
                  "000";
    
    sel_write_s <= reg_dest_s;
    
    reg_wr_en_s <= '1' when (estado_s /= "00" and 
                            (opcode_s = "0110" or opcode_s = "1010" or 
                             opcode_s = "1100" or opcode_s = "1011" or
                             opcode_s = "1111")) else '0';
    
    acc_wr_en_s <= '1' when (estado_s /= "00" and 
                            (opcode_s = "1001" or opcode_s = "1111" or
                             opcode_s = "0110" or opcode_s = "1010" or
                             opcode_s = "1100" or opcode_s = "1011")) else '0';
    
    -- Saídas de observação
    pc_out        <= pc_s;
    instr_out     <= instr_s;
    estado_out    <= estado_s;
    accum_out     <= accum_s;
    alu_out       <= alu_s;
    zero_flag_out <= zero_s;
    
end architecture;