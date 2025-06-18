library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_tb is
end Reg_tb;

architecture behavior of Reg_tb is 
signal wdata1      : Std_Logic_Vector(31 downto 0);
signal wadr1       : Std_Logic_Vector(3 downto 0);
signal wen1        : Std_Logic;

signal wdata2      : Std_Logic_Vector(31 downto 0);
signal wadr2       : Std_Logic_Vector(3 downto 0);
signal wen2        : Std_Logic;

signal wcry        : Std_Logic;
signal wzero       : Std_Logic;
signal wneg        : Std_Logic;
signal wovr        : Std_Logic;
signal cspr_wb     : Std_Logic;

signal reg_rd1     : Std_Logic_Vector(31 downto 0);
signal radr1       : Std_Logic_Vector(3 downto 0);
signal reg_v1      : Std_Logic;

signal reg_rd2     : Std_Logic_Vector(31 downto 0);
signal radr2       : Std_Logic_Vector(3 downto 0);
signal reg_v2      : Std_Logic;

signal reg_rd3     : Std_Logic_Vector(31 downto 0);
signal radr3       : Std_Logic_Vector(3 downto 0);
signal reg_v3      : Std_Logic;

signal reg_cry     : Std_Logic;
signal reg_zero    : Std_Logic;
signal reg_neg     : Std_Logic;
signal reg_cznv    : Std_Logic;
signal reg_ovr     : Std_Logic;
signal reg_vv      : Std_Logic;

signal inval_adr1  : Std_Logic_Vector(3 downto 0);
signal inval1      : Std_Logic;

signal inval_adr2  : Std_Logic_Vector(3 downto 0);
signal inval2      : Std_Logic;

signal inval_czn   : Std_Logic;
signal inval_ovr   : Std_Logic;

signal reg_pc      : Std_Logic_Vector(31 downto 0);
signal reg_pcv     : Std_Logic;
signal inc_pc      : Std_Logic;

signal ck          : Std_Logic := '0';
signal reset_n     : Std_Logic;
signal vdd         : bit := '1';
signal vss         : bit := '0';

    -- Définition de la période d'horloge
