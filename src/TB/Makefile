GHDL=/usr/bin/ghdl-gcc
GHDL_OP = -v
C_MOD_DIR = ../C_model/
all : main_tb

ram.o : ram.vhdl
	${GHDL} -a ${GHDL_OP} ram.vhdl

icache.o : icache.vhdl ram.o
	${GHDL} -a ${GHDL_OP} icache.vhdl

dcache.o : dcache.vhdl ram.o
	${GHDL} -a ${GHDL_OP} dcache.vhdl

main_tb.o : main_tb.vhdl icache.o dcache.o ram.o
	rm *.o
	rm *.cf
	${GHDL} -a ${GHDL_OP} main_tb.vhdl

arm_core.o : ../CORE/arm_core.vhdl ifetch.o decod.o exec.o mem.o
	${GHDL} -a ${GHDL_OP} ../CORE/arm_core.vhdl
	
ifetch.o : ../IFETCH/ifetch.vhdl fifo.o
	${GHDL} -a ${GHDL_OP} ../IFETCH/ifetch.vhdl

fifo.o : ../FIFO/fifo.vhdl
	${GHDL} -a ${GHDL_OP} ../FIFO/fifo.vhdl

decod.o : ../DECOD/decod.vhdl fifo_32b.o fifo_127b.o reg.o
	${GHDL} -a ${GHDL_OP} ../DECOD/decod.vhdl

reg.o : ../DECOD/reg.vhdl CLA_Add_w32.o
	${GHDL} -a ${GHDL_OP} ../DECOD/reg.vhdl

exec.o : ../EXEC/exec.vhdl fifo_72b.o ALU.o shifter.o
	${GHDL} -a ${GHDL_OP} ../EXEC/exec.vhdl

fifo_32b.o : ../FIFO/fifo_32b.vhd
	${GHDL} -a ${GHDL_OP} ../FIFO/fifo_32b.vhd

fifo_72b.o : ../FIFO/fifo_72b.vhd
	${GHDL} -a ${GHDL_OP} ../FIFO/fifo_72b.vhd

fifo_127b.o : ../FIFO/fifo_127b.vhd
	${GHDL} -a ${GHDL_OP} ../FIFO/fifo_127b.vhd

ALU.o : ../EXEC/ALU.vhd CLA_Add_w32.o
	${GHDL} -a ${GHDL_OP} ../EXEC/ALU.vhd

FA.o : ../EXEC/FA.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/FA.vhd

RC_Add_w4.o : ../EXEC/RC_Add_w4.vhd FA.o
	${GHDL} -a ${GHDL_OP} ../EXEC/RC_Add_w4.vhd

CLA_Add_w16.o : ../EXEC/CLA_Add_w16.vhd RC_Add_w4.o MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/CLA_Add_w16.vhd

CLA_Add_w32.o : ../EXEC/CLA_Add_w32.vhd CLA_Add_w16.o
	${GHDL} -a ${GHDL_OP} ../EXEC/CLA_Add_w32.vhd

shifter.o : ../EXEC/Shifter.vhd Left_shifter.o Right_shifter_arith.o Right_shifter_log.o Rotate_right_extended.o Rotate_right.o
	${GHDL} -a ${GHDL_OP} ../EXEC/Shifter.vhd

Left_shifter.o : ../EXEC/Left_shifter.vhd MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/Left_shifter.vhd

Right_shifter_arith.o : ../EXEC/Right_shifter_arith.vhd MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/Right_shifter_arith.vhd

Right_shifter_log.o : ../EXEC/Right_shifter_log.vhd MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/Right_shifter_log.vhd

Rotate_right.o : ../EXEC/Rotate_right.vhd MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/Rotate_right.vhd

Rotate_right_extended.o : ../EXEC/Rotate_right.vhd MUX
	${GHDL} -a ${GHDL_OP} ../EXEC/Rotate_right_extended.vhd

MUX : MUX2_1w1.o MUX2_1w2.o MUX2_1w4.o MUX2_1w16.o MUX2_1w32.o MUX4_1w32.o

MUX2_1w1.o : ../EXEC/MUX2_1w1.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX2_1w1.vhd

MUX2_1w2.o : ../EXEC/MUX2_1w2.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX2_1w2.vhd

MUX2_1w4.o : ../EXEC/MUX2_1w4.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX2_1w4.vhd

MUX2_1w16.o : ../EXEC/MUX2_1w16.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX2_1w16.vhd

MUX2_1w32.o : ../EXEC/MUX2_1w32.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX2_1w32.vhd

MUX4_1w32.o : ../EXEC/MUX4_1w32.vhd
	${GHDL} -a ${GHDL_OP} ../EXEC/MUX4_1w32.vhd

mem.o : ../MEM/mem.vhdl
	${GHDL} -a ${GHDL_OP} ../MEM/mem.vhdl

main_tb : main_tb.o ram.o icache.o dcache.o arm_core.o ${C_MOD_DIR}/lib/arm_ghdl.o
	${GHDL} -e ${GHDL_OP} -Wl,${C_MOD_DIR}/lib/mem.o -Wl,${C_MOD_DIR}/lib/arm_ghdl.o -Wl,${C_MOD_DIR}/ReadElf/lib/ElfObj.o main_tb

clean :
	rm *.o main_tb work-obj93.cf *.vcd
