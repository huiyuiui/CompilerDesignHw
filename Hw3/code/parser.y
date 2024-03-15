// Declaration section
%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include"code.h"

    extern int yylineno;
    extern char* yytext;

    int flag_if = 0;
    int flag_array = 0;
    int flag_double_array = 0;
    int flag_while = 0;
    int arguments = 0;
%}

%union{
    int intVal;
    double doubleVal;
    char* strVal;
}

%start program

/* Scalar*/
%token <strVal> IDENT STRING CHAR NULL_VAL
%token <intVal> INT VALUE
%token <doubleVal> FLOAT

/* Type */
%token <strVal> TYPE_INT TYPE_CHAR TYPE_FLOAT TYPE_DOUBLE 
%token <strVal> CONST SIGNED UNSIGNED LONG_LONG LONG SHORT VOID 

%right <strVal> ASSIGN
/* Precedence from low to high*/
%left <strVal> LOGIC_OR LOGIC_AND BITWISE_OR BITWISE_XOR 
%left <strVal> EQUAL NOT_EQUAL LESS LESS_EQUAL GREATER GREATER_EQUAL
%left <strVal> SHIFT_LEFT SHIFT_RIGHT DIV MOD

/* Precedence 2*/
%right <strVal> LOGIC_NOT BITWISE_NOT

/* Precedence 1*/
%left <strVal> L_SQUARE R_SQUARE L_PAREN R_PAREN

/* Redundant Symbol */
%token <strVal> AND_SYMBOL STAR_SYMBOL PLUS_SYMBOL MINUS_SYMBOL INCREMENT DECREMENT

/* Symbol and Keyword*/
%token<strVal> COMMA COLON SEMI_COLON L_BRACKET R_BRACKET
%token<strVal> IF ELSE SWITCH CASE DEFAULT WHILE DO FOR RETURN BREAK CONTINUE
%token<strVal> DIGITALWRITE DELAY

/* Non-terminal */
%type<strVal> def_or_dec_multiple definition_or_declaration
%type<strVal> dec_or_state_multiple declaration_or_statement
%type<strVal> definition_option declaration_option statement_option

%type<strVal> type idents ident_single literal
%type<strVal> first_opt second_opt third_opt
%type<strVal> scalar_declaration 
%type<strVal> array_declaration array_multiple array_single array_dimensions array_content
%type<strVal> function_declaration function_definition function_parameters function_call_argus

%type<strVal> expr expr_assign expr_array_assign 
%type<strVal> expr_logicOR expr_logicAND expr_bitwiseOR expr_bitwiseXOR expr_bitwiseAND
%type<strVal> expr_isequal expr_compare expr_shift expr_add_sub expr_mul_div_mod
%type<strVal> expr_second expr_first

%type<strVal> statement_compound statement_multiple 
%type<strVal> statement_expr statement_if statement_if_last
%type<strVal> statement_switch statement_clause_multiple statement_clause statement_case statement_default
%type<strVal> statement_while statement_for statement_return statement_break statement_continue 

%type<strVal> statement_digitalWrite statement_delay

// Grammar section
%%

/* Start */
program: def_or_dec_multiple{};

def_or_dec_multiple: 
    def_or_dec_multiple definition_or_declaration{}
    | definition_or_declaration{}
;

definition_or_declaration: definition_option{}
                         | declaration_option{}
;

definition_option: function_definition{};

declaration_option: scalar_declaration{}
                  | array_declaration{}
                  | function_declaration{}
;

/* Scalar */      
scalar_declaration: 
    type idents SEMI_COLON{}
;

type: 
    first_opt{}
;

first_opt: 
    CONST second_opt{}
    | second_opt{}
    | CONST{}
;

second_opt: 
    SIGNED third_opt{}
    | UNSIGNED third_opt{}
    | TYPE_FLOAT third_opt{}
    | TYPE_DOUBLE third_opt{}
    | VOID third_opt{}
    | SIGNED{}
    | UNSIGNED{}
    | TYPE_FLOAT{}
    | TYPE_DOUBLE{}
    | VOID{}
    | third_opt{}
