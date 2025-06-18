library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_Add_w32 is
    Port (
        A, B : in std_logic_vector(31 downto 0);
        Ci : in std_logic;
        S : out std_logic_vector(31 downto 0);
        Co: out std_logic);
end CLA_Add_w32;

architecture Structural of CLA_Add_w32 is
signal res0, res1 : std_logic_vector(31 downto 0);
signal C_int0, C_int1, C_tot : std_logic_vector(1 downto 0);
begin
    adder0_15_0 : entity work.CLA_Add_w16
    port map(A=>A(15 downto 0), B=>B(15 downto 0), Ci=>'0', S=>res0(15 downto 0), Co=>C_int0(0));
    adder0_15_1 : entity work.CLA_Add_w16
    port map(A=>A(15 downto 0), B=>B(15 downto 0), Ci=>'1', S=>res1(15 downto 0), Co=>C_int1(0));

    Res_selector0 : entity work.MUX2_1w16
    port map(x=>res0(15 downto 0), y=>res1(15 downto 0), s=>Ci, m=>S(15 downto 0));
    Carry_selector0 : entity work.MUX2_1w1
    port map(x=>C_int0(0),y=>C_int1(0),s=>Ci,m=>C_tot(0));
----------------------------------------------------------------------------------------------------
    Adder16_31_0 : entity work.CLA_Add_w16
    port map(A=>A(31 downto 16), B=>B(31 downto 16), Ci=>'0', S=>res0(31 downto 16), Co=>C_int0(1));
    Adder16_31_1 : entity work.CLA_Add_w16
    port map(A=>A(31 downto 16), B=>B(31 downto 16), Ci=>'1', S=>res1(31 downto 16), Co=>C_int1(1));

    Res_selector1 : entity work.MUX2_1w16
    port map(x=>res0(31 downto 16), y=>res1(31 downto 16), s=>C_tot(0), m=>S(31 downto 16));
    Carry_selector1 : entity work.MUX2_1w1
    port map(x=>C_int0(1),y=>C_int1(1),s=>C_tot(0),m=>Co);
end Structural;