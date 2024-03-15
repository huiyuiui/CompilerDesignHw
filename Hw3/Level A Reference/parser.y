%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    #define snprintf_nowarn(...) (snprintf(__VA_ARGS__) < 0 ? yyerror("exceed string size") : (void)0)
    
    int yyerror(const char *);
    int yylex();
    
    FILE* f_asm; 
    
    extern int line_count;
    
    #define MAX_ELEMENT 10000
    #define MAX_PARAM 10
    #define MAX_REG 12
    #define MAX_IF 20
    #define MAX_LOOP 20
    
    int scope = 0, now_pointer = 0;
    
    int ret_count = 0;
    
    int idx_if = 0, next_if = 1;
    int now_if[MAX_IF] = {0};
    
    int idx_loop = 0, next_loop = 1;
    int now_loop[MAX_LOOP] = {0};
    
    char param[MAX_PARAM][10];
    int param_count = 0, now_param = 12;
    
    int n_tmp;
    char tmp[500];
    
    typedef struct var {
        char name[5000];
        int type;   // 0: void, 1: int
        int _const; // 0: no, 1: yes
        int ptr;    // 0: no, 1: yes
        int arr;
        int scope;  // starts from 0
        int base;
        int offset; // offset of sp
        int val;
        
        int varient;    // 0: variable, 1: function
        int total_args; // for function.
        int total_lvar;    // for function.
    } Var;
    
    int lvar_now = 0;
    int type_now = 0, const_now = 0;
    int var_count = 0, var_prev = 0;
    Var _list[MAX_ELEMENT];
    
    int using_reg[MAX_REG] = {0};
    
    int offset[MAX_ELEMENT];
    int offset_now;
    
// print the current status of offset, arr, ptr
    void status() {
        for (int i = 0; i < var_count; i++) {
        printf("%s offset:%d arr: %d ptr:%d\n", _list[i].name, _list[i].offset, _list[i].arr, _list[i].ptr);
        }
    }
// go through all variables    
    int check_local_var() {
        int ret = 0;
        
        for (int i = 0; i < var_count; i++) {
            if (_list[i].offset <= 0)
                ret++;
        }
                
        return ret;
    }
// do this after functions are finished executing
    int pop_local_var() {
        int c = 0, d = 0;
        
        for (int i = var_count-1; i >= -1; i--) {
            if (i == -1 || _list[i].scope <= scope) {
                var_count = var_prev = i+1;
                break;
            } else {
                if (_list[i].offset <= 0)
                    c++;
                else 
                    d++;
                    
                printf("%s: %d\n", _list[i].name, _list[i].offset);
            }
        }
        
        printf("pop %d local var, %d local param\n", c, d);
        return c;
    }
    
    int find_local_var(char* s) {
        for (int i = var_count-1; i >= 0; i--) {
            if (!strcmp(s, _list[i].name)) {
                return _list[i].offset;
            }
        }
        
        return -1;
    }
    
    int is_arr(char* s) {
        for (int i = var_count-1; i >= 0; i--) {
            if (!strcmp(s, _list[i].name)) {
                return _list[i].arr;
            }
        }
        
        return -1;
    }
    
    int is_ptr(char* s) {
        for (int i = var_count-1; i >= 0; i--) {
            if (!strcmp(s, _list[i].name)) {
                return _list[i].ptr;
            }
        }
        
        return -1;
    }
    
    char* find_reg() {
        for (int i = 1; i < MAX_REG; i++) {
            if (using_reg[i] == 0) {
                using_reg[i] = 1;
                // printf("use s%d\n", i);
                sprintf(tmp, "s%d", i);
                return tmp;
            }
        }
        
        return "-1";
    }
    
    void free_reg(char* s) {
        if (s[0] == 'a')
            return;
            
        s += sizeof(char);
        
        if (using_reg[atoi(s)] == 0) {
            printf("free s%s ERROR!!!\n", s);
        } else {
            // printf("free s%s\n", s);
            using_reg[atoi(s)] = 0;
        }
    }
%}

