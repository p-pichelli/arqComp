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
        zero_flag_out : out std_logic;
        overflow_flag_out : out std_logic;
        negative_flag_out : out std_logic
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
    
    signal controleop_s   : std_logic_vector(1 downto 0);
    signal sel_read_s     : std_logic_vector(2 downto 0);
    signal sel_write_s    : std_logic_vector(2 downto 0);
    signal ld_imm_s       : std_logic;
    signal mov_reg_to_acc_s : std_logic;
    signal imm_val_s      : unsigned(15 downto 0);
    signal reg_wr_en_un_top    : std_logic;
    signal reg_wr_en_banco_ula : std_logic;
    signal acc_wr_en_banco_ula    : std_logic;
    signal acc_wr_en_un_top : std_logic;

    signal accum_s        : unsigned(15 downto 0);
    signal alu_s          : unsigned(15 downto 0);
    signal zero_s         : std_logic;
    signal overflow_s     : std_logic;
    signal negative_s     : std_logic;
    
    signal is_mov_acc_to_reg : std_logic;
    signal is_mov_reg_to_acc : std_logic;
    signal is_alu_op         : std_logic;  
    
begin
    uc_inst : entity work.uc_top(arch_uc_top)
        port map(
            clk       => clk,
            rst       => rst,
            pc_value  => pc_s,
            instr_out => instr_s,
            estado    => estado_s,
            zero_flag => zero_s,
            overflow_flag => overflow_s,
            negative_flag => negative_s,
            bank_reg_wr_en_o => reg_wr_en_un_top,
            acc_wr_en_o => acc_wr_en_un_top,
            aluOperation_o => controleop_s,
            isAluOperation_o => is_alu_op
        );
    
    datapath_inst : entity work.banco_ula_top(arch_banco_ula_top)
        port map(
            clk              => clk,
            reset            => rst,
            controleoperacao => controleop_s,
            sel_read_reg     => sel_read_s,
            sel_write_reg    => sel_write_s,
            reg_wr_en        => reg_wr_en_banco_ula,
            acc_wr_en        => acc_wr_en_banco_ula,
            ld_immediate     => ld_imm_s,
            mov_reg_to_acc   => mov_reg_to_acc_s,
            immediate_value  => imm_val_s,
            accum_out        => accum_s,
            alu_out          => alu_s,
            zero_flag        => zero_s,
            overflow_flag    => overflow_s,
            negative_flag    => negative_s
        );
    
    opcode_s    <= instr_s(18 downto 15);
    reg_dest_s  <= std_logic_vector(instr_s(14 downto 12));
    reg_src_s   <= std_logic_vector(instr_s(11 downto 9));
    imm_const_s <= instr_s(8 downto 0);
    
    imm_val_s <= resize(imm_const_s(7 downto 0), 16);
    
    is_mov_acc_to_reg <= '1' when (opcode_s = "1111" and reg_src_s = "000") else '0';
    is_mov_reg_to_acc <= '1' when (opcode_s = "1111" and reg_src_s /= "000") else '0';
    
    ld_imm_s <= '1' when (estado_s = "10" and opcode_s = "1001") else '0';
    
    mov_reg_to_acc_s <= '1' when (estado_s = "10" and 
                                   is_mov_reg_to_acc = '1') else '0';


    
    sel_read_s <= reg_src_s;
    
    sel_write_s <= reg_dest_s;
    
    reg_wr_en_banco_ula <= '1' when (estado_s = "10" and reg_wr_en_un_top = '1' and
                            ( is_mov_acc_to_reg = '1')) else '0';
    
    acc_wr_en_banco_ula <= '1' when (estado_s = "10" and acc_wr_en_un_top = '1' and
                            (opcode_s = "1001" or          -- LD
                             is_mov_reg_to_acc = '1' or    -- MOV ACC,R
                             is_alu_op = '1')) else '0';   -- ADD/SUB/AND/OR
    
    pc_out        <= pc_s;
    instr_out     <= instr_s;
    estado_out    <= estado_s;
    accum_out     <= accum_s;
    alu_out       <= alu_s;
    zero_flag_out <= zero_s;
    overflow_flag_out <= overflow_s;
    negative_flag_out <= negative_s;
    
end architecture;