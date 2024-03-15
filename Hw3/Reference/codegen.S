.global codegen
codegen:
    sd ra, -8(sp)
    sd fp, -16(sp)
    sd a0, -24(sp)
    sd a1, -32(sp)
    mv fp, sp
    addi sp, sp, -32
    li t0, 58
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 17
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    div t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, -40(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 2
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    mul t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 10
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    add t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, -40
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, -56(fp)
    add t0, t0, fp
    ld t1, 0(t0)
    addi sp, sp, -8
    sd t1, 0(sp)
    li t0, 1
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    add t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    ld t1, -56(fp)
    add t1, fp, t1
    sd t0, 0(t1)
    li t0, -48
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    sd t0, -56(fp)
    ld t0, -48(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, -40(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    div t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    ld t1, -56(fp)
    add t1, fp, t1
    sd t0, 0(t1)
    li a0, 29
    li a1, 1
    addi sp, sp, -8
    sd ra, 0(sp)
    jal ra, digitalWrite
    ld ra, 0(sp)
    addi sp, sp, 8
    ld t0, -40(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 1000
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    mul t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 1000
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    add t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    mv a0, t0
    addi sp, sp, -8
    sd ra, 0(sp)
    jal ra, delay
    ld ra, 0(sp)
    addi sp, sp, 8
    li a0, 29
    li a1, 0
    addi sp, sp, -8
    sd ra, 0(sp)
    jal ra, digitalWrite
    ld ra, 0(sp)
    addi sp, sp, 8
    ld t0, -48(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 1000
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    mul t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 250
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 8
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    mul t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    ld t1, 0(sp)
    addi sp, sp, 8
    sub t0, t1, t0
    addi sp, sp, -8
    sd t0, 0(sp)
    ld t0, 0(sp)
    addi sp, sp, 8
    mv a0, t0
    addi sp, sp, -8
    sd ra, 0(sp)
    jal ra, delay
    ld ra, 0(sp)
    addi sp, sp, 8
addi sp, sp, 8
    ld ra, -8(fp)
    mv sp, fp
    ld fp, -16(sp)
    jalr zero, 0(ra)
