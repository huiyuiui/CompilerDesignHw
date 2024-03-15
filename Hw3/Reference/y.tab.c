/* original parser id follows */
/* yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93" */
/* (use YYMAJOR/YYMINOR for ifdefs dependent on parser version) */

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20140715

#define YYEMPTY        (-1)
#define yyclearin      (yychar = YYEMPTY)
#define yyerrok        (yyerrflag = 0)
#define YYRECOVERING() (yyerrflag != 0)
#define YYENOMEM       (-2)
#define YYEOF          0
#define YYPREFIX "yy"

#define YYPURE 0

#line 1 "parser.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code.h"

int yylex();
int lineNo = 1;
int in_if = 0;
extern FILE* f_asm;
int arg_cnt;

#line 14 "parser.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
    int intVal;
    double doubleVal;
    char* sVal;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 47 "y.tab.c"

/* compatibility with bison */
#ifdef YYPARSE_PARAM
/* compatibility with FreeBSD */
# ifdef YYPARSE_PARAM_TYPE
#  define YYPARSE_DECL() yyparse(YYPARSE_PARAM_TYPE YYPARSE_PARAM)
# else
#  define YYPARSE_DECL() yyparse(void *YYPARSE_PARAM)
# endif
#else
# define YYPARSE_DECL() yyparse(void)
#endif

/* Parameters sent to lex. */
#ifdef YYLEX_PARAM
# define YYLEX_DECL() yylex(void *YYLEX_PARAM)
# define YYLEX yylex(YYLEX_PARAM)
#else
# define YYLEX_DECL() yylex(void)
# define YYLEX yylex()
#endif

/* Parameters sent to yyerror. */
#ifndef YYERROR_DECL
#define YYERROR_DECL() yyerror(const char *s)
#endif
#ifndef YYERROR_CALL
#define YYERROR_CALL(msg) yyerror(msg)
#endif

extern int YYPARSE_DECL();

