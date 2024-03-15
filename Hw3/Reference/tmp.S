    ld t0, -176(fp)
    addi sp, sp, -8
    sd t0, 0(sp)
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
    sd t0, -176(fp)
