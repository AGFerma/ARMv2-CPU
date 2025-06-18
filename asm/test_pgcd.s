    .text
    .globl    _start

_start:
    B    startup

    B    _bad

startup:
    MOV R0, #8
    MOV R1, #16
    MOV R2, #32
    MOV R3, #64
    MOV R4, #128

    MOV R12, #reg0

    LDM R12, {R0, R1, R2, R3, R4}

    nop
    nop

    STM R12, {R5, R6, R7, R8, R9}

    CMP R0, R5
    BNE _bad
    CMP R1, R6
    BNE _bad
    CMP R2, R7
    BNE _bad
    CMP R3, R8
    BNE _bad
    CMP R4, R9
    BNE _bad

    B _good

_bad :
    nop
    nop

_good :
    nop
    nop

reg0:  .word 0x80000000
reg1:  .word 0x00000000
reg2:  .word 0x00000000
reg3:  .word 0x00000000
reg4:  .word 0x00000000
