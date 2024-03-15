// Declaration section
%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    extern int yylineno;
    extern char* yytext;
%}

%union{
    int intVal;
    double doubleVal;
    char* strVal;
}

%start program

/* Scalar*/
%token <strVal> IDENT STRING CHAR NULL_VAL
%token <intVal> INT
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

/* Non-terminal */
%type<strVal> def_or_dec_multiple definition_or_declaration
%type<strVal> dec_or_state_multiple declaration_or_statement
%type<strVal> definition_option declaration_option statement_option

%type<strVal> type idents ident_single literal
%type<strVal> first_opt second_opt third_opt
%type<strVal> scalar_declaration 
%type<strVal> array_declaration array_multiple array_single array_dimensions array_content
%type<strVal> function_declaration function_definition function_parameters function_call_argus

%type<strVal> expr expr_assign
%type<strVal> expr_logicOR expr_logicAND expr_bitwiseOR expr_bitwiseXOR expr_bitwiseAND
%type<strVal> expr_isequal expr_compare expr_shift expr_add_sub expr_mul_div_mod
%type<strVal> expr_second expr_first

%type<strVal> statement_compound statement_multiple 
%type<strVal> statement_expr statement_if
%type<strVal> statement_switch statement_clause_multiple statement_clause statement_case statement_default
%type<strVal> statement_while statement_for statement_return statement_break statement_continue 

// Grammar section
%%

/* Start */
program: def_or_dec_multiple{printf("%s", $1);};

def_or_dec_multiple: 
    def_or_dec_multiple definition_or_declaration{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | definition_or_declaration{$$ = $1;}
;

definition_or_declaration: definition_option{$$ = $1;}
                         | declaration_option{$$ = $1;}
;

definition_option: function_definition{$$ = $1;};

declaration_option: scalar_declaration{$$ = $1;}
                  | array_declaration{$$ = $1;}
                  | function_declaration{$$ = $1;}
;

/* Scalar */      
scalar_declaration: 
    type idents SEMI_COLON{
        char* str = malloc(sizeof(char) * (13 + strlen($1) + strlen($2) + 1 + 14 + 1));
        strcpy(str, "<scalar_decl>");
        strcat(str, $1);
        strcat(str, $2);
        strcat(str, ";");
        strcat(str, "</scalar_decl>");
        $$ = str;
    }
;

type: 
    first_opt{$$ = $1;}
;

first_opt: 
    CONST second_opt{
        char* str = malloc(sizeof(char) * (5 + strlen($2) + 1));
        strcpy(str, "const");
        strcat(str, $2);
        $$ = str;
    }
    | second_opt{$$ = $1;}
    | CONST{$$ = "const";}
;

second_opt: 
    SIGNED third_opt{
        char* str = malloc(sizeof(char) * (6 + strlen($2) + 1));
        strcpy(str, "signed");
        strcat(str, $2);
        $$ = str;
    }
    | UNSIGNED third_opt{
        char* str = malloc(sizeof(char) * (8 + strlen($2) + 1));
        strcpy(str, "unsigned");
        strcat(str, $2);
        $$ = str;
    }
    | TYPE_FLOAT third_opt{
        char* str = malloc(sizeof(char) * (5 + strlen($2) + 1));
        strcpy(str, "float");
        strcat(str, $2);
        $$ = str;
    }
    | TYPE_DOUBLE third_opt{
        char* str = malloc(sizeof(char) * (6 + strlen($2) + 1));
        strcpy(str, "double");
        strcat(str, $2);
        $$ = str;
    }
    | VOID third_opt{
        char* str = malloc(sizeof(char) * (4 + strlen($2) + 1));
        strcpy(str, "void");
        strcat(str, $2);
        $$ = str;
    }
    | SIGNED{$$ = "signed";}
    | UNSIGNED{$$ = "unsigned";}
    | TYPE_FLOAT{$$ = "float";}
    | TYPE_DOUBLE{$$ = "double";}
    | VOID{$$ = "void";}
    | third_opt{$$ = $1;}
;

third_opt: LONG_LONG{$$ = "longlong";}
         | LONG{$$ = "long";}
         | SHORT{$$ = "short";}
         | LONG_LONG TYPE_INT{$$ = "longlongint";}
         | LONG TYPE_INT{$$ = "longint";}
         | SHORT TYPE_INT{$$ = "shortint";}
         | TYPE_CHAR{$$ = "char";}
         | TYPE_INT{$$ = "int";}
;

idents: 
    idents COMMA ident_single{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, $3);
        $$ = str;
    }
    | ident_single{$$ = $1;}
