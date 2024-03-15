%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code.h"

int yylex();
int lineNo = 1;
int in_if = 0;
extern FILE* f_asm;
int arg_cnt;
int LHS = 0;

%}
%union {
    int intVal;
    double doubleVal;
    char* sVal;
}

%token <intVal> NUM DVALUE
%token <sVal> TYPE ID LINE
%token <sVal> IF ELSE DO WHILE FOR RETURN BREAK CONTINUE
%token <sVal> LESS_OR_EQUAL_THAN GREATER_OR_EQUAL_THAN EQUAL NOT_EQUAL
%token <sVal> ADD MINUS MULTIPLY DIVIDE LESS_THAN GREATER_THAN AND_OP ASSIGN
%token <sVal> SEMICOLON COMMA L_BRACKET R_BRACKET L_SQ_BRACKET R_SQ_BRACKET L_PARENTHESIS R_PARENTHESIS DIGITALWRITE DELAY
%type <sVal> program
%type <sVal> parameters parameter function_def function_decl function_defs function_decls compound_stmt stmts stmt if_else_stmt_first if_else_stmt_second while_stmt for_stmt for_start for_cond for_lastcond return_stmt
%type <sVal> scalar ids id_decl id_decl_front 
%type <sVal> assign_expr  equal_not_equal_expr other_branch_expr add_minus_expr term_expr prefix_expr postfix_expr expr_end arguments
%type <sVal> digitalwrite_stmt delay_stmt

%nonassoc UMINUS UMULTI UANDOP UPOINTER

%start program

%%

program
    : function_decls function_defs
    ;

function_decls
    : function_decls function_decl
    | function_decl
    | function_decls LINE {
        lineNo++;
    }
    ;

function_defs
    : function_defs function_def
    | function_def
    | function_defs LINE {
        lineNo++;
    }
    ;

function_def
    : TYPE ID L_BRACKET parameters R_BRACKET {
        cur_scope++;
        set_scope_and_offset_of_param($4);
        code_gen_func_header($2);
    }
    compound_stmt {
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body($2);
    }
    | TYPE ID L_BRACKET R_BRACKET {
        cur_scope++;
        code_gen_func_header($2);
    }
    compound_stmt {
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body($2);
    }
    ;

parameters
    : parameter
    | parameters COMMA parameter
    ;

parameter
    : TYPE ID {
        $$ = install_symbol($2);
    }
    | TYPE MULTIPLY ID {
        $$ = install_symbol($3);
    }
    ;

function_decl
    : TYPE ID L_BRACKET parameters R_BRACKET SEMICOLON {
        fprintf(f_asm, ".global %s\n", $2);
    }
    | TYPE ID L_BRACKET R_BRACKET SEMICOLON {
        fprintf(f_asm, ".global %s\n", $2);
    }
    ;

compound_stmt
    : L_PARENTHESIS stmts R_PARENTHESIS
    | L_PARENTHESIS R_PARENTHESIS
    ;

stmts
    : stmts stmt
    | stmt
    | stmts scalar
    | scalar
    ;

stmt
    : assign_expr SEMICOLON 
    | if_else_stmt_first
    | while_stmt 
    | for_stmt
    | return_stmt
    | BREAK SEMICOLON
    | CONTINUE SEMICOLON
    | digitalwrite_stmt
    | delay_stmt
    | LINE {
        lineNo++;
    }
    ;

