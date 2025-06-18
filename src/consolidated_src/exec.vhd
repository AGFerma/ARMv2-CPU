library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Exec is
	port(
	-- Decode interface synchro
			dec2exe_empty	: in Std_logic;
			exe_pop			: out Std_logic;

	-- Decode interface operands
			dec_op1			: in Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: in Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: in Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: in Std_Logic; -- Rd destination write back
			dec_flag_wb		: in Std_Logic; -- CSPR modifiy

	-- Decode to mem interface 
			dec_mem_data	: in Std_Logic_Vector(31 downto 0); -- data to MEM W
			dec_mem_dest	: in Std_Logic_Vector(3 downto 0); -- Destination MEM R
			dec_pre_index 	: in Std_logic;

			dec_mem_lw		: in Std_Logic;
			dec_mem_lb		: in Std_Logic;
			dec_mem_sw		: in Std_Logic;
			dec_mem_sb		: in Std_Logic;

	-- Shifter command
			dec_shift_lsl	: in Std_Logic;
			dec_shift_lsr	: in Std_Logic;
			dec_shift_asr	: in Std_Logic;
			dec_shift_ror	: in Std_Logic;
			dec_shift_rrx	: in Std_Logic;
			dec_shift_val	: in Std_Logic_Vector(4 downto 0);
			dec_cy			: in Std_Logic;

	-- Alu operand selection
			dec_comp_op1	: in Std_Logic;
			dec_comp_op2	: in Std_Logic;
			dec_alu_cy 		: in Std_Logic;

	-- Alu command
			dec_alu_cmd		: in Std_Logic_Vector(1 downto 0);

	-- Exe bypass to decod
			exe_res			: out Std_Logic_Vector(31 downto 0);

			exe_c				: out Std_Logic;
			exe_v				: out Std_Logic;
			exe_n				: out Std_Logic;
			exe_z				: out Std_Logic;

			exe_dest			: out Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: out Std_Logic; -- Rd destination write back
			exe_flag_wb		: out Std_Logic; -- CSPR modifiy

	-- Mem interface
			exe_mem_adr		: out Std_Logic_Vector(31 downto 0); -- Alu res register
			exe_mem_data	: out Std_Logic_Vector(31 downto 0);
			exe_mem_dest	: out Std_Logic_Vector(3 downto 0);

			exe_mem_lw		: out Std_Logic;
			exe_mem_lb		: out Std_Logic;
			exe_mem_sw		: out Std_Logic;
			exe_mem_sb		: out Std_Logic;

			exe2mem_empty	: out Std_logic;
			mem_pop			: in Std_logic;

	-- global interface
			ck					: in Std_logic;
			reset_n			: in Std_logic;
			vdd				: in bit;
			vss				: in bit);
end Exec;

----------------------------------------------------------------------

architecture Behavior OF Exec is

component fifo_72b
	port(
		din			: in std_logic_vector(71 downto 0);
		dout			: out std_logic_vector(71 downto 0);

		-- commands
		push			: in std_logic;
		pop			: in std_logic;

		-- flags
		full			: out std_logic;
		empty			: out std_logic;

		reset_n		: in std_logic;
		ck				: in std_logic;
		vdd			: in bit;
		vss			: in bit);
end component;

signal shift_c 	: std_logic;
signal alu_c 		: std_logic;

signal op2			: std_logic_vector(31 downto 0);
signal op2_shift	: std_logic_vector(31 downto 0);
signal op1			: std_logic_vector(31 downto 0);

signal neg_op1, neg_op2_shift : std_logic_vector(31 downto 0);


signal alu_res		: std_logic_vector(31 downto 0);
signal res_reg		: std_logic_vector(31 downto 0);
signal mem_adr		: std_logic_vector(31 downto 0);

signal exe_push 	: std_logic;
signal exe2mem_full	: std_logic;
signal mem_acces	: std_logic;

signal adr_mod : std_logic;
begin

--  Component instantiation.
	shifter : entity work.Shifter
	port map(shift_lsl=>dec_shift_lsl, shift_lsr=>dec_shift_lsr, shift_asr=>dec_shift_asr,
	shift_ror=>dec_shift_ror, shift_rrx=>dec_shift_rrx, cin=>dec_cy, shift_val=>dec_shift_val, din=>dec_op2, dout=>op2_shift,
	vdd=>vdd, vss=>vss);

	compute : entity work.ALU
	port map(op1=>op1, op2=>op2, cin=>dec_alu_cy, cmd=>dec_alu_cmd, res=>alu_res, cout=>exe_c,
	v=>exe_v, n=>exe_n, z=>exe_z, vdd=>vdd, vss=>vss);

	addr_choice : entity work.MUX2_1w32
	port map(x=>dec_op1, y=>alu_res, s=>adr_mod, m=>mem_adr);

	exec2mem : fifo_72b
	port map (	din(71)	 => dec_mem_lw,
					din(70)	 => dec_mem_lb,
					din(69)	 => dec_mem_sw,
					din(68)	 => dec_mem_sb,

					din(67 downto 64) => dec_mem_dest,
					din(63 downto 32) => dec_mem_data,
					din(31 downto 0)	 => mem_adr,

					dout(71)	 => exe_mem_lw,
					dout(70)	 => exe_mem_lb,
					dout(69)	 => exe_mem_sw,
					dout(68)	 => exe_mem_sb,

					dout(67 downto 64) => exe_mem_dest,
					dout(63 downto 32) => exe_mem_data,
					dout(31 downto 0)	 => exe_mem_adr,

					push		 => exe_push,
					pop		 => mem_pop,

					empty		 => exe2mem_empty,
					full		 => exe2mem_full,

					reset_n	 => reset_n,
					ck			 => ck,
					vdd		 => vdd,
					vss		 => vss);

-- synchro
	adr_mod <= dec_pre_index;
	--mem_adr <= X"00000000";
	-- memd_adr prend l'adr de base sans modif si pas de shift, pas de pre indexation
	mem_acces <= dec_mem_lw or dec_mem_lb or dec_mem_sw or dec_mem_sb;
	exe_push <= mem_acces and not exe2mem_full;

	exe_pop	<= ((mem_acces and not exe2mem_full) or not mem_acces) and not dec2exe_empty;

-- ALU operandes
	neg_op1 <= not(dec_op1);

	op1_sel : entity work.MUX2_1w32
	port map(x=>dec_op1, y=>neg_op1, s=>dec_comp_op1, m=>op1);

	op2_sel : entity work.MUX2_1w32
	port map(x=>op2_shift, y=>neg_op2_shift, s=>dec_comp_op2, m=>op2);

	neg_op2_shift <= not op2_shift;

-- Loop dec

	exe_dest <= dec_exe_dest;
	exe_wb <= dec_exe_wb ;
	exe_flag_wb <= dec_flag_wb and not mem_acces;

	exe_res <= alu_res;
end Behavior;
