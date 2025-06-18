library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use Work.all;



entity switch_add_soustract_op is 

port(dec_op: in std_logic_vector(31 downto 0);
    dec_comp_op: in std_logic;
    vss,vdd: in bit;
    E_OP_ALU : out std_logic_vector(31 downto 0));

end switch_add_soustract_op;

architecture struct of switch_add_soustract_op is
signal dec_op_not : std_logic_vector(31 downto 0);
begin 
    dec_op_not <= not dec_op; --complement à 1, on fera le complement à 2 dans le cin de l'ALU
    
    Mux2to1 : entity work.MUX2_1w32(Structural)
    port map(x=>dec_op, y=>dec_op_not, s=>dec_comp_op,m=>E_OP_ALU);
end struct;
