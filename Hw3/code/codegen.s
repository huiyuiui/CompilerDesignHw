.global codegen
codegen:
    # In code_gen_func_header
    sw ra, -4(sp)
    sw fp, -8(sp)
    sw a0, -12(sp)
    sw a1, -16(sp)
    addi sp, sp, -16
    addi fp, sp, 16

    # In INT
    li t0, 17
    addi sp, sp, -4
    sw t0, 0(sp)

    # In array_single
    lw t0, 0(sp)
    addi sp, sp, 4

    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)

    # In ident_single IDENT
    addi sp, sp, -4
    sw zero, 0(sp)

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -88(fp)

For1:
    # In INDENT LOCAL_MODE
    lw t0, -88(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 17
    addi sp, sp, -4
    sw t0, 0(sp)

    # In LESS
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    bge t1, t0, Label1

    # In INDENT LOCAL_MODE
    lw t0, -88(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In array assign get offset
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -20
    add t0, t0, fp
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -88(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In array assign store value
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sw t0, 0(t1)

    # In pop_up_symbol

    lw t0, -88(fp)
    addi t0, t0, 1
    sw t0, -88(fp)
    beq zero, zero, For1
Label1:
    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 17
    addi sp, sp, -4
    sw t0, 0(sp)

    # In array_single
    lw t0, 0(sp)
    addi sp, sp, 4

    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)
    addi sp, sp, -4
    sw zero, 0(sp)

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -88(fp)

For2:
    # In INDENT LOCAL_MODE
    lw t0, -88(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 17
    addi sp, sp, -4
    sw t0, 0(sp)

    # In LESS
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    bge t1, t0, Label2

    # In ARRAY LOCAL_MODE
    li t0, -20
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -88(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In ADD array
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    lw t1, 0(sp)
    addi sp, sp, 4
    add t0, t0, t1
    add t0, t0, fp
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -92(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -168(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In NOT_EQUAL
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    beq t0, t1, Equal2
    li t0, 1
    addi sp, sp, -4
    sw t0, 0(sp)
    beq zero, zero, Exit2
Equal2:
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)
Exit2:
While3:
    lw t0, -172(fp)
    li t1, 0
    bge t1, t0, Label3
    # In INDENT LOCAL_MODE
    lw t0, -168(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 1
    addi sp, sp, -4
    sw t0, 0(sp)

    # In SUB
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sub t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 2
    addi sp, sp, -4
    sw t0, 0(sp)

    # In DIV
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    div t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In if condition
    # In INDENT LOCAL_MODE
    lw t0, -176(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In get array value
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -96
    add t0, t0, fp
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -164(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In pointer operation
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In LESS
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    bge t1, t0, Label4

    # In ARRAY LOCAL_MODE
    li t0, -96
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -168(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In ADD array
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    lw t1, 0(sp)
    addi sp, sp, 4
    add t0, t0, t1
    add t0, t0, fp
    addi sp, sp, -4
    sw t0, 0(sp)

    # In ARRAY LOCAL_MODE
    li t0, -96
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -176(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In ADD array
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    lw t1, 0(sp)
    addi sp, sp, 4
    add t0, t0, t1
    add t0, t0, fp
    addi sp, sp, -4
    sw t0, 0(sp)

    # In pointer operation
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In complex STAR ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sw t0, 0(t1)

    # In INDENT LOCAL_MODE
    lw t0, -176(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -168(fp)

    beq zero, zero, Exit4
Label4:
   # In else
    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -172(fp)

    # In pop_up_symbol

Exit4:
   # End if statement
    # In if condition
    # In INDENT LOCAL_MODE
    lw t0, -168(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IF EQUAL
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    bne t0, t1, Label5
    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -172(fp)

    # In pop_up_symbol

Label5:
   # End if statement
    # In pop_up_symbol
    addi sp, sp, 4

    beq zero, zero, While3
Label3:
    # In INDENT LOCAL_MODE
    lw t0, -168(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In array assign get offset
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -96
    add t0, t0, fp
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INDENT LOCAL_MODE
    lw t0, -164(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In pointer operation
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In array assign store value
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sw t0, 0(t1)

    # In INDENT LOCAL_MODE
    lw t0, -92(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 1
    addi sp, sp, -4
    sw t0, 0(sp)

    # In ADD
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    add t0, t0, t1
    addi sp, sp, -4
    sw t0, 0(sp)

    # In IDENT ASSIGN
    lw t0, 0(sp)
    addi sp, sp, 4
    sw t0, -92(fp)

    # In pop_up_symbol
    addi sp, sp, 4
    addi sp, sp, 4
    addi sp, sp, 4

    lw t0, -88(fp)
    addi t0, t0, 1
    sw t0, -88(fp)
    beq zero, zero, For2
Label2:
    # In digital write
    li a0, 26
    li a1, 1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, digitalWrite
    lw ra, 0(sp)
    addi sp, sp, 4

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In get array value
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -96
    add t0, t0, fp
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In INT
    li t0, 2
    addi sp, sp, -4
    sw t0, 0(sp)

    # In get array value
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -96
    add t0, t0, fp
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In SUB
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sub t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 1000
    addi sp, sp, -4
    sw t0, 0(sp)

    # In MUL
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    mul t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In delay
    lw t0, 0(sp)
    addi sp, sp, 4
    addi a0, t0, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4

    # In digital write
    li a0, 26
    li a1, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, digitalWrite
    lw ra, 0(sp)
    addi sp, sp, 4

    # In INDENT LOCAL_MODE
    lw t0, -92(fp)
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In get array value
    lw t0, 0(sp)
    addi sp, sp, 4
    slli t0, t0, 2
    sub t0, zero, t0
    addi t0, t0, -96
    add t0, t0, fp
    lw t1, 0(t0)
    addi sp, sp, -4
    sw t1, 0(sp)

    # In SUB
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    sub t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In INT
    li t0, 1000
    addi sp, sp, -4
    sw t0, 0(sp)

    # In MUL
    lw t0, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    mul t0, t1, t0
    addi sp, sp, -4
    sw t0, 0(sp)

    # In delay
    lw t0, 0(sp)
    addi sp, sp, 4
    addi a0, t0, 0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4

    # In pop_up_symbol
    addi sp, sp, 4
    addi sp, sp, 4
    addi sp, sp, 4
    addi sp, sp, 4

    # In code_gen_at_end_of_function_body
    lw a1, -16(fp)
    lw a0, -12(fp)
    lw ra, -4(fp)
    addi sp, fp, 0
    lw fp, -8(sp)
    jalr zero, 0(ra)

