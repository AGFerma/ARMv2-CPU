library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2_1w1 is
    Port(
        x, y : in std_logic;
        s : in std_logic;
        m : out std_logic);
end MUX2_1w1;

architecture Structural of MUX2_1w1 is
begin
    m <= (x and not s) or (y and s);
end Structural;