library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Left_shifter is
    port(
        din : in std_logic_vector(31 downto 0);
        shift : in std_logic_vector(4 downto 0);
        dout : out std_logic_vector(31 downto 0);
        cout : out std_logic
    );
end Left_shifter;

architecture Structural of Left_shifter is
signal l1, l2, l4, l8, l16 : std_logic_vector(31 downto 0);
signal din_shifted, l1_shifted, l2_shifted, l4_shifted, l8_shifted : std_logic_vector(31 downto 0);
begin
    din_shifted <= din(30 downto 0) & '0';
    l1_shifted <= l1(29 downto 0) & "00";
    l2_shifted <= l2(27 downto 0) & "0000";
    l4_shifted <= l4(23 downto 0) & "00000000";
    l8_shifted <= l8(15 downto 0) & "0000000000000000";

    shift_1 : entity work.MUX2_1w32
    port map(x=>din, y=>din_shifted, s=>shift(0), m=>l1);

    shift_2 : entity work.MUX2_1w32
    port map(x=>l1, y=>l1_shifted, s=>shift(1), m=>l2);

    shift_4 : entity work.MUX2_1w32
    port map(x=>l2, y=>l2_shifted, s=>shift(2), m=>l4);

    shift_8 : entity work.MUX2_1w32
    port map(x=>l4, y=>l4_shifted, s=>shift(3), m=>l8);

    shift_16 : entity work.MUX2_1w32
    port map(x=>l8, y=>l8_shifted, s=>shift(4), m=>l16);

    dout <= l16;

    with shift select cout <=
    '0' when "00000",
    din(30) when "00001", din(29) when "00010", din(28) when "00011", din(27) when "00100",
    din(26) when "00101", din(25) when "00110", din(24) when "00111", din(23) when "01000",
    din(22) when "01001", din(21) when "01010", din(20) when "01011", din(19) when "01100",
    din(18) when "01101", din(17) when "01110", din(16) when "01111", din(15) when "10000",
    din(14) when "10001", din(13) when "10010", din(12) when "10011", din(11) when "10100",
    din(10) when "10101", din(9) when "10110", din(8) when "10111", din(7) when "11000",
    din(6) when "11001", din(5) when "11010", din(4) when "11011", din(3) when "11100",
    din(2) when "11101", din(1) when "11110", din(0) when "11111", 'X' when others;
end Structural;