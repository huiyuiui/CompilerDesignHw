.global codegen
codegen:
    addi sp, sp, -48
    sw fp, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    addi fp, sp, 0
    
    addi sp, sp, -20
    
    addi sp, sp, -4
    
    li s1, 0
    sw s1, -24(fp)
    checkloop_1:
    lw s1, -24(fp)
    li s2, 5
    slt s1, s1, s2
    beq s1, zero, endloop_1
    j stmtloop_1
    
    loop_1:
    lw s1, -24(fp)
    li s2, 1
    add s1, s1, s2
    sw s1, -24(fp)
    j checkloop_1
    
    stmtloop_1:
    lw s1, -24(fp)
    li s2, 0
    li s3, -4
    mul s1, s1, s3
    add s1, s1, fp
    sw s2, -4(s1)
    
    addi sp, sp, 0
    j loop_1
    
    endloop_1:
    
    li s1, -4
    add s1, s1, fp
    li s2, 6
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s2, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, dp_fib
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    addi sp, sp, -4
    sw s1, 0(sp)
    
    li s1, -4
    add s1, s1, fp
    li s2, 4
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s2, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, dp_fib
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    addi sp, sp, -4
    sw s1, 0(sp)
    
    li s1, 26
    li s2, 1
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s2, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, digitalWrite
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    
    lw s1, -28(fp)
    li s2, 1000
    mul s1, s1, s2
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    jal ra, delay
    addi sp, sp, 4
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    
    li s1, 26
    li s2, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s2, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, digitalWrite
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    
    lw s1, -32(fp)
    li s2, 1000
    mul s1, s1, s2
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    jal ra, delay
    addi sp, sp, 4
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    
    addi sp, sp, 32
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
.global dp_fib
dp_fib:
    addi sp, sp, -48
    sw fp, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    addi fp, sp, 0
    
    lw s1, 48(fp)
    li s2, 0
    xor s1, s1, s2
    sltu s1, s1, 1
    beq s1, zero, else_1
    
    li s1, 0
    addi a0, s1, 0
    addi sp, sp, 0
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
    
    addi sp, sp, 0
    j endif_1
    
    else_1:
    endif_1:
    
    lw s1, 48(fp)
    li s2, 1
    xor s1, s1, s2
    sltu s1, s1, 1
    beq s1, zero, else_2
    
    li s1, 1
    addi a0, s1, 0
    addi sp, sp, 0
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
    
    addi sp, sp, 0
    j endif_2
    
    else_2:
    endif_2:
    
    lw s1, 48(fp)
    li s2, 2
    sub s1, s1, s2
    addi sp, sp, -4
    sw s1, 0(sp)
    
    lw s1, -4(fp)
    lw s3, 52(fp)
    li s4, -4
    mul s1, s1, s4
    add s3, s3, s1
    lw s2, 0(s3)
    li s1, 0
    xor s2, s2, s1
    sltu s2, s2, 1
    beq s2, zero, else_3
    
    lw s1, 52(fp)
    lw s2, 48(fp)
    li s3, 2
    sub s2, s2, s3
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s1, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s2, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, dp_fib
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s1, a0, 0
    lw s2, 52(fp)
    lw s3, 48(fp)
    li s4, 1
    sub s3, s3, s4
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, s2, 0
    addi sp, sp, -4
    sw a0, 0(sp)
    addi a1, s3, 0
    addi sp, sp, -4
    sw a1, 0(sp)
    jal ra, dp_fib
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    addi s2, a0, 0
    add s1, s1, s2
    addi sp, sp, -4
    sw s1, 0(sp)
    
    lw s1, -4(fp)
    lw s2, -8(fp)
    lw s3, 52(fp)
    li s4, -4
    mul s1, s1, s4
    add s3, s3, s1
    sw s2, 0(s3)
    
    lw s1, -8(fp)
    addi a0, s1, 0
    addi sp, sp, 8
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
    
    addi sp, sp, 4
    j endif_3
    
    else_3:
    lw s1, -4(fp)
    lw s3, 52(fp)
    li s4, -4
    mul s1, s1, s4
    add s3, s3, s1
    lw s2, 0(s3)
    addi a0, s2, 0
    addi sp, sp, 4
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
    
    addi sp, sp, 0
    endif_3:
    
    addi sp, sp, 4
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    
    jalr zero, 0(ra)
    
