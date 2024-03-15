#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code.h"

FILE* f_asm;
int cur_scope;
int cur_counter;
int cur_local;
int cur_label;
int cur_label_stack_size;
int label_stack[MAX_LABEL_STACK_SIZE];
struct symbol_entry table[MAX_TABLE_SIZE];

char *install_symbol(char *s)
{
    if (cur_counter >= MAX_TABLE_SIZE)
        perror("Symbol Table Full\n");
    else
    {
        cur_local++;
        table[cur_counter].scope = cur_scope;
        table[cur_counter].name = copy(s);
        table[cur_counter].offset = cur_local;
        table[cur_counter].mode = LOCAL_MODE;
        table[cur_counter].type = T_TYPE;
        cur_counter++;
    }
    return s;
}

char *install_array(char *s, int n){
    if (cur_counter >= MAX_TABLE_SIZE)
        perror("Symbol Table Full\n");
    else
    {
        cur_local++;
        table[cur_counter].scope = cur_scope;
        table[cur_counter].name = copy(s);
        table[cur_counter].offset = cur_local;
        table[cur_counter].mode = LOCAL_MODE;
        table[cur_counter].type = T_ARRAY;
        cur_local += n - 1;
        cur_counter++;
    }
    return s;
}

char *copy(char *s)
{
    int len = strlen(s) + 1;
    char *rtnStr = malloc(sizeof(char) * len);
    strcpy(rtnStr, s);
    return rtnStr;
}

int look_up_symbol(char *s)
{
    int i;

    if (cur_counter == 0)
        return -1;
    for (i = cur_counter - 1; i >= 0; i--)
    {
        if (strcmp(s, table[i].name) == 0)
        {
            return i;
        }
    }
    return -1;
}

void pop_up_symbol(int scope)
{
    int i;
    if (cur_counter == 0)
        return;
    fprintf(f_asm, "    # In pop_up_symbol\n");
    for (i = cur_counter - 1; i >= 0; i--)
    {
        if (table[i].scope != scope)
            break;
        fprintf(f_asm, "    addi sp, sp, 4\n");
    }
    if (i < 0)
        cur_counter = 0;
    cur_counter = i + 1;
    fprintf(f_asm, "\n");
}

void set_scope_and_offset_of_param(char *s)
{
    if(s == NULL)
        return;
    int i, j, index;
    int total_args;
    index = look_up_symbol(s);
    if (index < 0)
        perror("Error in function header\n");
    else
    {
        table[index].type = T_FUNCITON;
        total_args = cur_counter - index - 1;
        table[index].total_args = total_args;
        for (j = total_args, i = cur_counter - 1; i > index; i--, j--){
            table[i].scope = cur_scope;
            table[i].offset = j;
            table[i].mode = ARGUMENT_MODE;
        }
    }
}

void code_gen_func_header(char *functor){
    fprintf(f_asm, "%s:\n", functor);
    fprintf(f_asm, "    # In code_gen_func_header\n");
    fprintf(f_asm, "    sw ra, -4(sp)\n");
    fprintf(f_asm, "    sw fp, -8(sp)\n");
    fprintf(f_asm, "    sw a0, -12(sp)\n");
    fprintf(f_asm, "    sw a1, -16(sp)\n");
    fprintf(f_asm, "    addi sp, sp, -16\n");
    fprintf(f_asm, "    addi fp, sp, 16\n\n");
}

void code_gen_at_end_of_function_body(char *functor){
    fprintf(f_asm, "    # In code_gen_at_end_of_function_body\n");
    fprintf(f_asm, "    lw a1, -16(fp)\n");
    fprintf(f_asm, "    lw a0, -12(fp)\n");
    fprintf(f_asm, "    lw ra, -4(fp)\n");
    fprintf(f_asm, "    addi sp, fp, 0\n"); 
    fprintf(f_asm, "    lw fp, -8(sp)\n");
    fprintf(f_asm, "    jalr zero, 0(ra)\n\n");
}

void initial_global_var(){
    f_asm = fopen("codegen.s", "w");
    if(f_asm == NULL)
        perror("Error in opening codegen.s");
    cur_scope = 0;
    cur_counter = 0;
    cur_local = 0;
    cur_label = 0;
    cur_label_stack_size = 0;
}

void install_label(int label){
    if(cur_label_stack_size >= MAX_LABEL_STACK_SIZE)
        perror("Label Stack Full\n");
    else{
        label_stack[cur_label_stack_size] = cur_label;
        cur_label_stack_size++;
    }
}

int pop_up_label(){
    if(cur_label_stack_size == 0)
        perror("Label Stack Empty\n");
    else
    {
        int rtn_label;
        cur_label_stack_size--;
        rtn_label = label_stack[cur_label_stack_size];
        return rtn_label;
    }
}