%union {
    int intVal;
    double doubleVal;
    char strVal[5000];
};

/* %define parse.error verbose */

//* terminal
//* simplify the float and integer. 
%token<intVal> V_INT
%token<doubleVal> V_FLOAT
//* %token<doubleVal> FLOATNUM
%token<strVal> FOR DO WHILE BREAK CONTINUE IF ELSE RETURN STRUCT SWITCH CASE DEFAULT VOID INT DOUBLE FLOAT CHAR CONST SIGNED UNSIGNED SHORT LONG ID_NAME ADD SUB MUL DIV MOD INC DEC LT LE GT GE EQ NE ASSIGN AND OR NOT BAND BOR XOR BNOT SL SR NL MACRO V_CHAR V_STRING V_NULL

%token<strVal> ':' ';' ',' '.' '[' ']' '(' ')' '{' '}'
//* nonterminal

%type<intVal> PARM GEN_PARM N_PARM EXPRS GEN_DIM FUNC

%type<strVal> SCALAR_DECL ARRAY_DECL FUNC_DECL FUNC_DEF GEN_INDENTS TYPE C_CONST SIGN SIZE D_SIZE OTHER_TYPE STMT STMTSCALAR STMTS COMPOUND_STMT SWITCH_CLAUSES SWITCH_CLAUSE NEXPR ID EXPR INIT_VAR

%right ASSIGN
%left OR
%left AND
%left BOR
%left XOR
%left BAND
%left EQ NE
%left LT LE GT GE
%left SL SR
%left ADD SUB
%left MUL DIV MOD
%right INC DEC NOT BNOT POSITIVE NEGATIVE POINTER ADDRESS TYPEOF
%left SUFINC SUFDEC '(' ')' '[' ']' FUNC_CALL ARR_SUBSCRIPT

%%

PROGRAM:
PROGRAM SCALAR_DECL {}
| PROGRAM ARRAY_DECL {}
| PROGRAM FUNC_DECL {}
| PROGRAM FUNC_DEF {}
| ;

SCALAR_DECL:
TYPE GEN_INDENTS {
    for (int i = var_prev; i < var_count; i++) {
        _list[i].type = type_now;
        _list[i]._const = const_now;
    }
    var_prev = var_count;
    
    // status();
}
;
  
ARRAY_DECL:
TYPE ID_NAME GEN_DIM ';' {
    strcpy(_list[var_count].name, $2);
    _list[var_count].type = 0;
    _list[var_count].ptr = 0;
    _list[var_count].arr = 1;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * offset[offset_now];
    offset[offset_now] -= $3;
    
    _list[var_count].varient = 0;
    
    fprintf(f_asm, "    addi sp, sp, %d\n", -4 * $3);
    
    var_count += $3;
    
    for (int i = var_prev; i < var_count; i++) {
        if (i != var_prev) {
            _list[i].name[0] = 0;
            _list[i].offset = 0;
        }
        _list[i].scope = scope;
        _list[i].type = type_now;
        _list[i]._const = const_now;
    }
    var_prev = var_count;
}
;