;

ident_single: 
    IDENT{$$ = $1;}
    | IDENT ASSIGN expr{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + 1));
        strcpy(str, $1);
        strcat(str, "=");
        strcat(str, $3);
        $$ = str;
    }
    | STAR_SYMBOL IDENT{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1));
        strcpy(str, "*");
        strcat(str, $2);
        $$ = str;
    }
    | STAR_SYMBOL IDENT ASSIGN expr{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1 + strlen($4) + 1));
        strcpy(str, "*");
        strcat(str, $2);
        strcat(str, "=");
        strcat(str, $4);
        $$ = str;
    }
;

/* Array */
array_declaration: 
    type array_multiple SEMI_COLON{
        char* str = malloc(sizeof(char) * (12 + strlen($1) + strlen($2) + 1 + 13 + 1));
        strcpy(str, "<array_decl>");
        strcat(str, $1);
        strcat(str, $2);
        strcat(str, ";");
        strcat(str, "</array_decl>");
        $$ = str;
    }
;

array_multiple: 
    array_multiple COMMA array_single{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, $3);
        $$ = str;
    }
    | array_single{$$ = $1;}
;

array_single: 
    IDENT array_dimensions{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | IDENT array_dimensions ASSIGN L_BRACKET array_content R_BRACKET{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1 + 1 + strlen($5) + 1 + 1));
        strcpy(str, $1);
        strcat(str, $2);
        strcat(str, "=");
        strcat(str, "{");
        strcat(str, $5);
        strcat(str, "}");
        $$ = str;
    }
;

array_dimensions: 
    L_SQUARE expr R_SQUARE array_dimensions{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1 + strlen($4) + 1));
        strcpy(str, "[");
        strcat(str, $2);
        strcat(str, "]");
        strcat(str, $4);
        $$ = str;
    }
    | L_SQUARE expr R_SQUARE{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1 + 1));
        strcpy(str, "[");
        strcat(str, $2);
        strcat(str, "]");
        $$ = str;
    }
;

array_content: 
    L_BRACKET array_content R_BRACKET{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1 + 1));
        strcpy(str, "{");
        strcat(str, $2);
        strcat(str, "}");
        $$ = str;
    }
    | array_content COMMA L_BRACKET array_content R_BRACKET{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + 1 + strlen($4) + 1 + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, "{");
        strcat(str, $4);
        strcat(str, "}");
        $$ = str;
    }
    | array_content COMMA expr{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, $3);
        $$ = str;
    }
    | expr{$$ = $1;}
;

/* Function */
function_declaration: 
    type IDENT L_PAREN function_parameters R_PAREN SEMI_COLON{
        char* str = malloc(sizeof(char) * (11 + strlen($1) + strlen($2) + 1 + strlen($4) + 1 + 1 + 12 + 1));
        strcpy(str, "<func_decl>");
        strcat(str, $1);
        strcat(str, $2);
        strcat(str, "(");
        strcat(str, $4);
        strcat(str, ")");
        strcat(str, ";");
        strcat(str, "</func_decl>");
        $$ = str;
    }
    | type STAR_SYMBOL IDENT L_PAREN function_parameters R_PAREN SEMI_COLON{
        char* str = malloc(sizeof(char) * (11 + strlen($1) + 1 + strlen($3) + 1 + strlen($5) + 1 + 1 + 12 + 1));
        strcpy(str, "<func_decl>");
        strcat(str, $1);
        strcat(str, "*");
        strcat(str, $3);
        strcat(str, "(");
        strcat(str, $5);
        strcat(str, ")");
        strcat(str, ";");
        strcat(str, "</func_decl>");
        $$ = str;
    }
