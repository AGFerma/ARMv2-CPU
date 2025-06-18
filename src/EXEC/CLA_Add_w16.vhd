library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_Add_w16 is
    Port (
        A, B : in std_logic_vector(15 downto 0);
        Ci : in std_logic;
        S : out std_logic_vector(15 downto 0);
        Co : out std_logic);
end CLA_Add_w16;

architecture Structural of CLA_Add_w16 is
signal carries0, carries1, carries_tot : std_logic_vector(3 downto 0);
signal res0, res1, res_tot : std_logic_vector(15 downto 0);
begin
    Adder0_3_0 : entity work.RC_Add_w4
    port map(A=>A(3 downto 0), B=>B(3 downto 0), Ci=>'0', S=>res0(3 downto 0), Co=>carries0(0));
    Adder0_3_1 : entity work.RC_Add_w4
    port map(A=>A(3 downto 0), B=>B(3 downto 0), Ci=>'1', S=>res1(3 downto 0), Co=>carries1(0));

    Res_selector0 : entity work.MUX2_1w4
    port map(x=>res0(3 downto 0), y=>res1(3 downto 0), s=>Ci, m=>res_tot(3 downto 0));
    Carry_selector0 : entity work.MUX2_1w1
    port map(x=>carries0(0),y=>carries1(0),s=>Ci,m=>carries_tot(0));
----------------------------------------------------------------------------------------------------
    Adder4_7_0 : entity work.RC_Add_w4
    port map(A=>A(7 downto 4), B=>B(7 downto 4), Ci=>'0', S=>res0(7 downto 4), Co=>carries0(1));
    Adder4_7_1 : entity work.RC_Add_w4
    port map(A=>A(7 downto 4), B=>B(7 downto 4), Ci=>'1', S=>res1(7 downto 4), Co=>carries1(1));
    
    Res_selector1 : entity work.MUX2_1w4
    port map(x=>res0(7 downto 4),y=>res1(7 downto 4),s=>carries_tot(0),m=>res_tot(7 downto 4));
    Carry_selector1 : entity work.MUX2_1w1
    port map(x=>carries0(1),y=>carries1(1),s=>carries_tot(0),m=>carries_tot(1));
----------------------------------------------------------------------------------------------------
    Adder8_11_0 : entity work.RC_Add_w4
    port map(A=>A(11 downto 8), B=>B(11 downto 8), Ci=>'0', S=>res0(11 downto 8), Co=>carries0(2));
    Adder8_11_1 : entity work.RC_Add_w4
    port map(A=>A(11 downto 8), B=>B(11 downto 8), Ci=>'1', S=>res1(11 downto 8), Co=>carries1(2));
    
    Res_selector2 : entity work.MUX2_1w4
    port map(x=>res0(11 downto 8),y=>res1(11 downto 8),s=>carries_tot(1),m=>res_tot(11 downto 8));
    Carry_selector2 : entity work.MUX2_1w1
    port map(x=>carries0(2),y=>carries1(2),s=>carries_tot(1),m=>carries_tot(2));
----------------------------------------------------------------------------------------------------    
    Adder12_15_0 : entity work.RC_Add_w4
    port map(A=>A(15 downto 12), B=>B(15 downto 12), Ci=>'0', S=>res0(15 downto 12), Co=>carries0(3));
    Adder12_15_1 : entity work.RC_Add_w4
    port map(A=>A(15 downto 12), B=>B(15 downto 12), Ci=>'1', S=>res1(15 downto 12), Co=>carries1(3));
    
    Res_selector3 : entity work.MUX2_1w4
    port map(x=>res0(15 downto 12),y=>res1(15 downto 12),s=>carries_tot(2),m=>res_tot(15 downto 12));
    Carry_selector3 : entity work.MUX2_1w1
    port map(x=>carries0(3),y=>carries1(3),s=>carries_tot(2),m=>carries_tot(3));
---------------------------------------------------------------------------------------------------- 
    S <= res_tot;
    Co <= carries_tot(3);

end Structural;
