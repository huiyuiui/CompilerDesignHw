#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code.h"

void init() {
    cur_counter = 0;
    cur_label = 0;
    cur_scope = 0;
    cur_label_stack_size = 0;
}

char *install_symbol(char *s) {
    if (cur_counter >= MAX_TABLE_SIZE) {
        perror("Symbol Table Full");
    } else {
        cur_local_var++;
        table[cur_counter].scope = cur_scope;
        table[cur_counter].name = copys(s);
        table[cur_counter].offset = cur_local_var;
        table[cur_counter].mode = LOCAL_MODE;
        table[cur_counter].type = T_OTHER;
        cur_counter++;
    }
    // printf("%s: offset = %d\n", table[cur_counter-1].name, table[cur_counter-1].offset);
    return s;
}

char *install_array_symbol(char *s, int n) {
    if (cur_counter >= MAX_TABLE_SIZE) {
        perror("Symbol Table Full");
    } else {
        cur_local_var++;
        table[cur_counter].scope = cur_scope;
        table[cur_counter].name = copys(s);
        table[cur_counter].offset = cur_local_var;
        table[cur_counter].mode = LOCAL_MODE;
        table[cur_counter].type = T_POINTER;
        cur_local_var += n - 1;
        cur_counter++;
    }
    return s;
}

int look_up_symbol(char *s) {
    int i;
    if (cur_counter == 0) return -1;
    for (i = cur_counter - 1; i >= 0; i--) {
        if (strcmp(s, table[i].name) == 0) return i;
    }
    return -1;
}

void pop_up_symbol(int scope) {
    int i;
    if (cur_counter == 0) return;
    for (i = cur_counter - 1; i >= 0; i++) {
        if (table[i].scope != scope)
            break;
        cur_local_var--;
        fprintf(f_asm, "addi sp, sp, 8\n");
    }
    cur_counter = i + 1;
}

void set_scope_and_offset_of_param(char *s) {
    int i, j, index;
    int total_args;
    cur_local_var = 0;
    index = look_up_symbol(s);
    if (index < 0) perror("Error in function header");
    else {
        table[index].type = T_FUNCTION;
        total_args = cur_counter - index - 1;
        table[index].total_args = total_args;
        for (j = total_args, i = cur_counter - 1; i > index; i--, j--) {
            table[i].scope = cur_scope;
            table[i].offset = j;
            table[i].mode = ARGUMENT_MODE;
            cur_local_var++;
        }
    }
}

void push_label(int L) {
    if (cur_label_stack_size == MAX_LABEL_STACK_SIZE) perror("Label stack is full");
    else label_stack[cur_label_stack_size++] = L;
}

int pop_label() {
    if (cur_label_stack_size == 0) perror("Label stack is empty");
    else {
        cur_label_stack_size--;
        return label_stack[cur_label_stack_size];
    }
}

void code_gen_func_header(char *functor) {
    fprintf(f_asm, "%s:\n", functor);
    fprintf(f_asm, "    sd ra, -8(sp)\n");
    fprintf(f_asm, "    sd fp, -16(sp)\n");
    fprintf(f_asm, "    sd a0, -24(sp)\n");
    fprintf(f_asm, "    sd a1, -32(sp)\n");
    fprintf(f_asm, "    mv fp, sp\n");
    fprintf(f_asm, "    addi sp, sp, -32\n");
}

void code_gen_at_end_of_function_body(char *functor) {
    fprintf(f_asm, "    ld ra, -8(fp)\n");
    fprintf(f_asm, "    mv sp, fp\n");
    fprintf(f_asm, "    ld fp, -16(sp)\n");
    fprintf(f_asm, "    jalr zero, 0(ra)\n");
}

char *copys(char *s) {
    char *n = (char*)malloc(sizeof(char)*(strlen(s)+1));
    strcpy(n, s);
    return n;
}