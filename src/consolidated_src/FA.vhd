library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FA is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Ci : in STD_LOGIC;
           S : out STD_LOGIC;
           Co : out STD_LOGIC);
end FA;

architecture Structural of FA is

begin
    S <= (not(A)and (B xor Ci)) or (A and (not(B xor Ci)));
    Co <= (A and B) or (B and Ci) or (Ci and A);

end Structural;
