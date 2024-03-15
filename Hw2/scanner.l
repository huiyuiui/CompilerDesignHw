%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
%}

Identifiers  ([_a-zA-Z])([_a-zA-Z0-9]*)
Integer      ([0-9]+)
Float        (0+\.)|([0]*\.[0-9]+)|([0-9]+\.[0-9]*)
String       (\"(\\.|[^\\\n\"])*\")
Char         (\'.\')|(\'\\[abefnrtv\'\"\\?0]\')|(\'\\[0-7]{1,3}\')|(\'\\x[0-9A-Fa-f]+\')|(\'\\u[0-9A-Fa-f]{4}\')|(\'\\U[0-9A-Fa-f]{8}\')

%x  COMMENT

%%

"const"      {return CONST;}
"signed"     {return SIGNED;}
"unsigned"   {return UNSIGNED;}
"long long"  {return LONG_LONG;}
"long"       {return LONG;}
"short"      {return SHORT;}
"int"        {return TYPE_INT;}
"char"       {return TYPE_CHAR;}
"float"      {return TYPE_FLOAT;}
"double"     {return TYPE_DOUBLE;}
"void"       {return VOID;}
"if"         {return IF;}
"else"       {return ELSE;}
"switch"     {return SWITCH;}
"case"       {return CASE;}
"default"    {return DEFAULT;}
"while"      {return WHILE;}
"do"         {return DO;}
"for"        {return FOR;}
"return"     {return RETURN;}
"break"      {return BREAK;}
"continue"   {return CONTINUE;}
"NULL"       {return NULL_VAL;}  
"||"         {return LOGIC_OR;}
"&&"         {return LOGIC_AND;}
"&"          {return AND_SYMBOL;}
"|"          {return BITWISE_OR;}
"^"          {return BITWISE_XOR;}
"=="         {return EQUAL;}
"="          {return ASSIGN;}
"!="         {return NOT_EQUAL;}
"<="         {return LESS_EQUAL;}
">="         {return GREATER_EQUAL;}
"<<"         {return SHIFT_LEFT;}
">>"         {return SHIFT_RIGHT;}
"<"          {return LESS;}
">"          {return GREATER;}
"/"          {return DIV;}
"%"          {return MOD;}
"!"          {return LOGIC_NOT;}
"~"          {return BITWISE_NOT;}
"["          {return L_SQUARE;}
"]"          {return R_SQUARE;}
"("          {return L_PAREN;}
")"          {return R_PAREN;}
"*"          {return STAR_SYMBOL;}
"++"         {return INCREMENT;}
"--"         {return DECREMENT;}
"+"          {return PLUS_SYMBOL;}
"-"          {return MINUS_SYMBOL;}
","          {return COMMA;}
":"          {return COLON;}
";"          {return SEMI_COLON;}
"{"          {return L_BRACKET;}
"}"          {return R_BRACKET;}

{Identifiers}  {
    char* str = malloc(sizeof(char) * (strlen(yytext) + 1));
    strcpy(str, yytext);
    yylval.strVal = str;
    return IDENT;
}

{String}    {
    char* str = malloc(sizeof(char) * (strlen(yytext) + 1));
    strcpy(str, yytext);
    yylval.strVal = str;
    return STRING;
}

{Char}  {
    char* str = malloc(sizeof(char) * (strlen(yytext) + 1));
    strcpy(str, yytext);
    yylval.strVal = str;
    return CHAR;
}

{Integer}   {
    yylval.intVal = atoi(yytext);
    return INT;
}

{Float}     {
    yylval.doubleVal = atof(yytext);
    return FLOAT;
}


#pragma([ ]|[ ]*[\t][ ]*)+source([ ]|[ ]*[\t][ ]*)+on  {/*Do no thing*/}
#pragma([ ]|[ ]*[\t][ ]*)+source([ ]|[ ]*[\t][ ]*)+off  {/*Do no thing*/}
#pragma([ ]|[ ]*[\t][ ]*)+token([ ]|[ ]*[\t][ ]*)+on  {/*Do no thing*/}
#pragma([ ]|[ ]*[\t][ ]*)+token([ ]|[ ]*[\t][ ]*)+off  {/*Do no thing*/}

([ \t\n]*)      {/*Strip away all whitespaces. Do no thing*/}
"//".*          {/*Do no thing*/}
"/*"            {BEGIN COMMENT;}
<COMMENT>.      {/*Do no thing*/}
<COMMENT>\n     {/*Do no thing*/}
<COMMENT>"*/"   {BEGIN 0;}

%%