GEN_INDENTS:
ID_NAME INIT_VAR ',' GEN_INDENTS { 
    strcpy(_list[var_count].name, $1);
    _list[var_count].type = 0;
    _list[var_count].ptr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * offset[offset_now]--;
    
    _list[var_count].varient = 0;
    
    fprintf(f_asm, "    addi sp, sp, -4\n");
    if ($2[0] != 0) {
        fprintf(f_asm, "    sw %s, 0(sp)\n", $2);
        free_reg($2);
    }
    
    var_count++;  
}
| MUL ID_NAME INIT_VAR ',' GEN_INDENTS %prec POINTER { 
    strcpy(_list[var_count].name, $2);
    _list[var_count].type = 0;
    _list[var_count].ptr = 1;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * offset[offset_now]--;
    
    _list[var_count].varient = 0;
    
    fprintf(f_asm, "    addi sp, sp, -4\n");
    if ($3[0] != 0) {
        fprintf(f_asm, "    sw %s, 0(sp)\n", $3);
        free_reg($3);
    }
    
    var_count++;
}
| ID_NAME INIT_VAR ';' {
    strcpy(_list[var_count].name, $1);
    _list[var_count].type = 0;
    _list[var_count].ptr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * offset[offset_now]--;
    
    _list[var_count].varient = 0;
    
    fprintf(f_asm, "    addi sp, sp, -4\n");
    if ($2[0] != 0) {
        fprintf(f_asm, "    sw %s, 0(sp)\n", $2);
        free_reg($2);
    }
    
    var_count++;
}
| MUL ID_NAME INIT_VAR ';' %prec POINTER { 
    strcpy(_list[var_count].name, $2);
    _list[var_count].type = 0;
    _list[var_count].ptr = 1;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * offset[offset_now]--;
    
    _list[var_count].varient = 0;
    
    fprintf(f_asm, "    addi sp, sp, -4\n");
    if ($3[0] != 0) {
        fprintf(f_asm, "    sw %s, 0(sp)\n", $3);
        free_reg($3);
    }
    
    var_count++;
}
;

INIT_VAR:
ASSIGN EXPR {
    strcpy($$, $2);
    now_pointer = 0;
}
| { $$[0] = 0; }
;

TYPE:
C_CONST SIGN SIZE INT { type_now = 1; }
| C_CONST SIGN D_SIZE { type_now = -1; }
| C_CONST OTHER_TYPE {}
| CONST { type_now = 1; }
;

C_CONST:
CONST { const_now = 1; }
| { const_now = 0; }
;

SIGN:
SIGNED {}
| UNSIGNED {} 
| { $$[0] = 0; }
;

SIZE:
LONG LONG {}
| LONG {}
| SHORT {}
| { $$[0] = 0; }
;

D_SIZE:
LONG LONG {}
| LONG {}
| SHORT {}
| CHAR {}
;

OTHER_TYPE:
SIGNED { type_now = -1; }
| UNSIGNED { type_now = -1; } 
| FLOAT { type_now = -1; }
| DOUBLE { type_now = -1; }
| VOID { type_now = 0; }
;

FUNC:
TYPE MUL ID_NAME {
    scope++;
} '(' PARM ')' {
    printf("----- %s -----\n", $3);
    status();
    printf("---------\n");
    
    scope--;
    $$ = 1; 
    strcpy(tmp, $3);
    n_tmp = $6;
    
}
/* -------------------------------- */
| TYPE ID_NAME {
    scope++;
} '(' PARM ')' {
    printf("----- %s -----\n", $2);
    status();
    printf("---------\n");
    
    scope--;
    $$ = 0; 
    strcpy(tmp, $2);
    n_tmp = $5;
    
}
;

FUNC_DECL:
FUNC ';' {
    printf("in\n");
    pop_local_var();
    printf("\n");
    
    
    strcpy(_list[var_count].name, tmp);
    _list[var_count].type = type_now;
    _list[var_count].ptr = $1;
    _list[var_count].scope = scope;
    _list[var_count].varient = 1;
    _list[var_count].total_args = n_tmp;
}
;

