#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TABLE_SIZE 5000
#define MAX_LABEL_STACK_SIZE 50
#define T_FUNCITON 0
#define T_TYPE 1
#define T_ARRAY 2
#define ARGUMENT_MODE 3
#define LOCAL_MODE 4
#define GLOBAL_MODE 5

typedef struct symbol_entry *PTR_SYMB;

struct symbol_entry
{
    char *name;
    int scope;
    int offset;
    int id;
    int variant;
    int type;
    int total_args;
    int total_locals;
    int mode;
};

extern FILE *f_asm;
extern int cur_scope;
extern int cur_counter;
extern int cur_local;
extern int cur_label;
extern int cur_label_stack_size;
extern int label_stack[MAX_LABEL_STACK_SIZE];
extern struct symbol_entry table[MAX_TABLE_SIZE];

char *install_symbol(char *s);
char *install_array(char *s, int n);
char *copy(char *s);
int look_up_symbol(char *s);
void pop_up_symbol(int scope);
void set_scope_and_offset_of_param(char *s);
void code_gen_func_header(char *functor);
void code_gen_at_end_of_function_body(char *functor);

void initial_global_var();
void install_label(int label);
int pop_up_label();