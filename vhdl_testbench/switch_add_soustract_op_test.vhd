library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use Work.all;

entity switch_add_soustract_op_test is
end entity;

architecture TB of switch_add_soustract_op_test is 

signal dec_op: std_logic_vector(31 downto 0);
signal dec_comp_op:  std_logic;
signal vss,vdd:  bit;
signal E_OP_ALU :  std_logic_vector(31 downto 0);

begin
    switch : entity work.switch_add_soustract_op(struct)
    port map(dec_op,dec_comp_op,vss,vdd,E_OP_ALU);

    dec_op<=(31 downto 28 =>'1',others=>'0'), (others=>'0') after 10 ns, (others=>'1') after 20 ns;
    dec_comp_op <= '0' , '1' after 5 ns;
end TB; 

