-- Testbench pour l'entité Exec
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Exec is
    -- Un testbench n'a pas de ports
end TB_Exec;

architecture Behavioral of TB_Exec is

    -- Déclaration du composant Exec
    component Exec is
        port(
            -- Interface de synchronisation avec Decode
            dec2exe_empty  : in  std_logic;
            exe_pop        : out std_logic;

            -- Opérandes provenant de Decode
            dec_op1        : in  std_logic_vector(31 downto 0);
            dec_op2        : in  std_logic_vector(31 downto 0);
            dec_exe_dest   : in  std_logic_vector(3 downto 0);
            dec_exe_wb     : in  std_logic;
            dec_flag_wb    : in  std_logic;

            -- Interface Decode vers MEM
            dec_mem_data   : in  std_logic_vector(31 downto 0);
            dec_mem_dest   : in  std_logic_vector(3 downto 0);
            dec_pre_index  : in  std_logic;

            dec_mem_lw     : in  std_logic;
            dec_mem_lb     : in  std_logic;
            dec_mem_sw     : in  std_logic;
            dec_mem_sb     : in  std_logic;

            -- Commande du shifter
            dec_shift_lsl  : in  std_logic;
            dec_shift_lsr  : in  std_logic;
            dec_shift_asr  : in  std_logic;
            dec_shift_ror  : in  std_logic;
            dec_shift_rrx  : in  std_logic;
            dec_shift_val  : in  std_logic_vector(4 downto 0);
            dec_cy         : in  std_logic;

            -- Sélection des opérandes pour l'ALU
            dec_comp_op1   : in  std_logic;
            dec_comp_op2   : in  std_logic;
            dec_alu_cy     : in  std_logic;

            -- Commande de l'ALU
            dec_alu_cmd    : in  std_logic_vector(1 downto 0);

            -- Bypass de Exe vers Decode
            exe_res        : out std_logic_vector(31 downto 0);

            exe_c          : out std_logic;
            exe_v          : out std_logic;
            exe_n          : out std_logic;
            exe_z          : out std_logic;

            exe_dest       : out std_logic_vector(3 downto 0);
            exe_wb         : out std_logic;
            exe_flag_wb    : out std_logic;

            -- Interface avec MEM
            exe_mem_adr    : out std_logic_vector(31 downto 0);
            exe_mem_data   : out std_logic_vector(31 downto 0);
            exe_mem_dest   : out std_logic_vector(3 downto 0);

            exe_mem_lw     : out std_logic;
            exe_mem_lb     : out std_logic;
            exe_mem_sw     : out std_logic;
            exe_mem_sb     : out std_logic;

            exe2mem_empty  : out std_logic;
            mem_pop        : in  std_logic;

            -- Interface globale
            ck             : in  std_logic;
            reset_n        : in  std_logic;
            vdd            : in  bit;
            vss            : in  bit
        );
    end component;

    -- Déclaration des signaux pour connecter le testbench au composant
    signal dec2exe_empty : std_logic := '1';
    signal exe_pop       : std_logic;

    signal dec_op1       : std_logic_vector(31 downto 0) := (others => '0');
    signal dec_op2       : std_logic_vector(31 downto 0) := (others => '0');
    signal dec_exe_dest  : std_logic_vector(3 downto 0)  := (others => '0');
    signal dec_exe_wb    : std_logic := '0';
    signal dec_flag_wb   : std_logic := '0';

    signal dec_mem_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal dec_mem_dest  : std_logic_vector(3 downto 0)  := (others => '0');
    signal dec_pre_index : std_logic := '0';

    signal dec_mem_lw    : std_logic := '0';
    signal dec_mem_lb    : std_logic := '0';
    signal dec_mem_sw    : std_logic := '0';
    signal dec_mem_sb    : std_logic := '0';

    signal dec_shift_lsl : std_logic := '0';
    signal dec_shift_lsr : std_logic := '0';
    signal dec_shift_asr : std_logic := '0';
    signal dec_shift_ror : std_logic := '0';
    signal dec_shift_rrx : std_logic := '0';
    signal dec_shift_val : std_logic_vector(4 downto 0) := (others => '0');
    signal dec_cy        : std_logic := '0';

    signal dec_comp_op1  : std_logic := '0';
    signal dec_comp_op2  : std_logic := '0';
    signal dec_alu_cy    : std_logic := '0';

    signal dec_alu_cmd   : std_logic_vector(1 downto 0) := "00";

    signal exe_res       : std_logic_vector(31 downto 0);

    signal exe_c         : std_logic;
    signal exe_v         : std_logic;
    signal exe_n         : std_logic;
    signal exe_z         : std_logic;

    signal exe_dest      : std_logic_vector(3 downto 0);
    signal exe_wb        : std_logic;
    signal exe_flag_wb   : std_logic;

    signal exe_mem_adr   : std_logic_vector(31 downto 0);
    signal exe_mem_data  : std_logic_vector(31 downto 0);
    signal exe_mem_dest  : std_logic_vector(3 downto 0);

    signal exe_mem_lw    : std_logic;
    signal exe_mem_lb    : std_logic;
    signal exe_mem_sw    : std_logic;
    signal exe_mem_sb    : std_logic;

    signal exe2mem_empty : std_logic;
    signal mem_pop       : std_logic := '0';

    signal ck            : std_logic := '0';
    signal reset_n       : std_logic := '0';
    signal vdd           : bit := '1';
    signal vss           : bit := '0';

    signal dec_mem_adr : std_logic_vector(31 downto 0);

    -- Définition de la période d'horloge
    constant clk_period : time := 1 ns;