;

function_definition: 
    type IDENT L_PAREN function_parameters R_PAREN statement_compound{
        char* str = malloc(sizeof(char) * (10 + strlen($1) + strlen($2) + 1 + strlen($4) + 1 + strlen($6) + 11 + 1));
        strcpy(str, "<func_def>");
        strcat(str, $1);
        strcat(str, $2);
        strcat(str, "(");
        strcat(str, $4);
        strcat(str, ")");
        strcat(str, $6);
        strcat(str, "</func_def>");
        $$ = str;
    }
    | type STAR_SYMBOL IDENT L_PAREN function_parameters R_PAREN statement_compound{
        char* str = malloc(sizeof(char) * (10 + strlen($1) + 1 + strlen($3) + 1 + strlen($5) + 1 + strlen($7) + 11 + 1));
        strcpy(str, "<func_def>");
        strcat(str, $1);
        strcat(str, "*");
        strcat(str, $3);
        strcat(str, "(");
        strcat(str, $5);
        strcat(str, ")");
        strcat(str, $7);
        strcat(str, "</func_def>");
        $$ = str;
    }
;

function_parameters: 
    function_parameters COMMA type ident_single{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + strlen($4) + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, $3);
        strcat(str, $4);
        $$ = str;
    }
    | type ident_single{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | /* empty */{$$ = "";}
;

function_call_argus: 
    function_call_argus COMMA expr{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + strlen($3) + 1));
        strcpy(str, $1);
        strcat(str, ",");
        strcat(str, $3);
        $$ = str;
    }
    | expr{$$ = $1;}
;

/* Expression: Precedence from low to high*/
expr: expr_assign{$$ = $1;}
    | /* empty */{$$ = "";}
;

expr_assign: 
    expr_logicOR ASSIGN expr_assign{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "=");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_logicOR{$$ = $1;}
;

expr_logicOR: 
    expr_logicOR LOGIC_OR expr_logicAND{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "||");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_logicAND{$$ = $1;}
;

expr_logicAND: 
    expr_logicAND LOGIC_AND expr_bitwiseOR{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "&&");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_bitwiseOR{$$ = $1;}
;

expr_bitwiseOR: 
    expr_bitwiseOR BITWISE_OR expr_bitwiseXOR{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "|");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_bitwiseXOR{$$ = $1;}
;

expr_bitwiseXOR: 
    expr_bitwiseXOR BITWISE_XOR expr_bitwiseAND{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "^");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_bitwiseAND{$$ = $1;}
;

expr_bitwiseAND: 
    expr_bitwiseAND AND_SYMBOL expr_isequal{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "&");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_isequal{$$ = $1;}
;

expr_isequal: 
    expr_isequal EQUAL expr_compare{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "==");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_isequal NOT_EQUAL expr_compare{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "!=");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_compare{$$ = $1;}
;

expr_compare: 
    expr_compare LESS expr_shift{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "<");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_compare LESS_EQUAL expr_shift{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "<=");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_compare GREATER expr_shift{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, ">");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_compare GREATER_EQUAL expr_shift{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, ">=");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_shift{$$ = $1;}
;

expr_shift: 
    expr_shift SHIFT_LEFT expr_add_sub{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "<<");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }       
    | expr_shift SHIFT_RIGHT expr_add_sub{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, ">>");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_add_sub{$$ = $1;}
;

expr_add_sub: 
    expr_add_sub PLUS_SYMBOL expr_mul_div_mod{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "+");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_add_sub MINUS_SYMBOL expr_mul_div_mod{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "-");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_mul_div_mod{$$ = $1;}
;

expr_mul_div_mod: 
    expr_mul_div_mod STAR_SYMBOL expr_second{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "*");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_mul_div_mod DIV expr_second{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "/");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_mul_div_mod MOD expr_second{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 + strlen($3) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "%");
        strcat(str, $3);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_second{$$ = $1;}
;

