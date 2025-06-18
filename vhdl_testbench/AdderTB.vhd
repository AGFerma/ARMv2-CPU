library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AdderTB is
end entity;

architecture TB of AdderTB is
    signal A : std_logic_vector(3 downto 0) := (others => '0');
    signal B : std_logic_vector(3 downto 0) := (others => '0');
    signal Ci : std_logic := '0';
    signal S : std_logic_vector(3 downto 0);
    signal Co : std_logic;

    signal comp : std_logic_vector(3 downto 0);

    signal Stest : integer;
begin
    Adder: entity work.RC_Add_w4
    port map(A=>A, B=>B, Ci=>Ci, S=>S, Co=>Co);

    A(0) <= not A(0) after 1 ns;
    A(1) <= not A(1) after 2 ns;
    A(2) <= not A(2) after 4 ns;
    A(3) <= not A(3) after 8 ns;

    B(0) <= not B(0) after 16 ns;
    B(1) <= not B(1) after 32 ns;
    B(2) <= not B(2) after 64 ns;
    B(3) <= not B(3) after 128 ns;

    Ci <= not Ci after 256 ns;
    
    process(A, B, Ci)
    begin
        comp <= "000" & Ci;
        Stest <= TO_INTEGER(UNSIGNED(A))+TO_INTEGER(UNSIGNED(B))+TO_INTEGER(UNSIGNED(comp));
        assert (TO_INTEGER(UNSIGNED(Co & S(3 downto 0))) = Stest) report "Erreur sur S" severity error;
    end process;
end TB;

