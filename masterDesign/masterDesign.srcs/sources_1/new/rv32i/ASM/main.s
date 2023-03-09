.global _main
.text

_main:
    ADDI x1,  x0,  1
    ADDI x2,  x0,  2
    ADDI x3,  x0,  3
    ADDI x4,  x0,  4
    ADDI x5,  x0,  5
    ADDI x6,  x0,  6
    ADDI x7,  x0,  7
    ADDI x8,  x0,  8
    ADDI x9,  x0,  9
    ADDI x10, x0, 10
    ADDI x11, x0, 11
    ADDI x12, x0, 12
    ADDI x13, x0, 13
    ADDI x14, x0, 14
    ADDI x15, x0, 15
    ADDI x16, x0, 16
    ADDI x17, x0, 17
    ADDI x18, x0, 18
    ADDI x19, x0, 19
    ADDI x20, x0, 20
    ADDI x21, x0, 21
    ADDI x22, x0, 22
    ADDI x23, x0, 23
    ADDI x24, x0, 24
    ADDI x25, x0, 25
    ADDI x26, x0, 26
    ADDI x27, x0, 27
    ADDI x28, x0, 28
    ADDI x29, x0, 29
    ADDI x30, x0, 30
    ADDI x31, x0, 31
    ADDI x1, x0, 848
    ADDI x2, x0, 1
REPEAT:
    SUB x1, x1, x2
    BNE x1, x0, REPEAT
    JALR x4, x0, -8