#define NUM 257
#define DVALUE 258
#define TYPE 259
#define ID 260
#define IF 261
#define ELSE 262
#define DO 263
#define WHILE 264
#define FOR 265
#define RETURN 266
#define BREAK 267
#define CONTINUE 268
#define LESS_OR_EQUAL_THAN 269
#define GREATER_OR_EQUAL_THAN 270
#define EQUAL 271
#define NOT_EQUAL 272
#define ADD 273
#define MINUS 274
#define MULTIPLY 275
#define DIVIDE 276
#define LESS_THAN 277
#define GREATER_THAN 278
#define AND_OP 279
#define ASSIGN 280
#define SEMICOLON 281
#define COMMA 282
#define L_BRACKET 283
#define R_BRACKET 284
#define L_SQ_BRACKET 285
#define R_SQ_BRACKET 286
#define L_PARENTHESIS 287
#define R_PARENTHESIS 288
#define DIGITALWRITE 289
#define DELAY 290
#define UMINUS 291
#define UMULTI 292
#define UANDOP 293
#define YYERRCODE 256
typedef short YYINT;
static const YYINT yylhs[] = {                           -1,
    0,    6,    6,    5,    5,   25,    3,   26,    3,    1,
    1,    2,    2,    4,    4,    7,    7,    8,    8,    9,
    9,    9,    9,   23,   24,   10,   11,   11,   12,   12,
   13,   13,   14,   14,   14,   15,   15,   15,   16,   16,
   16,   16,   16,   17,   17,   17,   18,   18,   18,   19,
   19,   19,   19,   20,   20,   20,   21,   21,   21,   22,
   22,
};
static const YYINT yylen[] = {                            2,
    2,    2,    1,    2,    1,    0,    7,    0,    6,    1,
    3,    2,    3,    6,    5,    3,    2,    2,    1,    1,
    2,    1,    1,    7,    5,    3,    1,    3,    3,    1,
    1,    2,    3,    4,    1,    3,    3,    1,    3,    3,
    3,    3,    1,    3,    3,    1,    3,    3,    1,    2,
    2,    2,    1,    3,    4,    1,    1,    1,    3,    3,
    1,
};
static const YYINT yydefred[] = {                         0,
    0,    0,    3,    0,    0,    0,    5,    2,    0,    0,
    0,    0,    4,    0,    0,    0,   10,    0,    0,   12,
    0,   15,    0,    0,    0,    0,    0,   13,   11,   14,
    0,    0,    8,    0,    0,    9,    0,    6,   58,    0,
    0,    0,    0,    0,    0,   17,    0,    0,    0,   19,
   20,    0,    0,    0,    0,    0,   49,   53,   56,   22,
   23,    7,   31,    0,    0,   27,    0,    0,    0,    0,
    0,   50,    0,   52,    0,    0,    0,   16,   18,   21,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   32,   26,    0,    0,   33,   54,    0,    0,   51,    0,
   59,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   47,   48,   28,    0,    0,   55,   34,    0,    0,
    0,    0,   25,    0,   24,
};
static const YYINT yydgoto[] = {                          2,
   16,   17,    7,    3,    9,    4,   36,   49,   50,   51,
   65,   66,   67,   52,   53,   54,   55,   56,   57,   58,
   59,   98,   60,   61,   37,   31,
};
static const YYINT yysindex[] = {                      -247,
 -242,    0,    0, -234, -254, -228,    0,    0, -195, -257,
 -207, -191,    0, -255, -202, -265,    0, -250, -187,    0,
 -170,    0, -161, -181, -202, -222, -246,    0,    0,    0,
 -185, -181,    0, -214, -253,    0, -185,    0,    0, -252,
 -269, -182, -142,  -94, -182,    0, -109, -108, -216,    0,
    0, -103, -157, -224, -226, -145,    0,    0,    0,    0,
    0,    0,    0,  -81, -148,    0,  -98, -180, -218,  -93,
  -62,    0,  -89,    0, -256,  -51, -180,    0,    0,    0,
 -182, -182, -182, -182, -182, -182, -182, -182, -182, -182,
    0,    0, -252, -182,    0,    0, -157, -197,    0, -180,
    0,  -68,  -58, -224, -224, -226, -226, -226, -226, -145,
 -145,    0,    0,    0, -157, -182,    0,    0,  -36,  -54,
 -157,  -48,    0,  -44,    0,
};
static const YYINT yyrindex[] = {                         0,
    0,    0,    0,    0,    0,    0,    0,    0,  230,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -49,    0,    0,    0,    0,    0,
    0,  -41,    0,    0,    0,    0,    0,    0,    0,    0,
 -149,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0, -229,  -77,  -69, -117,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0, -135,    0,    0, -165,
    0,    0, -133,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0, -196,    0,    0,    0,
    0,    0,    0,  -61,  -29,  -53,  -37,  -21,   -5, -101,
  -85,    0,    0,    0, -132,    0,    0,    0,    0,    0,
 -193,    0,    0,    0,    0,
};
static const YYINT yygindex[] = {                         0,
   13,  216,  245,  254,    0,    0,  222,    0,  213,    0,
    0,  175,    0,  -67,  -45,   77,   -2,   75,  -39,    0,
    0,    0,    0,    0,    0,    0,
};
#define YYTABLESIZE 279
static const YYINT yytable[] = {                         75,
   95,   14,   72,   39,   20,   40,   41,   63,   14,  103,
   68,    1,   14,   69,   81,   82,   23,    5,   24,   21,
   42,   43,   64,   97,    6,   44,   15,  101,   10,   45,
   26,   11,  118,   25,   46,   47,   48,   33,   39,   34,
   39,   70,   40,   41,   83,   84,   87,   88,  115,  112,
  113,   35,   85,   86,   35,   42,   71,   42,   43,   23,
   44,   32,   44,   12,   45,   96,   45,   23,   19,   38,
  121,   78,   47,   48,   39,   18,   39,   70,   22,   41,
  106,  107,  108,  109,  116,   61,  117,   61,   60,   28,
   60,   42,   71,   42,   43,   27,   44,   14,   44,   30,
   45,   35,   45,   57,   57,   57,   57,   57,   57,   57,
   57,   57,   57,   81,   82,   57,   57,   73,   57,   57,
   57,   57,   57,   57,   57,   57,   57,   57,   57,   89,
   90,   57,   92,   93,   57,   51,   51,   51,   51,   51,
   51,   51,   51,   51,   51,   30,   30,   51,   29,   29,
   51,   46,   46,   46,   46,   46,   46,  104,  105,   46,
   46,  110,  111,   46,   46,   74,   46,   44,   44,   44,
   44,   44,   44,   76,   77,   44,   44,   80,   91,   44,
   44,   94,   44,   45,   45,   45,   45,   45,   45,   69,
  100,   45,   45,   38,   38,   45,   45,   99,   45,   43,
   43,   43,   43,   38,   38,  102,   38,   43,   43,   36,
   36,   43,   43,  119,   43,   42,   42,   42,   42,   36,
   36,  122,   36,   42,   42,  120,  123,   42,   42,    1,
   42,   41,   41,   41,   41,  124,  125,    8,   29,   41,
   41,   37,   37,   41,   41,    6,   41,   40,   40,   40,
   40,   37,   37,   13,   37,   40,   40,    8,   62,   40,
   40,   79,   40,   39,   39,   39,   39,  114,    0,    0,
    0,   39,   39,    0,    0,   39,   39,    0,   39,
};
static const YYINT yycheck[] = {                         45,
   68,  259,   42,  257,  260,  259,  260,  260,  259,   77,
  280,  259,  259,  283,  271,  272,  282,  260,  284,  275,
  274,  275,  275,   69,  259,  279,  284,  284,  283,  283,
   18,  260,  100,  284,  288,  289,  290,  284,  257,   27,
  257,  260,  259,  260,  269,  270,  273,  274,   94,   89,
   90,  281,  277,  278,  284,  274,  275,  274,  275,  282,
  279,  284,  279,  259,  283,  284,  283,  282,  260,  284,
  116,  288,  289,  290,  257,  283,  257,  260,  281,  260,
   83,   84,   85,   86,  282,  282,  284,  284,  282,  260,
  284,  274,  275,  274,  275,  283,  279,  259,  279,  281,
  283,  287,  283,  269,  270,  271,  272,  273,  274,  275,
  276,  277,  278,  271,  272,  281,  282,  260,  284,  269,
  270,  271,  272,  273,  274,  275,  276,  277,  278,  275,
  276,  281,  281,  282,  284,  269,  270,  271,  272,  273,
  274,  275,  276,  277,  278,  281,  282,  281,  281,  282,
  284,  269,  270,  271,  272,  273,  274,   81,   82,  277,
  278,   87,   88,  281,  282,  260,  284,  269,  270,  271,
  272,  273,  274,  283,  283,  277,  278,  281,  260,  281,
  282,  280,  284,  269,  270,  271,  272,  273,  274,  283,
  280,  277,  278,  271,  272,  281,  282,  260,  284,  269,
  270,  271,  272,  281,  282,  257,  284,  277,  278,  271,
  272,  281,  282,  282,  284,  269,  270,  271,  272,  281,
  282,  258,  284,  277,  278,  284,  281,  281,  282,    0,
  284,  269,  270,  271,  272,  284,  281,  287,   23,  277,
  278,  271,  272,  281,  282,  287,  284,  269,  270,  271,
  272,  281,  282,    9,  284,  277,  278,    4,   37,  281,
  282,   49,  284,  269,  270,  271,  272,   93,   -1,   -1,
   -1,  277,  278,   -1,   -1,  281,  282,   -1,  284,
};
#define YYFINAL 2
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 293
#define YYUNDFTOKEN 322
#define YYTRANSLATE(a) ((a) > YYMAXTOKEN ? YYUNDFTOKEN : (a))
#if YYDEBUG
static const char *const yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"NUM","DVALUE","TYPE","ID","IF",
"ELSE","DO","WHILE","FOR","RETURN","BREAK","CONTINUE","LESS_OR_EQUAL_THAN",
"GREATER_OR_EQUAL_THAN","EQUAL","NOT_EQUAL","ADD","MINUS","MULTIPLY","DIVIDE",
"LESS_THAN","GREATER_THAN","AND_OP","ASSIGN","SEMICOLON","COMMA","L_BRACKET",
"R_BRACKET","L_SQ_BRACKET","R_SQ_BRACKET","L_PARENTHESIS","R_PARENTHESIS",
"DIGITALWRITE","DELAY","UMINUS","UMULTI","UANDOP",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,"illegal-symbol",
};
static const char *const yyrule[] = {
"$accept : program",
"program : function_decls function_defs",
"function_decls : function_decls function_decl",
"function_decls : function_decl",
"function_defs : function_defs function_def",
"function_defs : function_def",
"$$1 :",
"function_def : TYPE ID L_BRACKET parameters R_BRACKET $$1 compound_stmt",
"$$2 :",
"function_def : TYPE ID L_BRACKET R_BRACKET $$2 compound_stmt",
"parameters : parameter",
"parameters : parameters COMMA parameter",
"parameter : TYPE ID",
"parameter : TYPE MULTIPLY ID",
"function_decl : TYPE ID L_BRACKET parameters R_BRACKET SEMICOLON",
"function_decl : TYPE ID L_BRACKET R_BRACKET SEMICOLON",
"compound_stmt : L_PARENTHESIS stmts R_PARENTHESIS",
"compound_stmt : L_PARENTHESIS R_PARENTHESIS",
"stmts : stmts stmt",
"stmts : stmt",
"stmt : scalar",
"stmt : assign_expr SEMICOLON",
"stmt : digitalwrite_stmt",
"stmt : delay_stmt",
"digitalwrite_stmt : DIGITALWRITE L_BRACKET NUM COMMA DVALUE R_BRACKET SEMICOLON",
"delay_stmt : DELAY L_BRACKET assign_expr R_BRACKET SEMICOLON",
"scalar : TYPE ids SEMICOLON",
"ids : id_decl",
"ids : ids COMMA id_decl",
"id_decl : id_decl_front ASSIGN equal_not_equal_expr",
"id_decl : id_decl_front",
"id_decl_front : ID",
"id_decl_front : MULTIPLY ID",
"assign_expr : ID ASSIGN assign_expr",
"assign_expr : MULTIPLY ID ASSIGN assign_expr",
"assign_expr : equal_not_equal_expr",
"equal_not_equal_expr : equal_not_equal_expr EQUAL other_branch_expr",
"equal_not_equal_expr : equal_not_equal_expr NOT_EQUAL other_branch_expr",
"equal_not_equal_expr : other_branch_expr",
"other_branch_expr : other_branch_expr GREATER_THAN add_minus_expr",
"other_branch_expr : other_branch_expr LESS_THAN add_minus_expr",
"other_branch_expr : other_branch_expr GREATER_OR_EQUAL_THAN add_minus_expr",
"other_branch_expr : other_branch_expr LESS_OR_EQUAL_THAN add_minus_expr",
"other_branch_expr : add_minus_expr",
"add_minus_expr : add_minus_expr ADD term_expr",
"add_minus_expr : add_minus_expr MINUS term_expr",
"add_minus_expr : term_expr",
"term_expr : term_expr MULTIPLY prefix_expr",
"term_expr : term_expr DIVIDE prefix_expr",
"term_expr : prefix_expr",
"prefix_expr : MINUS prefix_expr",
"prefix_expr : MULTIPLY ID",
"prefix_expr : AND_OP ID",
"prefix_expr : postfix_expr",
"postfix_expr : ID L_BRACKET R_BRACKET",
"postfix_expr : ID L_BRACKET arguments R_BRACKET",
"postfix_expr : expr_end",
"expr_end : ID",
"expr_end : NUM",
"expr_end : L_BRACKET equal_not_equal_expr R_BRACKET",
"arguments : arguments COMMA equal_not_equal_expr",
"arguments : equal_not_equal_expr",

};
#endif

