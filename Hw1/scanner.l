%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int line_count = 0;
    int token_flag = 1;
    int source_flag = 1;
    char out[300];

    void newLine(){
        line_count += 1;
        if(source_flag == 1){
            printf("%d:%s\n",line_count, out);
        }
        memset(out, 0, 300);
    }

%}

Keywords     "for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long"
Macros       "NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN"
Operators    "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
Punctuation  ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
Identifiers  ([_a-zA-Z])([_a-zA-Z0-9])*
Integer      ([+\-]?[0-9]+)
Float        ([+\-]?0+\.)|([+\-]?[0]*\.[0-9]+)|([+\-]?[0-9]+\.[0-9]*)
String       (\"(\\.|[^\\\n\"])*\")
Char         (\'.\')|(\'\\[abefnrtv\'\"\\?0]\')|(\'\\[0-7]{1,3}\')|(\'\\x[0-9A-Fa-f]+\')|(\'\\u[0-9A-Fa-f]{4}\')|(\'\\U[0-9A-Fa-f]{8}\')

%x  COMMENT

%%

{Keywords}  {
    if(token_flag==1){
        printf("#key:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Macros}  {
    if(token_flag==1){
        printf("#macro:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Operators}  {
    if(token_flag==1){
        printf("#op:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Punctuation}  {
    if(token_flag==1){
        printf("#punc:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Identifiers}  {
    if(token_flag==1){
        printf("#id:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Float}  {
    if(token_flag==1){
        printf("#float:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Integer}  {
    if(token_flag==1){
        printf("#integer:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{String}  {
    if(token_flag==1){
        printf("#string:%s\n", yytext);
    } 
    strcat(out, yytext);
}
{Char}  {
    if(token_flag==1){
        printf("#char:%s\n",yytext);
    }
    strcat(out, yytext);
}

#pragma([ ]|[ ]*[\t][ ]*)+source([ ]|[ ]*[\t][ ]*)+on  {
    source_flag = 1;
    strcat(out, yytext);
}
#pragma([ ]|[ ]*[\t][ ]*)+source([ ]|[ ]*[\t][ ]*)+off  {
    source_flag = 0; 
    strcat(out, yytext);
}
#pragma([ ]|[ ]*[\t][ ]*)+token([ ]|[ ]*[\t][ ]*)+on  {
    token_flag = 1; 
    strcat(out, yytext); 
}
#pragma([ ]|[ ]*[\t][ ]*)+token([ ]|[ ]*[\t][ ]*)+off  {
    token_flag = 0; 
    strcat(out, yytext); 
}

"//".*          {strcat(out, yytext);}
"/*"            {strcat(out, yytext); BEGIN COMMENT;}
<COMMENT>.      {strcat(out, yytext);}
<COMMENT>\n     {newLine();}
<COMMENT>"*/"   {strcat(out, yytext); BEGIN 0;}


\n      {newLine();}
[ \t]+  {strcat(out, yytext);} 

%%

int main(void){
    yylex();
    return 0;
}

int yywrap(){
    return 1;
}