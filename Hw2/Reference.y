%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int lineNo = 1;

char* itos(int i) {
    int digit = 1, tmp = i;
    while (tmp >= 10) {
        digit++;
        tmp /= 10;
    }
    char *new_str = (char*)malloc(sizeof(char)*(digit+1));
    sprintf(new_str, "%d", i);
    return new_str;
}

char* ftos(double f) {
    char *new_str = (char*)malloc(sizeof(char)*33);
    sprintf(new_str, "%f", f);
    return new_str;
}

%}
%union {
    int intVal;
    double doubleVal;
    char* sVal;
}

%token <intVal> NUM
%token <doubleVal> FLOAT
%token <sVal> STRING CHAR
%token <sVal> TYPE ID
%token <sVal> IF ELSE SWITCH CASE DEFAULT DO WHILE FOR RETURN BREAK CONTINUE
%token <sVal> INC DEC LESS_OR_EQUAL_THAN GREATER_OR_EQUAL_THAN SHIFT_LEFT SHIFT_RIGHT EQUAL NOT_EQUAL AND OR
%token <sVal> ADD MINUS MULTIPLY DIVIDE PERCENT LESS_THAN GREATER_THAN LOGICAL_NOT BITWISE_NOT AND_OP OR_OP XOR_OP ASSIGN
%token <sVal> SEMICOLON COMMA COLON L_BRACKET R_BRACKET L_SQ_BRACKET R_SQ_BRACKET L_PARENTHESIS R_PARENTHESIS
%type <sVal> program all_decl choice
%type <sVal> function_decl parameters parameter function_def compound_stmt stmts stmt if_else_stmt switch_stmt switch_clauses switch_clause while_stmt for_stmt for_cond for_lastcond return_stmt
%type <sVal> scalar ids id_decl id_decl_front arrays array_id  array_decl array_content array_dimen
%type <sVal> assign_expr or_expr and_expr or_op_expr xor_op_expr and_op_expr equal_not_equal_expr other_branch_expr shift_expr add_minus_expr term_expr prefix_expr postfix_expr expr_end array_spec arguments

%nonassoc UMINUS UADD UMULTI UANDOP
%nonassoc INCPOST DECPOST

%%

program
    : all_decl {
        printf("%s", $1);
    }
    ;

all_decl
    : all_decl choice {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
        strcpy(s, $1);
        strcat(s, $2);
        $$ = s;
    }
    | choice {
        $$ = $1;
    }
    ;

choice
    : scalar {
        $$ = $1;
    }
    | array_decl {
        $$ = $1;
    }
    | function_decl {
        $$ = $1;
    }
    | function_def {
        $$ = $1;
    }
    ;

function_def
    : TYPE ID L_BRACKET parameters R_BRACKET compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($4)+strlen($6)+24));
        strcpy(s, "<func_def>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, "(");
        strcat(s, $4);
        strcat(s, ")");
        strcat(s, $6);
        strcat(s, "</func_def>");
        $$ = s;
    }
    | TYPE MULTIPLY ID L_BRACKET parameters R_BRACKET compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+strlen($5)+strlen($7)+25));
        strcpy(s, "<func_def>");
        strcat(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        strcat(s, "(");
        strcat(s, $5);
        strcat(s, ")");
        strcat(s, $7);
        strcat(s, "</func_def>");
        $$ = s;
    }
    | TYPE ID L_BRACKET R_BRACKET compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($5)+24));
        strcpy(s, "<func_def>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, "(");
        strcat(s, ")");
        strcat(s, $5);
        strcat(s, "</func_def>");
        $$ = s;
    }
    | TYPE MULTIPLY ID L_BRACKET R_BRACKET compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+strlen($6)+24));
        strcpy(s, "<func_def>");
        strcat(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        strcat(s, "(");
        strcat(s, ")");
        strcat(s, $6);
        strcat(s, "</func_def>");
        $$ = s;
    }
    ;

compound_stmt
    : L_PARENTHESIS stmts R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+3));
        strcpy(s, "{");
        strcat(s, $2);
        strcat(s, "}");
        $$ = s;
    }
    | L_PARENTHESIS R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*3);
        strcpy(s, "{}");
        $$ = s;
    }
    ;

stmts
    : stmts stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
        strcpy(s, $1);
        strcat(s, $2);
        $$ = s;
    }
    | stmt {
        $$ = $1;
    }
    ;