digitalwrite_stmt
    : DIGITALWRITE L_BRACKET NUM COMMA DVALUE R_BRACKET SEMICOLON {
        fprintf(f_asm, "    li a0, %d\n", $3);
        fprintf(f_asm, "    li a1, %d\n", $5);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, digitalWrite\n");
        fprintf(f_asm, "    ld ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
    }
    ;

delay_stmt
    : DELAY L_BRACKET assign_expr R_BRACKET SEMICOLON {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    mv a0, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, delay\n");
        fprintf(f_asm, "    ld ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
    }
    ;

if_else_stmt_first
    : IF {
        cur_scope++;
        in_if = 1;
    }
    L_BRACKET equal_not_equal_expr  {
        cur_label++;
        push_label(cur_label);
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        in_if = 0;
    }
    if_else_stmt_second
    ;

if_else_stmt_second
    : R_BRACKET compound_stmt {
        int tmp_label = pop_label();
        fprintf(f_asm, "L%d:\n", tmp_label);
        pop_up_symbol(cur_scope);
        cur_scope--;
    }
    | R_BRACKET compound_stmt ELSE {
        int tmp_label = pop_label();
        fprintf(f_asm, "    beq zero, zero, EXIT%d\n", tmp_label);
        fprintf(f_asm, "L%d:\n", tmp_label);
        push_label(tmp_label);
    } compound_stmt {
        int tmp_label = pop_label();
        fprintf(f_asm, "EXIT%d:\n", tmp_label);
        pop_up_symbol(cur_scope);
        cur_scope--;
    }
    ;

while_stmt
    : WHILE {
        cur_label++;
        cur_scope++;
        fprintf(f_asm, "WHILE%d:\n", cur_label);
        push_label(cur_label);
    }
    L_BRACKET equal_not_equal_expr R_BRACKET compound_stmt {
        int tmp_label = pop_label();
        fprintf(f_asm, "    beq zero, zero, WHILE%d:\n", tmp_label);
        fprintf(f_asm, "L%d:\n", tmp_label);
        pop_up_symbol(cur_scope);
        cur_scope--;
    }
    | DO {
        cur_label++;
        fprintf(f_asm, "DOWHILE%d:\n", cur_label);
        push_label(cur_label);
    }
    compound_stmt WHILE L_BRACKET assign_expr R_BRACKET SEMICOLON {
        int tmp_label = pop_label();
        fprintf(f_asm, "    beq zero, zero, DOWHILE%d\n", tmp_label);
        fprintf(f_asm, "L%d:\n", tmp_label);
        pop_up_symbol(cur_scope);
        cur_scope--;
    }
    ;

for_stmt
    : FOR L_BRACKET for_start {
        cur_scope++;
        cur_label++;
        push_label(cur_label);
        fprintf(f_asm, "FOR%d:\n", cur_label);
    }
    for_cond for_lastcond compound_stmt {
        int index = look_up_symbol($2);
        int tmp_label = pop_label();
        fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    addi t0, t0, 1\n");
        fprintf(f_asm, "    sd t0, %d(fp)\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    beq zero, zero, FOR%d\n", tmp_label);
        fprintf(f_asm, "L%d:\n", tmp_label);
        pop_up_symbol(cur_scope);
        cur_scope--;
    }
    ;

for_start
    : SEMICOLON
    | assign_expr SEMICOLON
    ;

for_cond
    : SEMICOLON
    | equal_not_equal_expr SEMICOLON
    ;

for_lastcond
    : R_BRACKET
    | ID ASSIGN ID ADD NUM R_BRACKET {
        $$ = $1;
    }
    ;

return_stmt
    : RETURN assign_expr SEMICOLON {
        
    }
    | RETURN SEMICOLON
    ;

scalar
    : TYPE ids SEMICOLON
    ;

ids
    : id_decl
    | ids COMMA id_decl
    ;

id_decl
    : id_decl_front ASSIGN equal_not_equal_expr {
        $$ = install_symbol($1);
    }
    | id_decl_front {
        $$ = install_symbol($1);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd zero, 0(sp)\n");
    }
    | id_decl_front L_SQ_BRACKET NUM R_SQ_BRACKET {
        $$ = install_array_symbol($1, $3);
        for (int i = 0; i < $3; i++) {
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    sd zero, 0(sp)\n");
        }
    }
    ;

id_decl_front
    : ID {
        $$ = $1;
    }
    | MULTIPLY ID {
        $$ = $2;
    }
    ;

assign_expr
    : equal_not_equal_expr {
        LHS = 1;
    } ASSIGN {
        LHS = 0;
    }
    equal_not_equal_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    sd t1, 0(t0)\n");
    }
    | equal_not_equal_expr
    ;

equal_not_equal_expr
    : equal_not_equal_expr EQUAL other_branch_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bne t1, t0, L%d\n", cur_label);
    }
    | equal_not_equal_expr NOT_EQUAL other_branch_expr {
        if (in_if == 1) {
            fprintf(f_asm, "    ld t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 8\n");
            fprintf(f_asm, "    ld t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 8\n");
            fprintf(f_asm, "    beq t1, t0, L%d\n", cur_label);
        } else {
            fprintf(f_asm, "    ld t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 8\n");
            fprintf(f_asm, "    ld t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 8\n");
            fprintf(f_asm, "    bne t1, t0, LXA\n");
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    li t0, 0\n");
            fprintf(f_asm, "    sd t0, 0(sp)\n");
            fprintf(f_asm, "    beq zero, zero, EXITXA\n");
            fprintf(f_asm, "LXA:\n");
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    li t0, 1\n");
            fprintf(f_asm, "    sd t0, 0(sp)\n");
            fprintf(f_asm, "EXITXA:\n");
        }
    }
    | other_branch_expr
    ;