int      yydebug;
int      yynerrs;

int      yyerrflag;
int      yychar;
YYSTYPE  yyval;
YYSTYPE  yylval;

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 10000
#define YYMAXDEPTH  10000
#endif
#endif

#define YYINITSTACKSIZE 200

typedef struct {
    unsigned stacksize;
    YYINT    *s_base;
    YYINT    *s_mark;
    YYINT    *s_last;
    YYSTYPE  *l_base;
    YYSTYPE  *l_mark;
} YYSTACKDATA;
/* variables for the parser stack */
static YYSTACKDATA yystack;
#line 364 "parser.y"


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
#line 393 "y.tab.c"

#if YYDEBUG
#include <stdio.h>		/* needed for printf */
#endif

#include <stdlib.h>	/* needed for malloc, etc */
#include <string.h>	/* needed for memset */

/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int yygrowstack(YYSTACKDATA *data)
{
    int i;
    unsigned newsize;
    YYINT *newss;
    YYSTYPE *newvs;

    if ((newsize = data->stacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return YYENOMEM;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = (int) (data->s_mark - data->s_base);
    newss = (YYINT *)realloc(data->s_base, newsize * sizeof(*newss));
    if (newss == 0)
        return YYENOMEM;

    data->s_base = newss;
    data->s_mark = newss + i;

    newvs = (YYSTYPE *)realloc(data->l_base, newsize * sizeof(*newvs));
    if (newvs == 0)
        return YYENOMEM;

    data->l_base = newvs;
    data->l_mark = newvs + i;

    data->stacksize = newsize;
    data->s_last = data->s_base + newsize - 1;
    return 0;
}

#if YYPURE || defined(YY_NO_LEAKS)
static void yyfreestack(YYSTACKDATA *data)
{
    free(data->s_base);
    free(data->l_base);
    memset(data, 0, sizeof(*data));
}
#else
#define yyfreestack(data) /* nothing */
#endif

#define YYABORT  goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR  goto yyerrlab

int
YYPARSE_DECL()
{
    int yym, yyn, yystate;
#if YYDEBUG
    const char *yys;

    if ((yys = getenv("YYDEBUG")) != 0)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = YYEMPTY;
    yystate = 0;

#if YYPURE
    memset(&yystack, 0, sizeof(yystack));
#endif

    if (yystack.s_base == NULL && yygrowstack(&yystack) == YYENOMEM) goto yyoverflow;
    yystack.s_mark = yystack.s_base;
    yystack.l_mark = yystack.l_base;
    yystate = 0;
    *yystack.s_mark = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
        {
            goto yyoverflow;
        }
        yystate = yytable[yyn];
        *++yystack.s_mark = yytable[yyn];
        *++yystack.l_mark = yylval;
        yychar = YYEMPTY;
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;

    YYERROR_CALL("syntax error");

    goto yyerrlab;

yyerrlab:
    ++yynerrs;

yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yystack.s_mark]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yystack.s_mark, yytable[yyn]);
#endif
                if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
                {
                    goto yyoverflow;
                }
                yystate = yytable[yyn];
                *++yystack.s_mark = yytable[yyn];
                *++yystack.l_mark = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yystack.s_mark);