FUNC_DEF:
FUNC {
   
    now_param = 12;
    
    fprintf(f_asm, ".global %s\n", tmp);
    fprintf(f_asm, "%s:\n", tmp);
    
    offset[offset_now] = -1;
    
    fprintf(f_asm, "    addi sp, sp, -48\n");
    fprintf(f_asm, "    sw fp, 0(sp)\n");
    fprintf(f_asm, "    sw s1, 4(sp)\n");
    fprintf(f_asm, "    sw s2, 8(sp)\n");
    fprintf(f_asm, "    sw s3, 12(sp)\n");
    fprintf(f_asm, "    sw s4, 16(sp)\n");
    fprintf(f_asm, "    sw s5, 20(sp)\n");
    fprintf(f_asm, "    sw s6, 24(sp)\n");
    fprintf(f_asm, "    sw s7, 28(sp)\n");
    fprintf(f_asm, "    sw s8, 32(sp)\n");
    fprintf(f_asm, "    sw s9, 36(sp)\n");
    fprintf(f_asm, "    sw s10, 40(sp)\n");
    fprintf(f_asm, "    sw s11, 44(sp)\n");
    fprintf(f_asm, "    addi fp, sp, 0\n");
    fprintf(f_asm, "    \n");
} COMPOUND_STMT {
    fprintf(f_asm, "    lw fp, 0(sp)\n");
    fprintf(f_asm, "    lw s1, 4(sp)\n");
    fprintf(f_asm, "    lw s2, 8(sp)\n");
    fprintf(f_asm, "    lw s3, 12(sp)\n");
    fprintf(f_asm, "    lw s4, 16(sp)\n");
    fprintf(f_asm, "    lw s5, 20(sp)\n");
    fprintf(f_asm, "    lw s6, 24(sp)\n");
    fprintf(f_asm, "    lw s7, 28(sp)\n");
    fprintf(f_asm, "    lw s8, 32(sp)\n");
    fprintf(f_asm, "    lw s9, 36(sp)\n");
    fprintf(f_asm, "    lw s10, 40(sp)\n");
    fprintf(f_asm, "    lw s11, 44(sp)\n");
    fprintf(f_asm, "    addi sp, sp, 48\n");
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    jalr zero, 0(ra)\n");
    fprintf(f_asm, "    \n");
}
;

COMPOUND_STMT: { scope++; printf("in\n"); } '{' STMTSCALAR '}' {
    scope--; 
    fprintf(f_asm, "    addi sp, sp, %d\n", pop_local_var() * 4); 
}
;

STMTSCALAR:
STMT { fprintf(f_asm, "    \n"); now_pointer = 0; } STMTSCALAR
| SCALAR_DECL { fprintf(f_asm, "    \n"); now_pointer = 0; } STMTSCALAR
| ARRAY_DECL { fprintf(f_asm, "    \n"); now_pointer = 0; } STMTSCALAR
| { $$[0] = 0; }
;

STMTS:
STMT STMTS {}
| { $$[0] = 0; }
;

