library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity banco_reg is
    port(
        in_write_reg: in std_logic_vector(2 downto 0);
        in_read_reg : in std_logic_vector(2 downto 0);
        in_write_data   : in unsigned (15 downto 0);
        clock           : in std_logic;
        reset           : in std_logic;
        wr_en           : in std_logic;
        out_read_data   : out unsigned (15 downto 0)
        );
end banco_reg;

architecture arch_banco_reg of banco_reg is
    signal in_data: unsigned(15 downto 0);
    signal in_wr_en1, in_wr_en2, in_wr_en3, in_wr_en4, in_wr_en5, in_wr_en6: std_logic := '0';
    signal out_ch1, out_ch2, out_ch3, out_ch4, out_ch5, out_ch6 : unsigned (15 downto 0);
    signal default_out_data: unsigned (15 downto 0) := "0000000000000000";
    begin
        reg1: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en1, data_in => in_data, data_out => out_ch1);
        reg2: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en2, data_in => in_data, data_out => out_ch2);
        reg3: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en3, data_in => in_data, data_out => out_ch3);
        reg4: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en4, data_in => in_data, data_out => out_ch4);
        reg5: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en5, data_in => in_data, data_out => out_ch5);
        reg6: entity work.reg_16bits(arch_reg_16bits) port map (clk => clock, rst => reset, wr_en => in_wr_en6, data_in => in_data, data_out => out_ch6);

    -- demultiplexador para write
    with in_write_reg select
        in_wr_en1 <= wr_en when "000", '0' when others;
    with in_write_reg select
        in_wr_en2 <= wr_en when "001", '0' when others;
    with in_write_reg select
        in_wr_en3 <= wr_en when "010", '0' when others;
    with in_write_reg select
        in_wr_en4 <= wr_en when "011", '0' when others;
    with in_write_reg select
        in_wr_en5 <= wr_en when "100", '0' when others;
    with in_write_reg select
        in_wr_en6 <= wr_en when "101", '0' when others;
            
    -- multiplexador para read
    with in_read_reg select
        out_read_data <= out_ch1 when "000", 
                        out_ch2 when "001",
                        out_ch3 when "010",
                        out_ch4 when "011",
                        out_ch5 when "100",
                        out_ch6 when "101",
                        default_out_data when others;

    in_data <= in_write_data;

end architecture;