begin

    -- Instanciation du composant Exec (Unit Under Test)
    UUT: Exec
        port map(
            dec2exe_empty => dec2exe_empty,
            exe_pop       => exe_pop,

            dec_op1       => dec_op1,
            dec_op2       => dec_op2,
            dec_exe_dest  => dec_exe_dest,
            dec_exe_wb    => dec_exe_wb,
            dec_flag_wb   => dec_flag_wb,

            dec_mem_data  => dec_mem_data,
            dec_mem_dest  => dec_mem_dest,
            dec_pre_index => dec_pre_index,

            dec_mem_lw    => dec_mem_lw,
            dec_mem_lb    => dec_mem_lb,
            dec_mem_sw    => dec_mem_sw,
            dec_mem_sb    => dec_mem_sb,

            dec_shift_lsl => dec_shift_lsl,
            dec_shift_lsr => dec_shift_lsr,
            dec_shift_asr => dec_shift_asr,
            dec_shift_ror => dec_shift_ror,
            dec_shift_rrx => dec_shift_rrx,
            dec_shift_val => dec_shift_val,
            dec_cy        => dec_cy,

            dec_comp_op1  => dec_comp_op1,
            dec_comp_op2  => dec_comp_op2,
            dec_alu_cy    => dec_alu_cy,

            dec_alu_cmd   => dec_alu_cmd,

            exe_res       => exe_res,

            exe_c         => exe_c,
            exe_v         => exe_v,
            exe_n         => exe_n,
            exe_z         => exe_z,

            exe_dest      => exe_dest,
            exe_wb        => exe_wb,
            exe_flag_wb   => exe_flag_wb,

            exe_mem_adr   => exe_mem_adr,
            exe_mem_data  => exe_mem_data,
            exe_mem_dest  => exe_mem_dest,

            exe_mem_lw    => exe_mem_lw,
            exe_mem_lb    => exe_mem_lb,
            exe_mem_sw    => exe_mem_sw,
            exe_mem_sb    => exe_mem_sb,

            exe2mem_empty => exe2mem_empty,
            mem_pop       => mem_pop,

            ck            => ck,
            reset_n       => reset_n,
            vdd           => vdd,
            vss           => vss
        );

    -- Processus pour générer l'horloge
    clk_process :process
    begin
        while True loop
            ck <= '0';
            wait for clk_period/2;
            ck <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Processus de stimulation pour appliquer les tests
    stim_proc: process
    begin
        -- Initialisation du reset
        reset_n <= '0';
        wait for 2 ns;
        reset_n <= '1';

        -- Attente de la stabilisation
        wait for clk_period * 2;

        -- Test 1 : Opération ADD simple
        -- On teste l'addition de 5 et 3, le résultat attendue est 8
        dec_op1 <= x"00000005";  -- Opérande 1 = 5
        dec_op2 <= x"00000003";  -- Opérande 2 = 3
        dec_alu_cmd <= "00";     -- Commande ALU pour ADD
        dec2exe_empty <= '0';    -- Indique que des données sont disponibles

        wait for clk_period;

        -- Vérification du résultat
        assert exe_res = x"00000008"
            report "Erreur Test 1 : ADD 5 + 3 ne donne pas 8"
            severity error;

        -- Attente avant le prochain test
        wait for clk_period;

        -- Test 2 : Opération SUB avec le résultat négatif
        -- On teste la soustraction 3 - 5, le résultat attendue est -2
        dec_op1 <= x"00000003";  -- Opérande 1 = 3
        dec_op2 <= x"00000005";  -- Opérande 2 = 5
        dec_alu_cmd <= "00";     -- Commande ALU pour SUB
        dec_comp_op2  <= '1';
        dec_alu_cy    <= '1';

        wait for clk_period;

        -- Vérification du résultat et du flag N (négatif)
        assert exe_res = x"FFFFFFFE"
            report "Erreur Test 2 : SUB 3 - 5 ne donne pas -2"
            severity error;

        assert exe_n = '1'
            report "Erreur Test 2 : Le flag N n'est pas correctement positionné"
            severity error;

        wait for clk_period;

        -- Test 3 : Opération AND logique
        -- On teste l'opération AND entre 0xF0F0F0F0 et 0x0F0F0F0F, le résultat attendu est 0x00000000
        dec_op1 <= x"F0F0F0F0";
        dec_op2 <= x"0F0F0F0F";
        dec_alu_cmd <= "01";     -- Commande ALU pour AND (à adapter selon votre codage)
        dec_comp_op2  <= '0';
        dec_alu_cy    <= '0';

        wait for clk_period;

        -- Vérification du résultat
        assert exe_res = x"00000000"
            report "Erreur Test 3 : AND logique incorrect"
            severity error;

        wait for clk_period;

        -- Test 4 : Opération de décalage logique à gauche (LSL)
        -- On teste le décalage de 1 par 2 bits, le résultat attendue est 4
        dec_op1 <= x"00000000";
        dec_op2 <= x"00000001";
        dec_alu_cmd <= "00";
        dec_shift_lsl <= '1';
        dec_shift_val <= "00010";  -- Décalage de 2 bits

        wait for clk_period;

        -- Vérification du résultat
        assert exe_res = x"00000004"
            report "Erreur Test 4 : Décalage logique à gauche incorrect"
            severity error;

        wait for clk_period;

        -- Test 5 : Opération de chargement en mémoire (Load Word)
        -- On simule une instruction de chargement depuis l'adresse 0x1000
        dec_mem_lw <= '1';
        dec_op1 <= x"00001000";
        dec_op2 <= x"00001000";
        dec_pre_index <= '1';
        dec_mem_dest <= "0010";  -- Registre de destination
        dec_shift_lsl <= '0';
        dec_shift_val <= "00100";

        wait for clk_period;

        -- Vérification des signaux d'accès mémoire
        assert exe_mem_lw = '1'
            report "Erreur Test 5 : Signal de chargement mémoire incorrect"
            severity error;

        assert exe_mem_adr = x"00002000"
            report "Erreur Test 5 : Adresse mémoire incorrecte"
            severity error;

        reset_n <= '0';

        wait for clk_period;

        -- Test 6 : Opération de stockage en mémoire (Store Word)
        -- On simule une instruction de stockage à l'adresse 0x2000
        dec_mem_sw <= '1';
        dec_mem_data <= x"DEADBEEF";  -- Données à stocker
        dec_op1 <= x"00002000";
        dec_mem_lw <= '0';
        reset_n <= '1';

        wait for clk_period;

        -- Vérification des signaux d'accès mémoire
        assert exe_mem_sw = '1'
            report "Erreur Test 6 : Signal de stockage mémoire incorrect"
            severity error;

        assert exe_mem_data = x"DEADBEEF"
            report "Erreur Test 6 : Données mémoire incorrectes"
            severity error;

        wait for clk_period;

        -- Test 7 : Vérification du flag Zero
        -- On effectue une soustraction donnant zéro pour vérifier le flag Z
        dec_op1 <= x"00000005";
        dec_op2 <= x"00000005";
        dec_alu_cmd <= "01";     -- Commande ALU pour SUB

        wait for clk_period;

        -- Vérification du flag Z
        assert exe_z = '1'
            report "Erreur Test 7 : Le flag Z n'est pas correctement positionné"
            severity error;

        wait for clk_period;

        -- Fin des tests on quitte la boucle de process en utilisant wait
        wait;
    end process;

end Behavioral;