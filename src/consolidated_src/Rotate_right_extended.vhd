library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Rotate_right_extended is
    port(
        din : in std_logic_vector(31 downto 0);
        dout : out std_logic_vector(31 downto 0);
        cin : in std_logic;
        cout : out std_logic
    );
end Rotate_right_extended;

architecture Structural of Rotate_right_extended is
begin
    cout <= din(0);
    dout <= cin & din(30 downto 0);
end Structural;