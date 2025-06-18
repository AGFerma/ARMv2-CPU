library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shifter is
    port(
        shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, cin : in std_logic;
        shift_val : in std_logic_vector(4 downto 0);
        din : in std_logic_vector(31 downto 0);
        dout : out std_logic_vector(31 downto 0);
        cout : out std_logic;

        vdd : in bit;
        vss : in bit
    );
end Shifter;

architecture Structural of Shifter is
signal shift_len : integer;
signal left_logical, right_logical, right_arith, right_rot, right_rot_cf : std_logic_vector(31 downto 0);
signal carries, cmd : std_logic_vector(4 downto 0);
begin
    cmd <= shift_rrx & shift_ror & shift_asr & shift_lsr & shift_lsl;

    SLL_ent : entity work.Left_shifter
    port map(din=>din, shift=>shift_val, dout=>left_logical, cout=>carries(0));

    SRL_ent : entity work.Right_shifter_log
    port map(din=>din, shift=>shift_val, dout=>right_logical, cout=>carries(1));

    SRA_ent : entity work.Right_shifter_arith
    port map(din=>din, shift=>shift_val, dout=>right_arith, cout=>carries(2));

    ROR_ent : entity work.Rotate_right
    port map(din=>din, shift=>shift_val, dout=>right_rot, cout=>carries(3));

    ROX_ent : entity work.Rotate_right_extended
    port map(din=>din, dout=>right_rot_cf, cin=>cin, cout=>carries(4));

    with cmd select dout <=
    left_logical when "00001",
    right_logical when "00010",
    right_arith when "00100",
    right_rot when "01000",
    right_rot_cf when "10000",
    left_logical when others;


end Structural;