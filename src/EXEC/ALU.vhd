library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is 
port(
    op1 : in std_logic_vector(31 downto 0);
    op2 : in std_logic_vector(31 downto 0);
    cin : in std_logic;

    cmd : in std_logic_vector(1 downto 0);

    res : out std_logic_vector(31 downto 0);
    cout : out std_logic;
    z : out std_logic;
    n : out std_logic;
    v : out std_logic;

    vdd : in bit;
    vss : in bit);
end ALU;

architecture structural of ALU is
signal S, OP_and, OP_or, OP_xor, OP_Add, res_tot : std_logic_vector(31 downto 0);
signal V_int : std_logic;
begin
    OP_and <= op1 and op2;
    OP_or <= op1 OR op2;
    OP_xor <= op1 XOR op2;

    Adder : entity work.CLA_Add_w32
    port map(A=>op1, B=>op2, Ci=>cin, S=>Op_Add, Co=>cout);

    V_int <= not(op1(31) xor op2(31)) and (OP_Add(31) xor op1(31));     -- Overflow si op1 et op2 de même signe et signe de S différent du signe de opn

    v <= ((not cmd(0)) and (not cmd(1))) and V_int;   -- v généré seulement si en mode addition

    n <= res_tot(31); --flag négatif

    z <= not res_tot(31) and not res_tot(30) and not res_tot(29) and not res_tot(28) and not res_tot(27) and not res_tot(26) and not res_tot(25) and not res_tot(24) and
         not res_tot(23) and not res_tot(22) and not res_tot(21) and not res_tot(20) and not res_tot(19) and not res_tot(18) and not res_tot(17) and not res_tot(16) and
         not res_tot(15) and not res_tot(14) and not res_tot(13) and not res_tot(12) and not res_tot(11) and not res_tot(10) and not res_tot(9)  and not res_tot(8)  and
         not res_tot(7)  and not res_tot(6)  and not res_tot(5)  and not res_tot(4)  and not res_tot(3)  and not res_tot(2)  and not res_tot(1)  and not res_tot(0);

    MUX_res : entity work.MUX4_1w32
    port map(A=>OP_Add, B=>OP_and, C=>OP_or, D=>OP_xor, cmd=>cmd, S=>res_tot);
    res<= res_tot;


    res<=res_tot;


    

end structural;