#endif
                if (yystack.s_mark <= yystack.s_base) goto yyabort;
                --yystack.s_mark;
                --yystack.l_mark;
            }
        }
    }
    else
    {
        if (yychar == YYEOF) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = YYEMPTY;
        goto yyloop;
    }

yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    if (yym)
        yyval = yystack.l_mark[1-yym];
    else
        memset(&yyval, 0, sizeof yyval);
    switch (yyn)
    {
case 6:
#line 53 "parser.y"
	{
        cur_scope++;
        set_scope_and_offset_of_param(yystack.l_mark[-1].sVal);
        code_gen_func_header(yystack.l_mark[-3].sVal);
    }
break;
case 7:
#line 58 "parser.y"
	{
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body(yystack.l_mark[-5].sVal);
    }
break;
case 8:
#line 63 "parser.y"
	{
        cur_scope++;
        code_gen_func_header(yystack.l_mark[-2].sVal);
    }
break;
case 9:
#line 67 "parser.y"
	{
        pop_up_symbol(cur_scope);
        cur_scope--;
        code_gen_at_end_of_function_body(yystack.l_mark[-4].sVal);
    }
break;
case 12:
#line 80 "parser.y"
	{
        yyval.sVal = install_symbol(yystack.l_mark[0].sVal);
    }
break;
case 13:
#line 83 "parser.y"
	{
        yyval.sVal = install_symbol(yystack.l_mark[0].sVal);
    }
break;
case 14:
#line 89 "parser.y"
	{
        fprintf(f_asm, ".global %s\n", yystack.l_mark[-4].sVal);
    }
break;
case 15:
#line 92 "parser.y"
	{
        fprintf(f_asm, ".global %s\n", yystack.l_mark[-3].sVal);
    }
break;
case 24:
#line 115 "parser.y"
	{
        fprintf(f_asm, "    li a0, %d\n", yystack.l_mark[-4].intVal);
        fprintf(f_asm, "    li a1, %d\n", yystack.l_mark[-2].intVal);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, digitalWrite\n");
        fprintf(f_asm, "    ld ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
    }
break;
case 25:
#line 127 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    mv a0, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd ra, 0(sp)\n");
        fprintf(f_asm, "    jal ra, delay\n");
        fprintf(f_asm, "    ld ra, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
    }
break;
case 29:
#line 149 "parser.y"
	{
        yyval.sVal = install_symbol(yystack.l_mark[-2].sVal);
    }
break;
case 30:
#line 152 "parser.y"
	{
        yyval.sVal = install_symbol(yystack.l_mark[0].sVal);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd zero, 0(sp)\n");
    }
break;
case 31:
#line 160 "parser.y"
	{
        yyval.sVal = yystack.l_mark[0].sVal;
    }
break;
case 32:
#line 163 "parser.y"
	{
        yyval.sVal = yystack.l_mark[0].sVal;
    }
break;
case 33:
#line 169 "parser.y"
	{
        int index = look_up_symbol(yystack.l_mark[-2].sVal);
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    sd t0, %d(fp)\n", table[index].offset * (-8) - 32);
    }
break;
case 34:
#line 174 "parser.y"
	{
        int index = look_up_symbol(yystack.l_mark[-2].sVal);
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    ld t1, %d(fp)\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    add t1, fp, t1\n");
        fprintf(f_asm, "    sd t0, 0(t1)\n");
    }
break;
case 36:
#line 185 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bne t1, t0, L%d\n", cur_label);
    }
break;
case 37:
#line 192 "parser.y"
	{
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
break;
case 39:
#line 221 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bge t0, t1, L%d\n", cur_label);
    }
break;
case 40:
#line 228 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    bge t1, t0, L%d\n", cur_label);
    }
