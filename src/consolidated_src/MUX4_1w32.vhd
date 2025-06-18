library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4_1w32 is
port(
    A, B, C, D : in std_logic_vector(31 downto 0);
    cmd : in std_logic_vector(1 downto 0);
    S : out std_logic_vector(31 downto 0));
end entity MUX4_1w32;

architecture structural of MUX4_1w32 is
signal CMD0, CMD1 : std_logic_vector(31 downto 0);
begin
    CMD0 <= (others => cmd(0));
    CMD1 <= (others => cmd(1)); -- Extension de chaque bit de cmd sur 32 bits pour comparaison rapide sans if

    S <= (A and (not CMD0 and not CMD1)) or (B and (CMD0 and not CMD1)) or (C and (not CMD0 and CMD1)) or (D and (CMD0 and CMD1));

end structural;