;

third_opt: LONG_LONG{}
         | LONG{}
         | SHORT{}
         | LONG_LONG TYPE_INT{}
         | LONG TYPE_INT{}
         | SHORT TYPE_INT{}
         | TYPE_CHAR{}
         | TYPE_INT{}
;

idents: 
    idents COMMA ident_single{}
    | ident_single{}
;

ident_single: 
    IDENT{
        $$ = install_symbol($1);
        fprintf(f_asm, "    # In ident_single IDENT\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw zero, 0(sp)\n\n");
    }
    | IDENT ASSIGN expr{
        $$ = install_symbol($1);
    }
    | STAR_SYMBOL IDENT{
        fprintf(f_asm, "    # In ident_single STAR IDENT\n");
        $$ = install_symbol($2);
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw zero, 0(sp)\n\n");
    }
    | STAR_SYMBOL IDENT ASSIGN expr{
        $$ = install_symbol($2);
    }
;

/* Array */
array_declaration: 
    type array_multiple SEMI_COLON{}
;

array_multiple: 
    array_multiple COMMA array_single{}
    | array_single{}
;

array_single: 
    IDENT L_SQUARE expr R_SQUARE{
        int n;
        n = atoi($3);
        $$ = install_array($1, n);
        fprintf(f_asm, "    # In array_single\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n\n");
        for (int i = 0; i < n; i++) {
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw zero, 0(sp)\n");
        }
        fprintf(f_asm, "\n");
    }
    | IDENT array_dimensions ASSIGN L_BRACKET array_content R_BRACKET{}
;

array_dimensions: 
    L_SQUARE expr R_SQUARE array_dimensions{}
    | L_SQUARE expr R_SQUARE{}
;

array_content: 
    L_BRACKET array_content R_BRACKET{}
    | array_content COMMA L_BRACKET array_content R_BRACKET{}
    | array_content COMMA expr{}
    | expr{}
;

/* Function */
function_declaration: 
    type IDENT L_PAREN function_parameters R_PAREN SEMI_COLON{
        fprintf(f_asm, ".global %s\n", $2);
    }
    | type STAR_SYMBOL IDENT L_PAREN function_parameters R_PAREN SEMI_COLON{
        fprintf(f_asm, ".global %s\n", $3);
    }
;

function_definition: 
    type IDENT L_PAREN function_parameters R_PAREN{
        cur_scope++;
        set_scope_and_offset_of_param($4);
        code_gen_func_header($2);
    }
    statement_compound{
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body($2);
    }
    | type STAR_SYMBOL IDENT L_PAREN function_parameters R_PAREN{
        cur_scope++;
        set_scope_and_offset_of_param($5);
        code_gen_func_header($3);
    }
    statement_compound{
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body($3);
    }
;

function_parameters: 
    function_parameters COMMA type ident_single{$$ = $1;}
    | type ident_single{$$ = $2;}
    | /* empty */{}
;

function_call_argus: 
    function_call_argus COMMA expr{}
    | expr{
        fprintf(f_asm, "    # In function_call_argus\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi a%d, t0, 0\n\n", arguments);
        arguments++;
    }
;

/* Expression: Precedence from low to high*/
expr: expr_assign{}
    | /* empty */{}
;