stmt
    : scalar {
        $$ = $1;
    }
    | array_decl {
        $$ = $1;
    }
    | assign_expr SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+15));
        strcpy(s, "<stmt>");
        strcat(s, $1);
        strcat(s, ";");
        strcat(s, "</stmt>");
        $$ = s;
    }
    | if_else_stmt {
        $$ = $1;
    }
    | switch_stmt {
        $$ = $1;
    }
    | while_stmt {
        $$ = $1;
    }
    | for_stmt {
        $$ = $1;
    }
    | return_stmt {
        $$ = $1;
    }
    | BREAK SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*20);
        strcpy(s, "<stmt>break;</stmt>");
        $$ = s;
    } 
    | CONTINUE SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*23);
        strcpy(s, "<stmt>continue;</stmt>");
        $$ = s;
    }
    | compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+14));
        strcpy(s, "<stmt>");
        strcat(s, $1);
        strcat(s, "</stmt>");
        $$ = s;
    }
    ;

if_else_stmt
    : IF L_BRACKET assign_expr R_BRACKET compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+strlen($5)+18));
        strcpy(s, "<stmt>");
        strcat(s, "if");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, $5);
        strcat(s, "</stmt>");
        $$ = s;
    }
    | IF L_BRACKET assign_expr R_BRACKET compound_stmt ELSE compound_stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+strlen($5)+strlen($7)+22));
        strcpy(s, "<stmt>"); 
        strcat(s, "if");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, $5);
        strcat(s, "else");
        strcat(s, $7);
        strcat(s, "</stmt>");
        $$ = s;
    }
    ;

switch_stmt
    : SWITCH L_BRACKET assign_expr R_BRACKET L_PARENTHESIS switch_clauses R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+strlen($6)+24));
        strcpy(s, "<stmt>");
        strcat(s, "switch");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, "{");
        strcat(s, $6);
        strcat(s, "}");
        strcat(s, "</stmt>");
        $$ = s;
    }
    | SWITCH L_BRACKET assign_expr R_BRACKET L_PARENTHESIS R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+24));
        strcpy(s, "<stmt>");
        strcat(s, "switch");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, "{");
        strcat(s, "}");
        strcat(s, "</stmt>");
        $$ = s;
    }
    ;

switch_clauses
    : switch_clauses switch_clause {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
        strcpy(s, $1);
        strcat(s, $2);
        $$ = s;
    }
    | switch_clause {
        $$ = $1;
    }
    ;

switch_clause
    : CASE assign_expr COLON stmts {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+strlen($4)+6));
        strcpy(s, "case");
        strcat(s, $2);
        strcat(s, ":");
        strcat(s, $4);
        $$ = s;
    }
    | CASE assign_expr COLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+6));
        strcpy(s, "case");
        strcat(s, $2);
        strcat(s, ":");
        $$ = s;
    }
    | DEFAULT COLON stmts {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+9));
        strcpy(s, "default:");
        strcat(s, $3);
        $$ = s;
    }
    | DEFAULT COLON {
        char *s = (char*)malloc(sizeof(char)*(9));
        strcpy(s, "default:");
        $$ = s;
    }
    ;

while_stmt
    : WHILE L_BRACKET assign_expr R_BRACKET stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+strlen($5)+21));
        strcpy(s, "<stmt>");
        strcat(s, "while");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, $5);
        strcat(s, "</stmt>");
        $$ = s;
    }
    | DO stmt WHILE L_BRACKET assign_expr R_BRACKET SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+strlen($5)+24));
        strcpy(s, "<stmt>");
        strcat(s, "do");
        strcat(s, $2);
        strcat(s, "while");
        strcat(s, "(");
        strcat(s, $5);
        strcat(s, ")");
        strcat(s, ";");
        strcat(s, "</stmt>");
        $$ = s;
    }
    ;

for_stmt
    : FOR L_BRACKET for_cond for_cond for_lastcond stmt {
        char *s = (char*)malloc(sizeof(char)*(strlen($3)+strlen($4)+strlen($5)+strlen($6)+18));
        strcpy(s, "<stmt>");
        strcat(s, "for");
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, $4);
        strcat(s, $5);
        strcat(s, $6);
        strcat(s, "</stmt>");
        $$ = s;
    }
    ;

for_cond
    : SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*2);
        strcpy(s, ";");
        $$ = s;
    }
    | assign_expr SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+2));
        strcpy(s, $1);
        strcat(s, ";");
        $$ = s;
    }
    ;

for_lastcond
    : R_BRACKET {
        char *s = (char*)malloc(sizeof(char)*2);
        strcpy(s, ")");
        $$ = s;
    }
    | assign_expr R_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+2));
        strcpy(s, $1);
        strcat(s, ")");
        $$ = s;
    }
    ;

return_stmt
    : RETURN assign_expr SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+21));
        strcpy(s, "<stmt>");
        strcat(s, "return");
        strcat(s, $2);
        strcat(s, ";");
        strcat(s, "</stmt>");
        $$ = s;
    }
    | RETURN SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*21);
        strcpy(s, "<stmt>return;</stmt>");
        $$ = s;
    }
    ;

