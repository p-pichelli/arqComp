library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_ula_top is
    port (
        clk               : in  std_logic;
        reset               : in  std_logic;
        controleoperacao  : in  std_logic_vector(1 downto 0);
        sel_read_reg      : in  std_logic_vector(2 downto 0);
        sel_write_reg     : in  std_logic_vector(2 downto 0);
        reg_wr_en         : in  std_logic;
        acc_wr_en         : in  std_logic;
        ld_immediate      : in  std_logic;
        mov_reg_to_acc    : in  std_logic; 
        immediate_value   : in  unsigned(15 downto 0);
        accum_out         : out unsigned(15 downto 0);
        alu_out           : out unsigned(15 downto 0);
        zero_flag         : out std_logic;
        overflow_flag         : out std_logic;
        negative_flag      : out std_logic;
        ctz5_flag         : out std_logic
    );
end entity banco_ula_top;

architecture arch_banco_ula_top of banco_ula_top is
    signal acc_value       : unsigned(15 downto 0);
    signal bank_read_data  : unsigned(15 downto 0);
    signal alu_result      : unsigned(15 downto 0);
    signal acc_next        : unsigned(15 downto 0);
   
begin
    reg_bank : entity work.banco_reg(arch_banco_reg)
        port map (
            in_write_reg  => sel_write_reg,
            in_read_reg   => sel_read_reg,
            in_write_data => acc_value,
            clock         => clk,
            reset         => reset,
            wr_en         => reg_wr_en,
            out_read_data => bank_read_data
        );

    alu_inst : entity work.ulaBrunoPedro(comportamento)
        port map (
            a                 => bank_read_data,
            b                 => acc_value,
            controleoperacao  => controleoperacao,
            resultado         => alu_result,
            zero              => zero_flag,
            overflow          => overflow_flag,
            negative          => negative_flag,
            ctz5              => ctz5_flag
        );
   

    acc_next <= immediate_value when ld_immediate = '1' else
                bank_read_data  when mov_reg_to_acc = '1' else
                alu_result;
    acc_reg : entity work.reg_16bits(arch_reg_16bits)
        port map (
            clk      => clk,
            rst      => reset,
            wr_en    => acc_wr_en,
            data_in  => acc_next,
            data_out => acc_value
        );

    accum_out <= acc_value;
    alu_out   <= alu_result;

end architecture arch_banco_ula_top;
