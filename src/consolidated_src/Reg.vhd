library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
--quand il s'agit d'une écriture, on veut invalider le registre n puis modifié le contenue et mettre le bit valide à 1
	port(
	-- Write Port 1 prioritaire
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1			: in Std_Logic_Vector(3 downto 0);
		wen1			: in Std_Logic;

	-- Write Port 2 non prioritaire
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2			: in Std_Logic_Vector(3 downto 0);
		wen2			: in Std_Logic;

	-- Write CSPR Port
		wcry			: in Std_Logic;
		wzero			: in Std_Logic;
		wneg			: in Std_Logic;
		wovr			: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic; -- bit de validité du registre

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv		: out Std_Logic;
		reg_ovr		: out Std_Logic;
		reg_vv		: out Std_Logic;
		
	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck				: in Std_Logic;
		reset_n		: in Std_Logic; -- active à l'état bas 
		vdd			: in bit;
		vss			: in bit);
end Reg;

architecture Behavior OF Reg is
	type tab_reg is array (0 to 15) of std_logic_vector(31 downto 0);
	signal registres : tab_reg;
	signal wen : std_logic_vector(1 downto 0);
	signal reg_validity : std_logic_vector(15 downto 0) := (others => '1');--Initialisation à '1' : Au reset, tous les registres sont considérés comme valides, même s'ils ne contiennent pas de valeur pertinente.
    --Chaque bit reg_validity(i) correspond au registre d'adresse i.
	-- Déclarations des flags 
	signal flag_C : std_logic := '0'; -- en etat initiale, pas de flag
	signal flag_Z : std_logic := '0'; 
	signal flag_N : std_logic := '0'; 
	signal flag_V : std_logic := '0'; 
	-- Bits de validité pour les flags 
	signal validity_CZN : std_logic := '1';  -- toujours valide en initialisation 
	signal validity_V : std_logic := '1';
	signal quatre_32: std_logic_vector(31 downto 0);

    begin 


	process(ck,reset_n)
	begin 


		if rising_edge(ck) then 
			if reset_n='0' then 
				--mettre à 0 deja implementer dans la description structural
				reg_validity <= (others=>'1'); 
				validity_CZN <= '1'; 
				validity_V <= '1'; 
				flag_C <= '0'; 
				flag_Z <= '0'; 
				flag_N <= '0'; 
				flag_V <= '0';
				registres(15)<=(others=>'0');

			else

			
				if inval1 = '1' then 
					reg_validity(to_integer(unsigned(inval_adr1)))<='0'; --reg_validity(indice)
				end if;
				if inval2 = '1' then
					reg_validity(to_integer(unsigned(inval_adr2)))<='0';
				end if;
				

				if wen1 = '1' and reg_validity(to_integer(unsigned(wadr1))) = '0' then --ici si écriture dans un registre qui n'est pas valide
					registres(to_integer(unsigned(wadr1)))<=wdata1;
					if ((wadr1 /= inval_adr1) and (wadr1 /= inval_adr2)) or ((wadr1 = inval_adr1) and inval1 = '0') or ((wadr1 = inval_adr2) and inval2 = '0') then
						reg_validity(to_integer(unsigned(wadr1))) <= '1'; -- d'apres écriture, on valide ce registre
					end if;
				end if;

				if wen2 = '1' and reg_validity(to_integer(unsigned(wadr2))) = '0' and wadr2 /= wadr1 then --ici si écriture dans un registre qui n'est pas valide
					registres(to_integer(unsigned(wadr2)))<=wdata2;
					if ((wadr2 /= inval_adr1) and (wadr2 /= inval_adr2)) or ((wadr2 = inval_adr1) and inval1 = '0') or ((wadr2 = inval_adr2) and inval2 = '0') then
						reg_validity(to_integer(unsigned(wadr1))) <= '1'; -- d'apres écriture, on valide ce registre
					end if; 
				end if;
				-- invalidation des flags 
				if inval_czn='1' then
					validity_CZN <= '0';
				end if;
				if inval_ovr = '1' then 
					validity_V <= '0'; 
				end if;

				if cspr_wb = '1' then -- si on demande une mise a jour des flags
					if validity_CZN = '0' then -- on renouvelle les flags seulement dans le cas ou ils sont invalide qui attentent d'etre renouvllé
						flag_C <= wcry;
						flag_Z <= wzero;
						flag_N <= wneg;
						validity_CZN <= '1'; -- une fois opération est fait, on met a jour la validité des fags 
					end if;
					if validity_V = '0' then
						flag_V <= wovr;
						validity_V <= '1';
					end if;
				end if;
				--gestion du program counter 
				if inc_pc = '1' then 
						registres(15) <=quatre_32;
				end if;

			
			end if;
		end if;
		
		


	end process;

	Adder_PC:entity work.CLA_Add_w32
	port map (A=>registres(15),B=>"00000000000000000000000000000100",ci=>'0',S=>quatre_32);
	reg_pc <= registres(15); -- reg15 contient la du PC 
	reg_pcv <= reg_validity(15);

	reg_rd1 <= registres(to_integer(unsigned(radr1))); -- ne plus besoin de MUX
	reg_v1 <= reg_validity(to_integer(unsigned(radr1))); 

	reg_rd2 <= registres(to_integer(unsigned(radr2))); 
	reg_v2 <= reg_validity(to_integer(unsigned(radr2))); 

	reg_rd3 <= registres(to_integer(unsigned(radr3))); 
	reg_v3 <= reg_validity(to_integer(unsigned(radr3)));

	-- Assignation des flags aux ports de sortie 
	reg_cry <= flag_C; 
	reg_zero <= flag_Z; 
	reg_neg <= flag_N; 
	reg_cznv <= validity_CZN; 

	reg_ovr <= flag_V; 
	reg_vv <= validity_V;




			
end Behavior;