function_decl
    : TYPE ID L_BRACKET parameters R_BRACKET SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($4)+27));
        strcpy(s, "<func_decl>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, "(");
        strcat(s, $4);
        strcat(s, ")");
        strcat(s, ";");
        strcat(s, "</func_decl>");
        $$ = s;
    }
    | TYPE MULTIPLY ID L_BRACKET parameters R_BRACKET SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+strlen($5)+28));
        strcpy(s, "<func_decl>");
        strcat(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        strcat(s, "(");
        strcat(s, $5);
        strcat(s, ")");
        strcat(s, ";");
        strcat(s, "</func_decl>");
        $$ = s;
    }
    | TYPE ID L_BRACKET R_BRACKET SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+27));
        strcpy(s, "<func_decl>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, "();");
        strcat(s, "</func_decl>");
        $$ = s;
    }
    | TYPE MULTIPLY ID L_BRACKET R_BRACKET SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+28));
        strcpy(s, "<func_decl>");
        strcat(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        strcat(s, "();");
        strcat(s, "</func_decl>");
        $$ = s;
    }
    ;

parameters
    : parameter {
        $$ = $1;
    }
    | parameters COMMA parameter {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, $3);
        $$ = s;
    }
    ;

parameter
    : TYPE ID {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)));
        strcpy(s, $1);
        strcat(s, $2);
        $$ = s;
    }
    | TYPE MULTIPLY ID {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        $$ = s;
    }
    ;

scalar
    : TYPE ids SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+29));
        strcpy(s, "<scalar_decl>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, ";");
        strcat(s, "</scalar_decl>");
        $$ = s;
    }
    ;

ids
    : id_decl {
        $$ = $1;
    }
    | ids COMMA id_decl {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, $3);
        $$ = s;
    }
    ;

id_decl
    : id_decl_front ASSIGN assign_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, "=");
        strcat(s, $3);
        $$ = s;
    }
    | id_decl_front {
        $$ = $1;
    }
    ;

id_decl_front
    : ID {
        $$ = $1;
    }
    | MULTIPLY ID {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+2));
        strcpy(s, "*");
        strcat(s, $2);
        $$ = s;
    }
    ;

assign_expr
    : or_expr ASSIGN assign_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "=");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | or_expr {
        $$ = $1;
    }
    ;

or_expr
    : or_expr OR and_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "||");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | and_expr {
        $$ = $1; 
    }
    ;

and_expr
    : and_expr AND or_op_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "&&");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | or_op_expr {
        $$ = $1;
    }
    ;

or_op_expr
    : or_op_expr OR_OP xor_op_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "|");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | xor_op_expr {
        $$ = $1;
    }
    ;

xor_op_expr
    : xor_op_expr XOR_OP and_op_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "^");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | and_op_expr {
        $$ = $1;
    }
    ;

and_op_expr
    : and_op_expr AND_OP equal_not_equal_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "&");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | equal_not_equal_expr {
        $$ = $1;
    }
    ;

equal_not_equal_expr
    : equal_not_equal_expr EQUAL other_branch_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "==");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | equal_not_equal_expr NOT_EQUAL other_branch_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "!=");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | other_branch_expr {
        $$ = $1;
    }
    ;

// > < >= <=
other_branch_expr
    : other_branch_expr GREATER_THAN shift_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, ">");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | other_branch_expr LESS_THAN shift_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "<");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | other_branch_expr GREATER_OR_EQUAL_THAN shift_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, ">=");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | other_branch_expr LESS_OR_EQUAL_THAN shift_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "<=");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | shift_expr {
        $$ = $1;
    }
    ;

shift_expr
    : shift_expr SHIFT_LEFT add_minus_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "<<");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | shift_expr SHIFT_RIGHT add_minus_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, ">>");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | add_minus_expr {
        $$ = $1;
    }
    ;

add_minus_expr
    : add_minus_expr ADD term_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "+");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | add_minus_expr MINUS term_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "-");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | term_expr {
        $$ = $1;
    }
    ;

// * / %
term_expr
    : term_expr MULTIPLY prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "*");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | term_expr DIVIDE prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "/");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | term_expr PERCENT prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+15));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "%");
        strcat(s, $3);
        strcat(s, "</expr>");
        $$ = s;
    }
    | prefix_expr {
        $$ = $1;
    }
    ;

// ++ID --ID +ID -ID !ID ~ID *ID &ID
prefix_expr
    : INC prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+16));
        strcpy(s, "<expr>");
        strcat(s, "++");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | DEC prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+16));
        strcpy(s, "<expr>");
        strcat(s, "--");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | ADD prefix_expr %prec UADD {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "+");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | MINUS prefix_expr %prec UMINUS {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "-");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | LOGICAL_NOT prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "!");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | BITWISE_NOT prefix_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "~");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | MULTIPLY prefix_expr %prec UMULTI {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "*");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | AND_OP prefix_expr %prec UANDOP {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+15));
        strcpy(s, "<expr>");
        strcat(s, "&");
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | postfix_expr {
        $$ = $1;
    }
    ;