STMT:
EXPR ';' {
    if ($1[0] != 0)
        free_reg($1);
}
| IF '(' EXPR ')' {
    now_if[++idx_if] = next_if++;
    
    fprintf(f_asm, "    beq %s, zero, else_%d\n", $3, now_if[idx_if]);
    fprintf(f_asm, "    \n");
    free_reg($3);
} COMPOUND_STMT {
    fprintf(f_asm, "    j endif_%d\n", now_if[idx_if]);
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    else_%d:\n", now_if[idx_if]);
} ELSE_PART {
    fprintf(f_asm, "    endif_%d:\n", now_if[idx_if]);
    idx_if--;
}
/* -------------------------------- */
| SWITCH '(' EXPR ')' '{' SWITCH_CLAUSES '}' {}
/* -------------------------------- */
| WHILE {
    now_loop[++idx_loop] = next_loop++;
    fprintf(f_asm, "    loop_%d:\n", now_loop[idx_loop]);
} '(' EXPR ')' {
    fprintf(f_asm, "    beq %s, zero, endloop_%d\n", $4, now_loop[idx_loop]);
    fprintf(f_asm, "    \n");
    free_reg($4);
} STMT {
    fprintf(f_asm, "    j loop_%d\n", now_loop[idx_loop]);
    fprintf(f_asm, "    endloop_%d:\n", now_loop[idx_loop]);
    idx_loop--;
}    // TODO.
/* -------------------------------- */
| DO {
    now_loop[++idx_loop] = next_loop++;
    fprintf(f_asm, "    loop_%d:\n", now_loop[idx_loop]);
} STMT WHILE '(' EXPR ')' {
    fprintf(f_asm, "    bne %s, zero, loop_%d\n", $6, now_loop[idx_loop]);
    fprintf(f_asm, "    \n");
    free_reg($6);
} ';' {
    idx_loop--;
} // TODO.
/* -------------------------------- */
| FOR '(' NEXPR {
    now_loop[++idx_loop] = next_loop++;
    fprintf(f_asm, "    checkloop_%d:\n", now_loop[idx_loop]);
    free_reg($3);
} ';' NEXPR {
    fprintf(f_asm, "    beq %s, zero, endloop_%d\n", $6, now_loop[idx_loop]);
    fprintf(f_asm, "    j stmtloop_%d\n", now_loop[idx_loop]);
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    loop_%d:\n", now_loop[idx_loop]);
    free_reg($6);
} ';' NEXPR ')' {
    fprintf(f_asm, "    j checkloop_%d\n", now_loop[idx_loop]);
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    stmtloop_%d:\n", now_loop[idx_loop]);
    free_reg($9);
} STMT {
    fprintf(f_asm, "    j loop_%d\n", now_loop[idx_loop]);
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    endloop_%d:\n", now_loop[idx_loop]);
    
    idx_loop--;
} // TODO.
/* -------------------------------- */
| RETURN EXPR ';' {
    fprintf(f_asm, "    addi a0, %s, 0\n", $2);
    free_reg($2);
    
    fprintf(f_asm, "    addi sp, sp, %d\n", check_local_var() * 4);
    
    fprintf(f_asm, "    lw fp, 0(sp)\n");
    fprintf(f_asm, "    lw s1, 4(sp)\n");
    fprintf(f_asm, "    lw s2, 8(sp)\n");
    fprintf(f_asm, "    lw s3, 12(sp)\n");
    fprintf(f_asm, "    lw s4, 16(sp)\n");
    fprintf(f_asm, "    lw s5, 20(sp)\n");
    fprintf(f_asm, "    lw s6, 24(sp)\n");
    fprintf(f_asm, "    lw s7, 28(sp)\n");
    fprintf(f_asm, "    lw s8, 32(sp)\n");
    fprintf(f_asm, "    lw s9, 36(sp)\n");
    fprintf(f_asm, "    lw s10, 40(sp)\n");
    fprintf(f_asm, "    lw s11, 44(sp)\n");
    fprintf(f_asm, "    addi sp, sp, 48\n");
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    jalr zero, 0(ra)\n");
    fprintf(f_asm, "    \n");
}
/* -------------------------------- */
| RETURN ';' {
    fprintf(f_asm, "    addi sp, sp, %d\n", check_local_var() * 4);
    
    fprintf(f_asm, "    lw fp, 0(sp)\n");
    fprintf(f_asm, "    lw s1, 4(sp)\n");
    fprintf(f_asm, "    lw s2, 8(sp)\n");
    fprintf(f_asm, "    lw s3, 12(sp)\n");
    fprintf(f_asm, "    lw s4, 16(sp)\n");
    fprintf(f_asm, "    lw s5, 20(sp)\n");
    fprintf(f_asm, "    lw s6, 24(sp)\n");
    fprintf(f_asm, "    lw s7, 28(sp)\n");
    fprintf(f_asm, "    lw s8, 32(sp)\n");
    fprintf(f_asm, "    lw s9, 36(sp)\n");
    fprintf(f_asm, "    lw s10, 40(sp)\n");
    fprintf(f_asm, "    lw s11, 44(sp)\n");
    fprintf(f_asm, "    addi sp, sp, 48\n");
    fprintf(f_asm, "    \n");
    fprintf(f_asm, "    jalr zero, 0(ra)\n");
    fprintf(f_asm, "    \n");
}
/* -------------------------------- */
| BREAK ';' {
    fprintf(f_asm, "    j endloop_%d\n", now_loop[idx_loop]);
}
/* -------------------------------- */
| CONTINUE ';' {
    fprintf(f_asm, "    j loop_%d\n", now_loop[idx_loop]);
}
/* -------------------------------- */
| COMPOUND_STMT {}
;

ELSE_PART:
ELSE COMPOUND_STMT
|
;

SWITCH_CLAUSES:
SWITCH_CLAUSE SWITCH_CLAUSES {}
| { $$[0] = 0; }
;