expr_assign: 
    IDENT ASSIGN expr_assign{
        int index;
        index = look_up_symbol($1);
        fprintf(f_asm, "    # In IDENT ASSIGN\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    sw t0, %d(fp)\n\n", table[index].offset*(-4) - 16);
    }
    /* | STAR_SYMBOL IDENT ASSIGN expr_assign{
        int index;
        index = look_up_symbol($2);
        fprintf(f_asm, "    # In STAR IDENT ASSIGN\n");
        fprintf(f_asm, "    lw t0, %d(fp)\n", table[index].offset*(-4) - 16);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    sw t1, 0(t0)\n\n");
    } */
    | STAR_SYMBOL expr_second ASSIGN expr_assign{
        fprintf(f_asm, "    # In complex STAR ASSIGN\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        // fprintf(f_asm, "    add t1, t1, fp\n");
        fprintf(f_asm, "    sw t0, 0(t1)\n\n");
    }
    | expr_array_assign{}
    | expr_logicOR{}
;

expr_array_assign:
    IDENT array_dimensions{
        int index;
        index = look_up_symbol($1);
        fprintf(f_asm, "    # In array assign get offset\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    slli t0, t0, 2\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi t0, t0, %d\n", table[index].offset*(-4) - 16);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    ASSIGN expr_logicOR{
        fprintf(f_asm, "    # In array assign store value\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    sw t0, 0(t1)\n\n");
    }
;

expr_logicOR: 
    expr_logicOR LOGIC_OR expr_logicAND{}
    | expr_logicAND{}
;

expr_logicAND: 
    expr_logicAND LOGIC_AND expr_bitwiseOR{}
    | expr_bitwiseOR{}
;

expr_bitwiseOR: 
    expr_bitwiseOR BITWISE_OR expr_bitwiseXOR{}
    | expr_bitwiseXOR{}
;

expr_bitwiseXOR: 
    expr_bitwiseXOR BITWISE_XOR expr_bitwiseAND{}
    | expr_bitwiseAND{}
;

expr_bitwiseAND: 
    expr_bitwiseAND AND_SYMBOL expr_isequal{}
    | expr_isequal{}
;

expr_isequal: 
    expr_isequal EQUAL expr_compare{
        if(flag_if == 0){
            fprintf(f_asm, "    # In EQUAL\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    bne t0, t1, NOTEQUAL%d\n", cur_label);
            fprintf(f_asm, "    li t0, 1\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n");
            fprintf(f_asm, "    beq zero, zero, Exit%d\n", cur_label);
            fprintf(f_asm, "NOTEQUAL%d:\n", cur_label);
            fprintf(f_asm, "    li t0, 0\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n");
            fprintf(f_asm, "Exit%d:\n", cur_label);
        }
        else if(flag_if == 1){
            fprintf(f_asm, "    # In IF EQUAL\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    bne t0, t1, Label%d\n", cur_label);
        }
    }
    | expr_isequal NOT_EQUAL expr_compare{
        if(flag_if == 0){
            fprintf(f_asm, "    # In NOT_EQUAL\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    beq t0, t1, Equal%d\n", cur_label);
            fprintf(f_asm, "    li t0, 1\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n");
            fprintf(f_asm, "    beq zero, zero, Exit%d\n", cur_label);
            fprintf(f_asm, "Equal%d:\n", cur_label);
            fprintf(f_asm, "    li t0, 0\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n");
            fprintf(f_asm, "Exit%d:\n", cur_label);
        }
        else if(flag_if == 1){
            fprintf(f_asm, "    # In IF NOT_EQUAL\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    beq t0, t1, Label%d\n", cur_label);
        }
    }
    | expr_compare{}
;

expr_compare: 
    expr_compare LESS expr_shift{
        fprintf(f_asm, "    # In LESS\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    bge t1, t0, Label%d\n\n", cur_label);
    }
    | expr_compare LESS_EQUAL expr_shift{}
    | expr_compare GREATER expr_shift{}
    | expr_compare GREATER_EQUAL expr_shift{}
    | expr_shift{}
;

expr_shift: 
    expr_shift SHIFT_LEFT expr_add_sub{}       
    | expr_shift SHIFT_RIGHT expr_add_sub{}
    | expr_add_sub{}
;

expr_add_sub: 
    expr_add_sub PLUS_SYMBOL expr_mul_div_mod{
        if(flag_array == 1){
            fprintf(f_asm, "    # In ADD array\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    slli t0, t0, 2\n");
            fprintf(f_asm, "    sub t0, zero, t0\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    add t0, t0, t1\n");
            fprintf(f_asm, "    add t0, t0, fp\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n\n");
            flag_array = 0;
        }
        else if(flag_array == 0){
            fprintf(f_asm, "    # In ADD\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    add t0, t0, t1\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n\n");
        }
        
    }
    | expr_add_sub MINUS_SYMBOL expr_mul_div_mod{
        if(flag_double_array == 1){
            fprintf(f_asm, "    # In SUB array\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    slli t0, t0, 2\n");
            fprintf(f_asm, "    sub t0, zero, t0\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    sub t0, t1, t0\n");
            // fprintf(f_asm, "    add t0, t0, fp\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n\n");
            flag_double_array = 0;
        }
        else if(flag_double_array == 0){
            fprintf(f_asm, "    # In SUB\n");
            fprintf(f_asm, "    lw t0, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    lw t1, 0(sp)\n");
            fprintf(f_asm, "    addi sp, sp, 4\n");
            fprintf(f_asm, "    sub t0, t1, t0\n");
            fprintf(f_asm, "    addi sp, sp, -4\n");
            fprintf(f_asm, "    sw t0, 0(sp)\n\n");
            }
    }
    | expr_mul_div_mod{}
;

expr_mul_div_mod: 
    expr_mul_div_mod STAR_SYMBOL expr_second{
        fprintf(f_asm, "    # In MUL\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    mul t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    | expr_mul_div_mod DIV expr_second{
        fprintf(f_asm, "    # In DIV\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    lw t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    div t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    | expr_mul_div_mod MOD expr_second{}
    | expr_second{$$ = $1;}
;

expr_second: 
    AND_SYMBOL IDENT{
        int index;
        index = look_up_symbol($2);
        fprintf(f_asm, "    # In address_of\n");
        fprintf(f_asm, "    li t0, %d\n", table[index].offset*(-4) - 16);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    /* | STAR_SYMBOL IDENT{
        int index;
        index = look_up_symbol($2);
        fprintf(f_asm, "    # In pointer operation\n");
        fprintf(f_asm, "    lw t0, %d(fp)\n", table[index].offset*(-4) - 16);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    lw t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t1, 0(sp)\n\n");
    } */
    | STAR_SYMBOL expr_second{
        fprintf(f_asm, "    # In pointer operation\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        // fprintf(f_asm, "    slli t0, t0, 2\n");
        // fprintf(f_asm, "    sub t0, zero, t0\n");
        // fprintf(f_asm, "    add t0, t0, fp\n");
        // fprintf(f_asm, "    addi t0, t0, -16\n");
        fprintf(f_asm, "    lw t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t1, 0(sp)\n\n");
    }
    | L_PAREN type R_PAREN expr_second{}
    | L_PAREN type STAR_SYMBOL R_PAREN expr_second{}
    | LOGIC_NOT expr_second{}
    | BITWISE_NOT expr_second{}
    | PLUS_SYMBOL expr_second{}
    | MINUS_SYMBOL expr_second{
        fprintf(f_asm, "    # In MINUS\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    | INCREMENT expr_second{}
    | DECREMENT expr_second{}
    | expr_first{$$ = $1;}
;

expr_first: 
    IDENT array_dimensions{
        int index;
        index = look_up_symbol($1);
        fprintf(f_asm, "    # In get array value\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    slli t0, t0, 2\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi t0, t0, %d\n", table[index].offset*(-4) - 16);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    lw t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t1, 0(sp)\n\n");
    }
    | expr_first L_PAREN function_call_argus R_PAREN{
        fprintf(f_asm, "    jal ra, %s\n\n", $1);
    }
    | L_PAREN expr R_PAREN{}
    | expr_first INCREMENT{}
    | expr_first DECREMENT{}
    | IDENT{
        int index;
        index = look_up_symbol($1);
        switch (table[index].mode) {
            case LOCAL_MODE:
                if(table[index].type == T_ARRAY){
                    flag_array = 1;
                    if(strcmp($1, "fib") == 0){
                        flag_double_array = 1;
                    }
                    fprintf(f_asm, "    # In ARRAY LOCAL_MODE\n");
                    fprintf(f_asm, "    li t0, %d\n", table[index].offset*(-4) - 16);
                    // fprintf(f_asm, "    add t0, t0, fp\n");
                    fprintf(f_asm, "    addi sp, sp, -4\n");
                    fprintf(f_asm, "    sw t0, 0(sp)\n\n");
                }
                else if(flag_while == 1){
                    fprintf(f_asm, "    lw t0, %d(fp)\n", table[index].offset*(-4) - 16);
                    fprintf(f_asm, "    li t1, 0\n");
                    fprintf(f_asm, "    bge t1, t0, Label%d\n", cur_label);
                    flag_while = 0;
                }
                else{
                    fprintf(f_asm, "    # In INDENT LOCAL_MODE\n");
                    fprintf(f_asm, "    lw t0, %d(fp)\n", table[index].offset*(-4) - 16);
                    fprintf(f_asm, "    addi sp, sp, -4\n");
                    fprintf(f_asm, "    sw t0, 0(sp)\n\n");
                }
                
                break;
            default:
                fprintf(f_asm, "    # In INDENT OTHER\n");
                fprintf(f_asm, "    lw t0, %d(fp)\n", table[index].offset*(-4) - 8);
                fprintf(f_asm, "    addi sp, sp, -4\n");
                fprintf(f_asm, "    sw t0, 0(sp)\n\n");
        }
        $$ = $1;
    }
    | literal{}
;

literal: 
    INT{
        char* str = malloc(sizeof(char) * 40);
        sprintf(str, "%d", $1);
        $$ = str;
        fprintf(f_asm, "    # In INT\n");
        fprintf(f_asm, "    li t0, %d\n", $1);
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw t0, 0(sp)\n\n");
    }
    | FLOAT{}
    | CHAR{}
    | STRING{}
    | NULL_VAL{}
;

/* Statement */
statement_compound: 
    L_BRACKET dec_or_state_multiple R_BRACKET{}
    | L_BRACKET R_BRACKET{}
;

dec_or_state_multiple: 
    dec_or_state_multiple declaration_or_statement{}
    | declaration_or_statement{}
;

declaration_or_statement: 
    declaration_option{}
    | statement_option{}
;

statement_option: 
    statement_expr{}
    | statement_if{}
    | statement_switch{}
    | statement_while{}
    | statement_for{}
    | statement_break{}
    | statement_return{}
    | statement_continue{}
    | statement_compound{}
    | statement_digitalWrite{}
    | statement_delay
;

statement_expr: 
    expr SEMI_COLON{}
;

statement_if: 
    IF{
        cur_scope++;
        cur_label++;
        flag_if = 1;
        install_label(cur_label);
        fprintf(f_asm, "    # In if condition\n");
    } 
    L_PAREN expr R_PAREN{
        flag_if = 0;
        // fprintf(f_asm, "    lw t0, 0(sp)\n");
        // fprintf(f_asm, "    addi sp, sp, 4\n");
    }
    statement_if_last{fprintf(f_asm, "   # End if statement\n");}
;

statement_if_last:
    statement_compound{
        pop_up_symbol(cur_scope);
        cur_scope--;
        int rtn_label;
        rtn_label = pop_up_label();
        fprintf(f_asm, "Label%d:\n", rtn_label);
    }
    | statement_compound{
        int rtn_label;
        rtn_label = pop_up_label();
        fprintf(f_asm, "    beq zero, zero, Exit%d\n", rtn_label);
        fprintf(f_asm, "Label%d:\n", rtn_label);
        install_label(rtn_label);
    }ELSE{
        fprintf(f_asm, "   # In else\n");
    }
    statement_compound{
        pop_up_symbol(cur_scope);
        cur_scope--;
        int rtn_label;
        rtn_label = pop_up_label();
        fprintf(f_asm, "Exit%d:\n", rtn_label);
    }


statement_switch: 
    SWITCH L_PAREN expr R_PAREN L_BRACKET statement_clause_multiple R_BRACKET{}
    | SWITCH L_PAREN expr R_PAREN L_BRACKET R_BRACKET{}
;

statement_clause_multiple: 
    statement_clause_multiple statement_clause{}
    | statement_clause{}
;

statement_clause: statement_case{}
                | statement_default{}
;

statement_case: 
    CASE expr COLON statement_multiple{}
    | CASE expr COLON {}
;

statement_default: 
    DEFAULT COLON statement_multiple{}
    | DEFAULT COLON{}
;

statement_multiple: 
    statement_multiple statement_option{}
    | statement_option{}
;

statement_while: 
    WHILE{
        cur_scope++;
        cur_label++;
        flag_while = 1;
        fprintf(f_asm, "While%d:\n", cur_label);
        install_label(cur_label);
    } 
    L_PAREN expr R_PAREN statement_option{
        pop_up_symbol(cur_scope);
        cur_scope--;
        int rtn_label;
        rtn_label = pop_up_label();
        fprintf(f_asm, "    beq zero, zero, While%d\n", rtn_label);
        fprintf(f_asm, "Label%d:\n", rtn_label);
    }
    | DO{
        cur_scope++;
        cur_label++;
        fprintf(f_asm, "DoWhile%d:\n", cur_label);
        install_label(cur_label);
    } 
    statement_option WHILE {
        cur_label--;
        pop_up_label();
        cur_label--;
    }L_PAREN expr{
        install_label(cur_label);
    } 
    R_PAREN SEMI_COLON{
        pop_up_symbol(cur_scope);
        cur_scope--;
        int rtn_label;
        rtn_label = pop_up_label();
        fprintf(f_asm, "    beq zero, zero, DoWhile%d\n", rtn_label);
        fprintf(f_asm, "Label%d:\n", rtn_label);
    }
;

statement_for: 
    FOR{
        cur_scope++;
        cur_label++;
    } 
    L_PAREN expr SEMI_COLON{
        fprintf(f_asm, "For%d:\n", cur_label);
        install_label(cur_label);
    } expr SEMI_COLON IDENT ASSIGN IDENT PLUS_SYMBOL INT R_PAREN statement_option{
        int index;
        int rtn_label;
        int offset;
        index = look_up_symbol($7);
        rtn_label = pop_up_label();
        offset = table[index].offset*(-4) - 16;
        pop_up_symbol(cur_scope);
        cur_scope--;
        fprintf(f_asm, "    lw t0, %d(fp)\n", offset);
        fprintf(f_asm, "    addi t0, t0, 1\n");
        fprintf(f_asm, "    sw t0, %d(fp)\n", offset);
        fprintf(f_asm, "    beq zero, zero, For%d\n", rtn_label);
        fprintf(f_asm, "Label%d:\n", rtn_label);   
    }
;

statement_return: 
    RETURN expr SEMI_COLON{}
;

statement_break: BREAK SEMI_COLON{}
;

statement_continue: CONTINUE SEMI_COLON{}
;

statement_digitalWrite: 
    DIGITALWRITE L_PAREN INT COMMA VALUE R_PAREN SEMI_COLON{
        fprintf(f_asm, "    # In digital write\n");
        fprintf(f_asm, "    li a0, %d\n", $3);
        fprintf(f_asm, "    li a1, %d\n", $5);
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, digitalWrite\n");
        fprintf(f_asm, "    lw ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n\n");
    }
;

statement_delay:
    DELAY L_PAREN expr R_PAREN SEMI_COLON{
        fprintf(f_asm, "    # In delay\n");
        fprintf(f_asm, "    lw t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n");
        fprintf(f_asm, "    addi a0, t0, 0\n");
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, delay\n");
        fprintf(f_asm, "    lw ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 4\n\n");
    }
;

%%

// C code section
int main(){
    initial_global_var();
    yyparse();
    fclose(f_asm);

    return 0;
}

int yyerror(char *msg){
    fprintf(stderr, "Error Message: %s, In line: %d, Error text: %s\n", msg, yylineno, yytext);
    return 0;
}