// ID++ ID-- ID() ID[]
postfix_expr
    : expr_end INC %prec INCPOST {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "++");
        strcat(s, "</expr>");
        $$ = s;
    }
    | expr_end DEC %prec DECPOST {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "--");
        strcat(s, "</expr>");
        $$ = s;
    }
    | expr_end L_BRACKET R_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "()");
        strcat(s, "</expr>");
        $$ = s;
    }
    | expr_end L_BRACKET arguments R_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+16));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "(");
        strcat(s, $3);
        strcat(s, ")");
        strcat(s, "</expr>");
        $$ = s;
    }
    | expr_end {
        $$ = $1;
    }
    ;

expr_end
    : ID array_spec {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+14));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, "</expr>");
        $$ = s;
    }
    | ID {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+14));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "</expr>");
        $$ = s;
    }
    | NUM {
        char *tmp = itos($1);
        char *s = (char*)malloc(sizeof(char)*(strlen(tmp)+14));
        strcpy(s, "<expr>");
        strcat(s, tmp);
        strcat(s, "</expr>");
        $$ = s;
    }
    | FLOAT {
        char *tmp = ftos($1);
        char *s = (char*)malloc(sizeof(char)*(strlen(tmp)+14));
        strcpy(s, "<expr>");
        strcat(s, tmp);
        strcat(s, "</expr>");
        $$ = s;
    }
    | STRING {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+14));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "</expr>");
        $$ = s;
    }
    | CHAR {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+14));
        strcpy(s, "<expr>");
        strcat(s, $1);
        strcat(s, "</expr>");
        $$ = s;
    }
    | L_BRACKET assign_expr R_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+16));
        strcpy(s, "<expr>");
        strcat(s, "(");
        strcat(s, $2);
        strcat(s, ")");
        strcat(s, "</expr>");
        $$ = s;
    }
    ;

array_spec
    : array_spec L_SQ_BRACKET assign_expr R_SQ_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+3));
        strcpy(s, $1);
        strcat(s, "[");
        strcat(s, $3);
        strcat(s, "]");
        $$ = s;
    }
    | L_SQ_BRACKET assign_expr R_SQ_BRACKET { 
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+3));
        strcpy(s, "[");
        strcat(s, $2);
        strcat(s, "]");
        $$ = s;
    }
    ;

array_decl
    : TYPE arrays SEMICOLON {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+27));
        strcpy(s, "<array_decl>");
        strcat(s, $1);
        strcat(s, $2);
        strcat(s, ";");
        strcat(s, "</array_decl>");
        $$ = s;
    }
    ;

arrays
    : arrays COMMA array_id {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, $3);
        $$ = s;
    }
    | array_id {
        $$ = $1;
    }
    ;

array_id
    : ID array_dimen {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
        strcpy(s, $1);
        strcat(s, $2);
        $$ = s;
    }
    | ID array_dimen ASSIGN L_PARENTHESIS array_content R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($5)+4));
        strcpy(s, $1);
        strcat(s, $2);
        strcat(s, "=");
        strcat(s, "{");
        strcat(s, $5);
        strcat(s, "}");
        $$ = s;
    }
    ;

array_dimen
    : array_dimen L_SQ_BRACKET assign_expr R_SQ_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+3));
        strcpy(s, $1);
        strcat(s, "[");
        strcat(s, $3);
        strcat(s, "]");
        $$ = s;
    }
    | L_SQ_BRACKET assign_expr R_SQ_BRACKET {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+3));
        strcat(s, "[");
        strcat(s, $2);
        strcat(s, "]");
        $$ = s;
    }

array_content
    : L_PARENTHESIS array_content R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($2)+3));
        strcpy(s, "{");
        strcat(s, $2);
        strcat(s, "}");
        $$ = s;
    }
    | array_content COMMA L_PARENTHESIS array_content R_PARENTHESIS {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($4)+4));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, "{");
        strcat(s, $4);
        strcat(s, "}");
        $$ = s;
    }
    | array_content COMMA assign_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, $3);
        $$ = s;
    }
    | assign_expr {
        $$ = $1;
    }

arguments
    : arguments COMMA assign_expr {
        char *s = (char*)malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
        strcpy(s, $1);
        strcat(s, ",");
        strcat(s, $3);
        $$ = s;
    }
    | assign_expr {
        $$ = $1;
    }
    ;

%%

int main(void) {
    yyparse();
    return 0;
}

void yyerror(char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", lineNo, msg);
}