signal mtrans_pc_target : std_logic;

    when MTRANS =>
        debug_state <= X"5";
        dec2exe_push <= '0';
    
        if mtrans_list = "0000000000000000" then
            -- Si la liste est vide
            if mtrans_pc_target = '1' then
                -- Si R15 (PC) était ciblé, passer à BRANCH
                next_state <= BRANCH;
            else
                -- Sinon, retour à RUN
                next_state <= RUN;
            end if;
        else
        -- Cette alternance entre mtrans_loop_adr = '0' et mtrans_loop_adr = '1' est utilisée pour introduire un cycle d'attente et s'assurer que chaque étape dans le traitement des registres du transfert multiple est correctement effectuée en une période d'horloge.
            -- Continuer le traitement des registres
            if mtrans_loop_adr = '0' then
                -- Préparer la boucle pour le traitement
                mtrans_loop_adr <= '1';
                next_state <= MTRANS;
            else
                -- Prochaine itération
                mtrans_loop_adr <= '0'; -- Réinitialiser pour le prochain cycle
                next_state <= MTRANS; -- Rester dans l'état pour continuer
            end if;
        end if;

        process (ck)
        begin
            if rising_edge(ck) then
                if reset_n = '0' then
                    -- Réinitialisation
                    mtrans_mask <= (others => '0');
                    mtrans_list <= (others => '0');
                    mtrans_rd <= "0000";
                    mtrans_nbr <= "00000";
                    mtrans_loop_adr <= '0';
                    mtrans_pc_target <= '0';
                else
                    if cur_state = MTRANS then
                        if mtrans_loop_adr = '1' then
                            if mtrans_list /= "0000000000000000" then     
                                -- Décalage du masque et mise à jour de la liste
                                mtrans_mask_shift <= std_logic_vector(shift_left(unsigned(mtrans_mask), 1));
                                mtrans_list <= mtrans_list and not mtrans_mask_shift; -- Marquer le registre traité
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end process;
        --quand mtrans_list est changé dans le process ck (ceci prendra 1 cycle)
        process (mtrans_list)
        begin
            if mtrans_list = "0000000000000000" then
                -- Tous les registres ont été traités
                mtrans_loop_adr <= '0'; -- Réinitialisation du signal de boucle
                mtrans_nbr <= "00000";  -- Plus de registres actifs
            else
                -- Identifier le premier registre actif
                mtrans_rd <= "0000" when mtrans_list(0) = '1' else
                             "0001" when mtrans_list(1) = '1' else
                             "0010" when mtrans_list(2) = '1' else
                             "0011" when mtrans_list(3) = '1' else
                             "0100" when mtrans_list(4) = '1' else
                             "0101" when mtrans_list(5) = '1' else
                             "0110" when mtrans_list(6) = '1' else
                             "0111" when mtrans_list(7) = '1' else
                             "1000" when mtrans_list(8) = '1' else
                             "1001" when mtrans_list(9) = '1' else
                             "1010" when mtrans_list(10) = '1' else
                             "1011" when mtrans_list(11) = '1' else
                             "1100" when mtrans_list(12) = '1' else
                             "1101" when mtrans_list(13) = '1' else
                             "1110" when mtrans_list(14) = '1' else
                             "1111";
        
                -- Compter les registres restants
                mtrans_nbr <= std_logic_vector(to_unsigned(count_ones(mtrans_list), 5));
        
                -- Activer la boucle pour continuer le traitement
                mtrans_loop_adr <= '1';
            end if;
        end process;