// > < >= <=
other_branch_expr
    : other_branch_expr GREATER_THAN add_minus_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bge t0, t1, L%d\n", cur_label);
    }
    | other_branch_expr LESS_THAN add_minus_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bge t1, t0, L%d\n", cur_label);
    }
    | other_branch_expr GREATER_OR_EQUAL_THAN add_minus_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    blt t1, t0, L%d\n", cur_label);
    }
    | other_branch_expr LESS_OR_EQUAL_THAN add_minus_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    blt t0, t1, L%d\n", cur_label);
    }
    | add_minus_expr
    ;

add_minus_expr
    : add_minus_expr ADD term_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    add t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | add_minus_expr MINUS term_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    sub t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | term_expr
    ;

// * / %
term_expr
    : term_expr MULTIPLY prefix_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    mul t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | term_expr DIVIDE prefix_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    div t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | prefix_expr
    ;

// ++ID --ID +ID -ID !ID ~ID *ID &ID
prefix_expr
    : MINUS prefix_expr %prec UMINUS {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    /* | MULTIPLY ID %prec UMULTI {
        int index = look_up_symbol($2);
        fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    slli t0, t0, 3\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    ld t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t1, 0(sp)\n");
    } */
    | AND_OP ID %prec UANDOP {
        int index = look_up_symbol($2);
        fprintf(f_asm, "    li t0, %d\n", table[index].offset);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | MULTIPLY postfix_expr %prec UPOINTER {
        if (LHS == 1) {
            
        }
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    slli t0, t0, 3\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi t0, t0, -32\n");
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    ld t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t1, 0(sp)\n");
    }
    | postfix_expr
    ;

// ID++ ID-- ID() ID[]
postfix_expr
    : ID L_BRACKET R_BRACKET {
        fprintf(f_asm, "    jal ra, %s\n", $1);
    }
    | ID L_BRACKET arguments R_BRACKET {
        fprintf(f_asm, "    jal ra, %s\n", $1);
    }
    | expr_end
    ;

expr_end
    : ID L_SQ_BRACKET equal_not_equal_expr R_SQ_BRACKET {
        int index = look_up_symbol($1);
        if (LHS == 0) {
            fprintf(f_asm, "    ld t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 8\n");
            fprintf(f_asm, "    slli t0, t0, 3\n");
            fprintf(f_asm, "    sub t0, zero, t0\n");
            fprintf(f_asm, "    add t0, t0, fp\n");
            fprintf(f_asm, "    addi t0, t0, %d\n", table[index].offset * (-8) - 32);
            fprintf(f_asm, "    ld t1, 0(t0)\n");
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    sd t1, 0(sp)\n");
        } else {
            fprintf(f_asm, "    ")
        }
    }
    | ID {
        int index = look_up_symbol($1);
        if (LHS == 0) {
            if (table[index].mode == LOCAL_MODE) {
                if (table[index].type == T_OTHER) {
                    fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 32);
                    fprintf(f_asm, "    addi sp, sp, -8\n");
                    fprintf(f_asm, "    sd t0, 0(sp)\n");
                } else {
                    fprintf(f_asm, "    li t0, %d\n", table[index].offset);
                    fprintf(f_asm, "    addi sp, sp, -8\n");
                    fprintf(f_asm, "    sd t0, 0(sp)\n");
                }
            } else {
                fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 16);
                fprintf(f_asm, "    addi sp, sp, -8\n");
                fprintf(f_asm, "    sd t0, 0(sp)\n");
            }
        } else {
            if (table[index].mode == LOCAL_MODE) {
                fprintf(f_asm, "    li t0, %d\n", table[index].offset * (-8) - 32);
                fprintf(f_asm, "    add t0, t0, fp\n");
                fprintf(f_asm, "    addi sp, sp, -8\n");
                fprintf(f_asm, "    sd t0, 0(sp)\n");
            } else {
                fprintf(f_asm, "    li t0, %d\n", table[index].offset * (-8) - 16);
                fprintf(f_asm, "    add t0, t0, fp\n");
                fprintf(f_asm, "    addi sp, sp, -8\n");
                fprintf(f_asm, "    sd t0, 0(sp)\n");
            }
        }
    }
    | NUM {
        fprintf(f_asm, "    li t0, %d\n", $1);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
    | L_BRACKET equal_not_equal_expr R_BRACKET
    ;

arguments
    : arguments COMMA equal_not_equal_expr
    | equal_not_equal_expr {
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    mv a%d, t0\n", arg_cnt);
        arg_cnt++;
    }
    ;

%%

int main(void) {
    if ((f_asm = fopen(FILENAME, "w")) == NULL) {
        perror("Error at opening file");
    }
    init();
    yyparse();
    fclose(f_asm);
    return 0;
}

void yyerror(char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", lineNo, msg);
}