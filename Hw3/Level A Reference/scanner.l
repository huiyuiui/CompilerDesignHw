%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	
	int source = 1, token = 1;
	
	int line_count = 1;
	int line_idx = 0;
	char line[300];
	
	void match(char* t) {
		printf("match %s\n", t);
	}
	
	void append() {
		strcat(line, yytext);
	}
	
	void printLine() {
		if (source)
			printf("%d:%s\n", line_count, line);
		line_count++;
		line[0] = '\0';
	}
	
	void print(char* t) {
		if (token)
			printf("#%s:%s\n", t, yytext);
		append();
	}
	
	void num() {
		printf("number\n");
	}
%}

id [[:alpha:]_]([[:alnum:]_])*
integer [0-9]+
float ([0-9]+\.[0-9]*)|(\.[0-9]+)
char '((\\([[:alnum:]]+|.))|([ [:alnum:]]))'
string \"((\\.)|[^\n\"\\])*\"

%x COMMENT
%x LCOMMENT

%%

	/* key */
	/* "digitalWrite" { strcpy(yylval.strVal, "digitalWrite"); return DIGITALWRITE; }
	"delay" { strcpy(yylval.strVal, "delay"); return DELAY; } */
"HIGH" { yylval.intVal = 1; return V_INT; }
"LOW" { yylval.intVal = 0; return V_INT; }
"for" { strcpy(yylval.strVal, "for"); return FOR; }
"do" { strcpy(yylval.strVal, "do"); return DO; }
"while" { strcpy(yylval.strVal, "while"); return WHILE; }
"break" { strcpy(yylval.strVal, "break"); return BREAK; }
"continue" { strcpy(yylval.strVal, "continue"); return CONTINUE; }
"if" { strcpy(yylval.strVal, "if"); return IF; }
"else" { strcpy(yylval.strVal, "else"); return ELSE; }
"return" { strcpy(yylval.strVal, "return"); return RETURN; }
"struct" { strcpy(yylval.strVal, "struct"); return STRUCT; }
"switch" { strcpy(yylval.strVal, "switch"); return SWITCH; }
"case" { strcpy(yylval.strVal, "case"); return CASE; }
"default" { strcpy(yylval.strVal, "default"); return DEFAULT; }
"void" { strcpy(yylval.strVal, "void"); return VOID; }
"int" { strcpy(yylval.strVal, "int"); return INT; }
"double" { strcpy(yylval.strVal, "double"); return DOUBLE; }
"float" { strcpy(yylval.strVal, "float"); return FLOAT; }
"char" { strcpy(yylval.strVal, "char"); return CHAR; }
"const" { strcpy(yylval.strVal, "const"); return CONST; }
"signed" { strcpy(yylval.strVal, "signed"); return SIGNED; }
"unsigned" { strcpy(yylval.strVal, "unsigned"); return UNSIGNED; }
"short" { strcpy(yylval.strVal, "short"); return SHORT; }
"long" { strcpy(yylval.strVal, "long"); return LONG; }

	/* macro */
"NULL" { strcpy(yylval.strVal, "NULL"); return V_NULL; }
"__COUNTER__" { strcpy(yylval.strVal, "__COUNTER__"); return MACRO; }
"__LINE__" { strcpy(yylval.strVal, "__LINE__"); return MACRO; }
"INT_MAX" { strcpy(yylval.strVal, "INT_MAX"); return MACRO; }
"INT_MIN" { strcpy(yylval.strVal, "INT_MIN"); return MACRO; }
"CHAR_MAX" { strcpy(yylval.strVal, "CHAR_MAX"); return MACRO; }
"CHAR_MIN" { strcpy(yylval.strVal, "CHAR_MIN"); return MACRO; }
"MAX" { strcpy(yylval.strVal, "MAX"); return MACRO; }
"MIN" { strcpy(yylval.strVal, "MIN"); return MACRO; }
	
	/* id */
{id} { strcpy(yylval.strVal, yytext); return ID_NAME; }

	/* operator */
"+" { strcpy(yylval.strVal, "+"); return ADD; }
"-" { strcpy(yylval.strVal, "-"); return SUB; }
"*" { strcpy(yylval.strVal, "*"); return MUL; }
"/" { strcpy(yylval.strVal, "/"); return DIV; }
"%" { strcpy(yylval.strVal, "%"); return MOD; }
"++" { strcpy(yylval.strVal, "++"); return INC; }
"--" { strcpy(yylval.strVal, "--"); return DEC; }
"<" { strcpy(yylval.strVal, "<"); return LT; }
"<=" { strcpy(yylval.strVal, "<="); return LE; }
">" { strcpy(yylval.strVal, ">"); return GT; }
">=" { strcpy(yylval.strVal, ">="); return GE; }
"==" { strcpy(yylval.strVal, "=="); return EQ; }
"!=" { strcpy(yylval.strVal, "!="); return NE; }
"=" { strcpy(yylval.strVal, "="); return ASSIGN; }
"&&" { strcpy(yylval.strVal, "&&"); return AND; }
"||" { strcpy(yylval.strVal, "||"); return OR; }
"!" { strcpy(yylval.strVal, "!"); return NOT; }
"~" { strcpy(yylval.strVal, "~"); return BNOT; }
"&" { strcpy(yylval.strVal, "&"); return BAND; }
"|" { strcpy(yylval.strVal, "|"); return BOR; }
"^" { strcpy(yylval.strVal, "^"); return XOR; }
"<<" { strcpy(yylval.strVal, "<<"); return SL; }
">>" { strcpy(yylval.strVal, ">>"); return SR; }

	/* number */
{integer} { yylval.intVal = atoi(yytext); return V_INT; }
{float} { yylval.doubleVal = atof(yytext); return V_FLOAT; }

	/* punctuation */
":" { strcpy(yylval.strVal, ":"); return ':'; }
";" { strcpy(yylval.strVal, ";"); return ';'; }
"," { strcpy(yylval.strVal, ","); return ','; }
"." { strcpy(yylval.strVal, "."); return '.'; }
"[" { strcpy(yylval.strVal, "["); return '['; }
"]" { strcpy(yylval.strVal, "]"); return ']'; }
"(" { strcpy(yylval.strVal, "("); return '('; }
")" { strcpy(yylval.strVal, ")"); return ')'; }
"{" { strcpy(yylval.strVal, "{"); return '{'; }
"}" { strcpy(yylval.strVal, "}"); return '}'; }

	/* char & string */
{char} { strcpy(yylval.strVal, yytext); return V_CHAR; }
{string} { strcpy(yylval.strVal, yytext); return V_STRING; }
	
	/* TODO */
"/*" { append(); BEGIN COMMENT; }
"//" { append(); BEGIN LCOMMENT; }
<COMMENT>"*/" { append(); BEGIN 0; }
	
	/* USELESS */
"#pragma"[ \t]+"source"[ \t]+"on" { append(); source = 1; }
"#pragma"[ \t]+"source"[ \t]+"off" { append(); source = 0; }
"#pragma"[ \t]+"token"[ \t]+"on" { append(); token = 1; }
"#pragma"[ \t]+"token"[ \t]+"off" { append(); token = 0; }
	
	
. {}
<COMMENT,LCOMMENT>. {}
\n { line_count++; }
<COMMENT>\n {}
<LCOMMENT>\n { BEGIN 0; }

%%

int yywrap() {
	return 1;
}