constant clk_period : time := 10 ns;
begin
    Reg: entity work.Reg 
    port map (
        wdata1      => wdata1,
        wadr1       => wadr1,
        wen1        => wen1,

        wdata2      => wdata2,
        wadr2       => wadr2,
        wen2        => wen2,

        wcry        => wcry,
        wzero       => wzero,
        wneg        => wneg,
        wovr        => wovr,
        cspr_wb     => cspr_wb,

        reg_rd1     => reg_rd1,
        radr1       => radr1,
        reg_v1      => reg_v1,

        reg_rd2     => reg_rd2,
        radr2       => radr2,
        reg_v2      => reg_v2,

        reg_rd3     => reg_rd3,
        radr3       => radr3,
        reg_v3      => reg_v3,

        reg_cry     => reg_cry,
        reg_zero    => reg_zero,
        reg_neg     => reg_neg,
        reg_cznv    => reg_cznv,
        reg_ovr     => reg_ovr,
        reg_vv      => reg_vv,

        inval_adr1  => inval_adr1,
        inval1      => inval1,

        inval_adr2  => inval_adr2,
        inval2      => inval2,

        inval_czn   => inval_czn,
        inval_ovr   => inval_ovr,

        reg_pc      => reg_pc,
        reg_pcv     => reg_pcv,
        inc_pc      => inc_pc,

        ck          => ck,
        reset_n     => reset_n,
        vdd         => vdd,
        vss         => vss
    );

    clk_process :process
    begin
        while True loop
            ck <= '0';
            wait for clk_period/2;
            ck <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    stim_proc: process
    begin
        -- Initialisation des entrées
        reset_n     <= '0';
        wdata1      <= (others => '0');
        wadr1       <= (others => '0');
        wen1        <= '0';

        wdata2      <= (others => '0');
        wadr2       <= (others => '0');
        wen2        <= '0';

        wcry        <= '0';
        wzero       <= '0';
        wneg        <= '0';
        wovr        <= '0';
        cspr_wb     <= '0';

        radr1       <= (others => '0');
        radr2       <= (others => '0');
        radr3       <= (others => '0');

        inval_adr1  <= (others => '0');
        inval1      <= '0';

        inval_adr2  <= (others => '0');
        inval2      <= '0';

        inval_czn   <= '0';
        inval_ovr   <= '0';

        inc_pc      <= '0';

        wait for 20 ns;
        
        -- Application du reset
        reset_n <= '1';
        wait for clk_period*2;

        -- Test 1: Vérification que tous les registres sont valides après le reset
        assert reg_pcv = '1' report "Erreur : PC non valide après le reset" severity error;
        for i in 0 to 15 loop
            radr1 <= std_logic_vector(to_unsigned(i, 4));
            wait for clk_period;
            assert reg_v1 = '1' report "Erreur : Registre " & integer'image(i) & " non valide après le reset" severity error;
        end loop;

        -- Test 2: Invalidation d'un registre et tentative d'écriture
        inval_adr1 <= "0001"; -- Invalide le registre 1
        inval1     <= '1'; -- invalide a 1 permet de mettre ce registre est invalide
        wait for clk_period;
        inval1     <= '0';

        -- Vérification que le registre 1 est invalide
        radr1 <= "0001";
        wait for clk_period;
        assert reg_v1 = '0' report "Erreur : Registre 1 devrait être invalide" severity error;

        -- Écriture dans le registre invalide (devrait réussir)
        wdata1  <= x"AAAAAAAA";
        wadr1   <= "0001";
        wen1    <= '1';
        wait for clk_period;
        wen1    <= '0';

        -- Vérification que le registre 1 est maintenant valide et contient les bonnes données
        wait for clk_period;
        radr1 <= "0001";
        wait for clk_period;
        assert reg_v1 = '1' report "Erreur : Registre 1 devrait être valide après écriture" severity error;
        assert reg_rd1 = x"AAAAAAAA" report "Erreur : Données incorrectes dans le registre 1" severity error;
        -- Test 3: Tentative d'écriture dans un registre valide (ne devrait pas écrire)
        wdata1  <= x"BBBBBBBB";
        wadr1   <= "0001"; -- Registre 1 est valide
        wen1    <= '1';
        wait for clk_period;
        wen1    <= '0';
    
        -- Vérification que les données n'ont pas changé car le reg_v1 est toujour à '1'
        wait for clk_period;
        radr1 <= "0001";
        wait for clk_period;
        assert reg_rd1 = x"AAAAAAAA" report "Erreur : Registre 1 n'aurait pas dû être modifié" severity error;

        -- Test 4: Écritures simultanées dans le même registre depuis EXEC et MEM
        -- Invalidation du registre 2 afin de permettre son écriture 
        inval_adr1 <= "0010"; -- Invalide le registre 2
        inval1     <= '1';
        wait for clk_period;
        inval1     <= '0';

        -- Écritures simultanées vers le registre 2
        wdata1  <= x"11111111"; -- Écriture depuis EXEC (prioritaire)
        wadr1   <= "0010";
        wen1    <= '1';

        wdata2  <= x"22222222"; -- Écriture depuis MEM
        wadr2   <= "0010";
        wen2    <= '1';

        wait for clk_period;
        wen1    <= '0';
        wen2    <= '0';

        -- Vérification que les données de EXEC ont été écrites
        wait for clk_period;
        radr1 <= "0010";
        wait for clk_period;
        assert reg_rd1 = x"11111111" report "Erreur : Registre 2 devrait contenir les données de EXEC" severity error;

        -- Test 5: Incrémentation du PC
        inc_pc <= '1';
        wait for clk_period;
        inc_pc <= '0';

        -- Vérification que le PC a été incrémenté de 4
        wait for clk_period;

        assert reg_pc = x"00000004" report "Erreur: PC devrait être incrémenté de 4" severity error;


        -- Test 6: Écriture des flags C, Z, N, V
        -- Invalidation des flags
        inval_czn <= '1';
        inval_ovr <= '1';
        wait for clk_period;
        inval_czn <= '0';
        inval_ovr <= '0';

        -- Vérification que les flags sont invalides
        wait for clk_period;
        assert reg_cznv = '0' report "Erreur : Flags CZN devraient être invalides" severity error;
        assert reg_vv = '0' report "Erreur : Flag V devrait être invalide" severity error;

        -- Écriture des flags
        wcry    <= '1';
        wzero   <= '0';
        wneg    <= '1';
        wovr    <= '1';
        cspr_wb <= '1';
        wait for clk_period;
        cspr_wb <= '0';

        -- Vérification que les flags ont été mis à jour et sont valides
        wait for clk_period;
        assert reg_cznv = '1' report "Erreur : Flags CZN devraient être valides" severity error;
        assert reg_vv = '1' report "Erreur : Flag V devrait être valide" severity error;
        assert reg_cry = '1' report "Erreur : Flag C incorrect" severity error;
        assert reg_zero = '0' report "Erreur : Flag Z incorrect" severity error;
        assert reg_neg = '1' report "Erreur : Flag N incorrect" severity error;
        assert reg_ovr = '1' report "Erreur : Flag V incorrect" severity error;
        -- Test 7: Invalidation du PC et écriture
        inval_adr1 <= "1111"; -- Invalide le PC (registre 15)
        inval1     <= '1';
        wait for clk_period;
        inval1     <= '0';

        -- Vérification que le PC est invalide
        wait for clk_period;
        assert reg_pcv = '0' report "Erreur : PC devrait être invalide" severity error;

        -- Écriture dans le PC (devrait réussir car invalide)
        wdata1  <= x"12345678";
        wadr1   <= "1111"; -- Adresse du PC
        wen1    <= '1';
        wait for clk_period;
        wen1    <= '0';

        -- Vérification que le PC est maintenant valide et contient les nouvelles données
        wait for clk_period;
        assert reg_pcv = '1' report "Erreur : PC devrait être valide après écriture" severity error;
        assert reg_pc = x"12345678" report "Erreur : Données incorrectes dans le PC" severity error;

        -- Test 8: Tentative d'écriture dans des flags valides (ne devrait pas mettre à jour)
        -- Les flags sont actuellement valides, tentative d'écriture
        wcry    <= '0';
        wzero   <= '1';
        wneg    <= '0';
        wovr    <= '0';
        cspr_wb <= '1';
        wait for clk_period;
        cspr_wb <= '0';

        -- Vérification que les flags n'ont pas changé
        wait for clk_period;
        assert reg_cry = '1' report "Erreur : Flag C n'aurait pas dû changer" severity error;
        assert reg_zero = '0' report "Erreur : Flag Z n'aurait pas dû changer" severity error;
        assert reg_neg = '1' report "Erreur : Flag N n'aurait pas dû changer" severity error;
        assert reg_ovr = '1' report "Erreur : Flag V n'aurait pas dû changer" severity error;

        -- Fin de la simulation
        wait for 50 ns;
        report "Simulation terminée avec succès";
        wait;

    end process;



end behavior;