break;
case 41:
#line 235 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    blt t1, t0, L%d\n", cur_label);
    }
break;
case 42:
#line 242 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    blt t0, t1, L%d\n", cur_label);
    }
break;
case 44:
#line 253 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    add t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 45:
#line 262 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    sub t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 47:
#line 276 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    mul t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 48:
#line 285 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    ld t1, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    div t0, t1, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 50:
#line 299 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    addi sp, sp, 8\n");
        fprintf(f_asm, "    sub t0, zero, t0\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 51:
#line 306 "parser.y"
	{
        int index = look_up_symbol(yystack.l_mark[0].sVal);
        fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    add t0, t0, fp\n");
        fprintf(f_asm, "    ld t1, 0(t0)\n");
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t1, 0(sp)\n");
    }
break;
case 52:
#line 314 "parser.y"
	{
        int index = look_up_symbol(yystack.l_mark[0].sVal);
        fprintf(f_asm, "    li t0, %d\n", table[index].offset * (-8) - 32);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 54:
#line 325 "parser.y"
	{
        fprintf(f_asm, "    jal ra, %s\n", yystack.l_mark[-2].sVal);
    }
break;
case 55:
#line 328 "parser.y"
	{
        fprintf(f_asm, "    jal ra, %s\n", yystack.l_mark[-3].sVal);
    }
break;
case 57:
#line 335 "parser.y"
	{
        int index = look_up_symbol(yystack.l_mark[0].sVal);
        if (table[index].mode == LOCAL_MODE) {
            fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 32);
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    sd t0, 0(sp)\n");
        } else {
            fprintf(f_asm, "    ld t0, %d(fp)\n", table[index].offset * (-8) - 16);
            fprintf(f_asm, "    addi sp, sp, -8\n");
            fprintf(f_asm, "    sd t0, 0(sp)\n");
        }
    }
break;
case 58:
#line 347 "parser.y"
	{
        fprintf(f_asm, "    li t0, %d\n", yystack.l_mark[0].intVal);
        fprintf(f_asm, "    addi sp, sp, -8\n");
        fprintf(f_asm, "    sd t0, 0(sp)\n");
    }
break;
case 61:
#line 357 "parser.y"
	{
        fprintf(f_asm, "    ld t0, 0(sp)\n");
        fprintf(f_asm, "    mv a%d, t0\n", arg_cnt);
        arg_cnt++;
    }
break;
#line 917 "y.tab.c"
    }
    yystack.s_mark -= yym;
    yystate = *yystack.s_mark;
    yystack.l_mark -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yystack.s_mark = YYFINAL;
        *++yystack.l_mark = yyval;
        if (yychar < 0)
        {
            if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
            if (yydebug)
            {
                yys = yyname[YYTRANSLATE(yychar)];
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == YYEOF) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yystack.s_mark, yystate);
#endif
    if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
    {
        goto yyoverflow;
    }
    *++yystack.s_mark = (YYINT) yystate;
    *++yystack.l_mark = yyval;
    goto yyloop;

yyoverflow:
    YYERROR_CALL("yacc stack overflow");

yyabort:
    yyfreestack(&yystack);
    return (1);

yyaccept:
    yyfreestack(&yystack);
    return (0);
}
