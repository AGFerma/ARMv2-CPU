library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RC_Add_w4 is
    Port(
        A, B : in STD_LOGIC_VECTOR(3 downto 0);
        Ci : in STD_LOGIC;
        S : out STD_LOGIC_VECTOR(3 downto 0);
        Co : out STD_LOGIC);
end RC_Add_w4;

architecture Structural of RC_Add_w4 is
signal carries : std_logic_vector(2 downto 0);

begin
    FA1 : entity work.FA
    port map(A=>A(0), B=>B(0), Ci=>Ci, S=>S(0), Co=>carries(0));
    FA2 : entity work.FA
    port map(A=>A(1), B=>B(1), Ci=>carries(0), S=>S(1), Co=>carries(1));
    FA3 : entity work.FA
    port map(A=>A(2), B=>B(2), Ci=>carries(1), S=>S(2), Co=>carries(2));
    FA4 : entity work.FA
    port map(A=>A(3), B=>B(3), Ci=>carries(2), S=>S(3), Co=>Co);
end Structural;