SWITCH_CLAUSE:
CASE EXPR ':' STMTS {}
| DEFAULT ':' STMTS {}
;

NEXPR:
EXPR { strcpy($$, $1); }
| { $$[0] = 0; }
;

EXPR:
ID_NAME ASSIGN EXPR {
    int os = find_local_var($1);
    fprintf(f_asm, "    sw %s, %d(fp)\n", $3, os);
    
    strcpy($$, $3);
}
| ID_NAME '[' EXPR ']' ASSIGN EXPR {
    int os = find_local_var($1);
    int ptr = is_ptr($1);
    
    if (ptr) {
        char tmp2[20];
        strcpy(tmp2, find_reg());
        find_reg();
        
        fprintf(f_asm, "    lw %s, %d(fp)\n", tmp2, os);
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        fprintf(f_asm, "    add %s, %s, %s\n", tmp2, tmp2, $3);
        fprintf(f_asm, "    sw %s, 0(%s)\n", $6, tmp2);
        
        strcpy($$, $6);
        free_reg(tmp);
        free_reg(tmp2);
        free_reg($3);
    } else {
        find_reg();
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        fprintf(f_asm, "    add %s, %s, fp\n", $3, $3);
        fprintf(f_asm, "    sw %s, %d(%s)\n", $6, os, $3);
        
        strcpy($$, $6);
        free_reg(tmp);
        free_reg($3);
    }
    
}
| MUL ID_NAME ASSIGN EXPR {
    int os = find_local_var($2);
    
    if (is_arr($2) == 1) {
        fprintf(f_asm, "    sw %s, %d(fp)\n", $4, os);
    } else if (is_arr($2) == 0) {
        strcpy($$, find_reg());
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
        fprintf(f_asm, "    sw %s, 0(%s)\n", $4, $$);
        free_reg($$);
    }
        
    strcpy($$, $4);
}
| MUL '(' ID_NAME ')' ASSIGN EXPR {
    int os = find_local_var($2);
    
    if (is_arr($2) == 1) {
        fprintf(f_asm, "    sw %s, %d(fp)\n", $4, os);
    } else if (is_arr($2) == 0) {
        strcpy($$, find_reg());
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
        fprintf(f_asm, "    sw %s, 0(%s)\n", $4, $$);
        free_reg($$);
    }
        
    strcpy($$, $4);
}
| MUL '(' ID_NAME ADD EXPR ')' ASSIGN EXPR  {
    int os = find_local_var($3);
    
    find_reg();
    fprintf(f_asm, "    li %s, -4\n", tmp);
    fprintf(f_asm, "    mul %s, %s, %s\n", $5, $5, tmp);
    fprintf(f_asm, "    add %s, %s, fp\n", $5, $5);
    fprintf(f_asm, "    sw %s, %d(%s)\n", $8, os, $5);
    
    strcpy($$, $8);
    free_reg(tmp);
    free_reg($5);
}
| EXPR OR EXPR {}
| EXPR AND EXPR {}
| EXPR BOR EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    or %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR XOR EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    xor %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR BAND EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    and %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR EQ EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    xor %s, %s, %s\n", $$, $1, $3);
    fprintf(f_asm, "    sltu %s, %s, 1\n", $$, $$);
    
    free_reg($3);
}
| EXPR NE EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    xor %s, %s, %s\n", $$, $1, $3);
    fprintf(f_asm, "    sltu %s, zero, %s\n", $$, $$);
    
    free_reg($3);
}
| EXPR LT EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    slt %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR LE EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    sle %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR GT EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    sgt %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR GE EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    sge %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR SL EXPR {}
| EXPR SR EXPR {}
| EXPR ADD EXPR {
    strcpy($$, $1);
    
    if (now_pointer) {
        find_reg();
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        free_reg(tmp);
    }
    
    fprintf(f_asm, "    add %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR SUB EXPR {
    strcpy($$, $1);
    
    if (now_pointer) {
        find_reg();
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        free_reg(tmp);
    }
    
    fprintf(f_asm, "    sub %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR MUL EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    mul %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR DIV EXPR {
    strcpy($$, $1);
    fprintf(f_asm, "    div %s, %s, %s\n", $$, $1, $3);
    
    free_reg($3);
}
| EXPR MOD EXPR {}
| INC EXPR {
    // TODO.
}
| DEC EXPR {
    // TODO.
}
| NOT EXPR {}
| BNOT EXPR {}
| ADD EXPR %prec POSITIVE {}
| SUB EXPR %prec NEGATIVE {
    strcpy($$, $2);
    fprintf(f_asm, "    neg %s, %s\n", $2, $2);
}
| MUL ID_NAME %prec POINTER {
    int os = find_local_var($2);
    strcpy($$, find_reg());
    
    if (is_arr($2) == 1) {
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
    } else if (is_arr($2) == 0) {
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
        fprintf(f_asm, "    lw %s, 0(%s)\n", $$, $$);
    }
}
| MUL '(' ID_NAME ')' %prec POINTER {
    int os = find_local_var($3);
    strcpy($$, find_reg());
    
    if (is_arr($3) == 1) {
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
    } else if (is_arr($3) == 0) {
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
        fprintf(f_asm, "    lw %s, 0(%s)\n", $$, $$);
    }
}
| MUL '(' ID_NAME ADD EXPR ')' %prec POINTER {
    strcpy($$, find_reg());
    int os = find_local_var($3);
    
    find_reg();
    fprintf(f_asm, "    li %s, -4\n", tmp);
    fprintf(f_asm, "    mul %s, %s, %s\n", $5, $5, tmp);
    fprintf(f_asm, "    add %s, %s, fp\n", $5, $5);
    fprintf(f_asm, "    lw %s, %d(%s)\n", $$, os, $5);
    
    free_reg($5);
    free_reg(tmp);
}
| BAND ID_NAME %prec ADDRESS {
    strcpy($$, find_reg());
    int os = find_local_var($2);
    fprintf(f_asm, "    addi %s, fp, %d\n", $$, os);
    // TODO.
}
| '(' TYPE ')' EXPR %prec TYPEOF { /* skiped. */ }
| '(' TYPE MUL ')' EXPR %prec TYPEOF { /* skiped. */ }
| EXPR INC %prec SUFINC {
    // TODO.
}
| EXPR DEC %prec SUFDEC {
    // TODO.
}
| '(' EXPR ')' {
    strcpy($$, $2);
}
| ID {
    strcpy($$, $1);
    // TODO.
}
| ID_NAME '(' N_PARM ')' %prec FUNC_CALL {
    fprintf(f_asm, "    addi sp, sp, -4\n");
    fprintf(f_asm, "    sw ra, 0(sp)\n");
    
    for (int i = $3-1; i >= 0; i--) {
        fprintf(f_asm, "    addi a%d, %s, 0\n", $3-1-i, param[i]);
        fprintf(f_asm, "    addi sp, sp, -4\n");
        fprintf(f_asm, "    sw a%d, 0(sp)\n", $3-1-i);
        free_reg(param[i]);
    }
    
    // JUMP.    
    fprintf(f_asm, "    jal ra, %s\n", $1);
    
    fprintf(f_asm, "    addi sp, sp, %d\n", $3 * 4);
    
    fprintf(f_asm, "    lw ra, 0(sp)\n");
    fprintf(f_asm, "    addi sp, sp, 4\n");
    // fprintf(f_asm, "    \n");
    
    param_count = 0;
    // TODO.
    
    find_reg();
    fprintf(f_asm, "    addi %s, a0, 0\n", tmp);
    //* check definition
    strcpy($$, tmp);
}
| V_INT {
    strcpy($$, find_reg());
    fprintf(f_asm, "    li %s, %d\n", $$, $1);
}
| V_FLOAT { /* skipped. */ }
| V_CHAR {}
| V_STRING { /* skipped. */ }
| V_NULL { /* skipped. */ }
;

N_PARM:
EXPR { now_pointer = 0; } EXPRS {
    strcpy(param[param_count++], $1);
    $$ = $3 + 1;
}
| { $$ = 0; }
;

EXPRS:
',' EXPR { now_pointer = 0; } EXPRS {
    strcpy(param[param_count++], $2);
    $$ = $4 + 1;
}
| { $$ = 0; }
;

PARM:
TYPE ID_NAME GEN_PARM {
    $$ = $3 + 1;
    
    strcpy(_list[var_count].name, $2);
    _list[var_count].type = 1;
    _list[var_count].ptr = 0;
    _list[var_count].arr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * now_param++;
    
    _list[var_count].varient = 0;
    
    var_count++;  
}
| TYPE MUL ID_NAME GEN_PARM %prec POINTER { 
    $$ = $4 + 1;
    
    strcpy(_list[var_count].name, $3);
    _list[var_count].type = 1;
    _list[var_count].ptr = 1;
    _list[var_count].arr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * now_param++;
    
    _list[var_count].varient = 0;
    
    var_count++;  
}
| { $$ = 0; }
;

GEN_PARM:
',' TYPE ID_NAME GEN_PARM {
    $$ = $4 + 1;
    
    strcpy(_list[var_count].name, $3);
    _list[var_count].type = 1;
    _list[var_count].ptr = 0;
    _list[var_count].arr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * now_param++;
    
    _list[var_count].varient = 0;
    
    var_count++;  
}
| ',' TYPE MUL ID_NAME GEN_PARM %prec POINTER {
    $$ = $5 + 1;
    
    strcpy(_list[var_count].name, $4);
    _list[var_count].type = 1;
    _list[var_count].ptr = 1;
    _list[var_count].arr = 0;
    _list[var_count].scope = scope;
    
    //* TODO.
    _list[var_count].offset = 4 * now_param++;
    
    _list[var_count].varient = 0;
    
    var_count++; 
}
| { $$ = 0; }
;

GEN_DIM:
'[' V_INT ']' {
    $$ = $2;
}
;

ID:
ID_NAME {
    strcpy($$, find_reg());
    int os = find_local_var($1);
    printf("%s: %d %d\n", $1, os, is_arr($1));
    
    if (is_ptr($1)) {
        now_pointer = 1;
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
    } else if (is_arr($1)) {
        now_pointer = 1;
        fprintf(f_asm, "    li %s, %d\n", $$, os);
        fprintf(f_asm, "    add %s, %s, fp\n", $$, $$);
    } else {
        fprintf(f_asm, "    lw %s, %d(fp)\n", $$, os);
    }
}
| ID_NAME '[' EXPR ']' %prec ARR_SUBSCRIPT {
    strcpy($$, find_reg());
    int os = find_local_var($1);
    int ptr = is_ptr($1);
    
    if (ptr) {
        char tmp2[20];
        strcpy(tmp2, find_reg());
        find_reg();
        
        fprintf(f_asm, "    lw %s, %d(fp)\n", tmp2, os);
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        fprintf(f_asm, "    add %s, %s, %s\n", tmp2, tmp2, $3);
        fprintf(f_asm, "    lw %s, 0(%s)\n", $$, tmp2);
        
        free_reg(tmp);
        free_reg(tmp2);
        free_reg($3);
    } else {
        find_reg();
        fprintf(f_asm, "    li %s, -4\n", tmp);
        fprintf(f_asm, "    mul %s, %s, %s\n", $3, $3, tmp);
        fprintf(f_asm, "    add %s, %s, fp\n", $3, $3);
        fprintf(f_asm, "    lw %s, %d(%s)\n", $$, os, $3);
        
        free_reg($3);
        free_reg(tmp);
    }
}
;

%%

int yyerror(const char* s) {
    fprintf(stderr, "%s at line %d\n", s, line_count);
    return 0;
}

int main() {
    f_asm = fopen("codegen.S", "w+");
    yyparse();
    
    for (int i = 1; i < MAX_REG; i++) {
        if (using_reg[i]) printf("param[%d] BLOCKED!!!\n", i);
    }
    
    fclose(f_asm);
    return 0;
}