library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2_1w32 is
    Port(
        x, y : in std_logic_vector(31 downto 0);
        s : in std_logic;
        m : out std_logic_vector(31 downto 0));
end MUX2_1w32;

architecture Structural of MUX2_1w32 is
signal C_int : std_logic_vector(31 downto 0);
begin
    C_int <= (others => s);
    m <= (x and not C_int) or (y and C_int);
end Structural;