expr_second: 
    AND_SYMBOL expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "&");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | STAR_SYMBOL expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "*");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | L_PAREN type R_PAREN expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 1 + strlen($4) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "(");
        strcat(str, $2);
        strcat(str, ")");
        strcat(str, $4);
        strcat(str, "</expr>");
        $$ = str;
    }
    | L_PAREN type STAR_SYMBOL R_PAREN expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 1 + 1 + strlen($5) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "(");
        strcat(str, $2);
        strcat(str, "*");
        strcat(str, ")");
        strcat(str, $5);
        strcat(str, "</expr>");
        $$ = str;
    }
    | LOGIC_NOT expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "!");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | BITWISE_NOT expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "~");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | PLUS_SYMBOL expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "+");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | MINUS_SYMBOL expr_second{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "-");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | INCREMENT expr_second{
        char* str = malloc(sizeof(char) * (6 + 2 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "++");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | DECREMENT expr_second{
        char* str = malloc(sizeof(char) * (6 + 2 + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "--");
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_first{$$ = $1;}
;

expr_first: 
    IDENT array_dimensions{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + strlen($2) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, $2);
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_first L_PAREN function_call_argus R_PAREN{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 1 +strlen($3) + 1 + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, "</expr>");
        $$ = str;
    }
    | L_PAREN expr R_PAREN{
        char* str = malloc(sizeof(char) * (6 + 1 +strlen($2) + 1 + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, "(");
        strcat(str, $2);
        strcat(str, ")");
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_first INCREMENT{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "++");
        strcat(str, "</expr>");
        $$ = str;
    }
    | expr_first DECREMENT{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 2 + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "--");
        strcat(str, "</expr>");
        $$ = str;
    }
    | IDENT{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "</expr>");
        $$ = str;
    }
    | literal{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<expr>");
        strcat(str, $1);
        strcat(str, "</expr>");
        $$ = str;
    }
;

literal: 
    INT{
        char* str = malloc(sizeof(char) * 40);
        sprintf(str, "%d", $1);
        $$ = str;
    }
    | FLOAT{
        char* str = malloc(sizeof(char) * 80);
        sprintf(str, "%f", $1);
        $$ = str;
    }
    | CHAR{$$ = $1;}
    | STRING{$$ = $1;}
    | NULL_VAL{$$ = "0";}
;

/* Statement */
statement_compound: 
    L_BRACKET dec_or_state_multiple R_BRACKET{
        char* str = malloc(sizeof(char) * (1 + strlen($2) + 1 + 1));
        strcpy(str, "{");
        strcat(str, $2);
        strcat(str, "}");
        $$ = str;
    }
    | L_BRACKET R_BRACKET{
        char* str = malloc(sizeof(char) * (1 + 1 + 1));
        strcpy(str, "{");
        strcat(str, "}");
        $$ = str;
    }
;

dec_or_state_multiple: 
    dec_or_state_multiple declaration_or_statement{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | declaration_or_statement{$$ = $1;}
;

declaration_or_statement: 
    declaration_option{$$ = $1;}
    | statement_option{$$ = $1;}
;

statement_option: 
    statement_expr{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_if{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_switch{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_while{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_for{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_break{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_return{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_continue{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
    | statement_compound{
        char* str = malloc(sizeof(char) * (6 + strlen($1) + 7 + 1));
        strcpy(str, "<stmt>");
        strcat(str, $1);
        strcat(str, "</stmt>");
        $$ = str;
    }
;

statement_expr: 
    expr SEMI_COLON{
        char* str = malloc(sizeof(char) * (strlen($1) + 1 + 1));
        strcpy(str, $1);
        strcat(str, ";");
        $$ = str;
    }
;

statement_if: 
    IF L_PAREN expr R_PAREN statement_compound{
        char* str = malloc(sizeof(char) * (2 + 1 + strlen($3) + 1 + strlen($5) + 1));
        strcpy(str, "if");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, $5);
        $$ = str;
    }
    | IF L_PAREN expr R_PAREN statement_compound ELSE statement_compound{
        char* str = malloc(sizeof(char) * (2 + 1 + strlen($3) + 1 + strlen($5) + 4 + strlen($7) + 1));
        strcpy(str, "if");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, $5);
        strcat(str, "else");
        strcat(str, $7);
        $$ = str;
    }
;

statement_switch: 
    SWITCH L_PAREN expr R_PAREN L_BRACKET statement_clause_multiple R_BRACKET{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($3) + 1 + 1 + strlen($6) + 1 + 1));
        strcpy(str, "switch");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, "{");
        strcat(str, $6);
        strcat(str, "}");
        $$ = str;
    }
    | SWITCH L_PAREN expr R_PAREN L_BRACKET R_BRACKET{
        char* str = malloc(sizeof(char) * (6 + 1 + strlen($3) + 1 + 1 + 1 + 1));
        strcpy(str, "switch");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, "{");
        strcat(str, "}");
        $$ = str;
    }
;

statement_clause_multiple: 
    statement_clause_multiple statement_clause{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | statement_clause{$$ = $1;}
;

statement_clause: statement_case{$$ = $1;}
                | statement_default{$$ = $1;}
;

statement_case: 
    CASE expr COLON statement_multiple{
        char* str = malloc(sizeof(char) * (4 + strlen($2) + 1 + strlen($4) + 1));
        strcpy(str, "case");
        strcat(str, $2);
        strcat(str, ":");
        strcat(str, $4);
        $$ = str;
    }
    | CASE expr COLON {
        char* str = malloc(sizeof(char) * (4 + strlen($2) + 1 + 1));
        strcpy(str, "case");
        strcat(str, $2);
        strcat(str, ":");
        $$ = str;
    }
;

statement_default: 
    DEFAULT COLON statement_multiple{
        char* str = malloc(sizeof(char) * (7 + 1 + strlen($3) + 1));
        strcpy(str, "default");
        strcat(str, ":");
        strcat(str, $3);
        $$ = str;
    }
    | DEFAULT COLON{
        char* str = malloc(sizeof(char) * (7 + 1 + 1));
        strcpy(str, "default");
        strcat(str, ":");
        $$ = str;
    }
;

statement_multiple: 
    statement_multiple statement_option{
        char* str = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | statement_option{$$ = $1;}
;

statement_while: 
    WHILE L_PAREN expr R_PAREN statement_option{
        char* str = malloc(sizeof(char) * (5 + 1 + strlen($3) + 1 + strlen($5) + 1));
        strcpy(str, "while");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ")");
        strcat(str, $5);
        $$ = str;
    }
    | DO statement_option WHILE L_PAREN expr R_PAREN SEMI_COLON{
        char* str = malloc(sizeof(char) * (2 + strlen($2) + 5 + 1 + strlen($5) + 1 + 1 + 1));
        strcpy(str, "do");
        strcat(str, $2);
        strcat(str, "while");
        strcat(str, "(");
        strcat(str, $5);
        strcat(str, ")");
        strcat(str, ";");
        $$ = str;
    }
;

statement_for: 
    FOR L_PAREN expr SEMI_COLON expr SEMI_COLON expr R_PAREN statement_option{
        char* str = malloc(sizeof(char) * (3 + 1 + strlen($3) + 1 + strlen($5) + 1 + strlen($7) + 1 + strlen($9) + 1));
        strcpy(str, "for");
        strcat(str, "(");
        strcat(str, $3);
        strcat(str, ";");
        strcat(str, $5);
        strcat(str, ";");
        strcat(str, $7);
        strcat(str, ")");
        strcat(str, $9);
        $$ = str;
    }
;

statement_return: 
    RETURN expr SEMI_COLON{
        char* str = malloc(sizeof(char) * (6 + strlen($2) + 1 + 1));
        strcpy(str, "return");
        strcat(str, $2);
        strcat(str, ";");
        $$ = str;
    }
;

statement_break: BREAK SEMI_COLON{$$ = "break;";}
;

statement_continue: CONTINUE SEMI_COLON{$$ = "continue;";}
;

%%

// C code section
int main(){
    yyparse();

    return 0;
}

int yyerror(char *msg){
    fprintf(stderr, "Error Message: %s, In line: %d, Error text: %s\n", msg, yylineno, yytext);
    return 0;
}