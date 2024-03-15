#ifndef _yy_defines_h_
#define _yy_defines_h_

#define V_INT 257
#define V_FLOAT 258
#define FOR 259
#define DO 260
#define WHILE 261
#define BREAK 262
#define CONTINUE 263
#define IF 264
#define ELSE 265
#define RETURN 266
#define STRUCT 267
#define SWITCH 268
#define CASE 269
#define DEFAULT 270
#define VOID 271
#define INT 272
#define DOUBLE 273
#define FLOAT 274
#define CHAR 275
#define CONST 276
#define SIGNED 277
#define UNSIGNED 278
#define SHORT 279
#define LONG 280
#define ID_NAME 281
#define ADD 282
#define SUB 283
#define MUL 284
#define DIV 285
#define MOD 286
#define INC 287
#define DEC 288
#define LT 289
#define LE 290
#define GT 291
#define GE 292
#define EQ 293
#define NE 294
#define ASSIGN 295
#define AND 296
#define OR 297
#define NOT 298
#define BAND 299
#define BOR 300
#define XOR 301
#define BNOT 302
#define SL 303
#define SR 304
#define NL 305
#define MACRO 306
#define V_CHAR 307
#define V_STRING 308
#define V_NULL 309
#define POSITIVE 310
#define NEGATIVE 311
#define POINTER 312
#define ADDRESS 313
#define TYPEOF 314
#define SUFINC 315
#define SUFDEC 316
#define FUNC_CALL 317
#define ARR_SUBSCRIPT 318
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE {
    int intVal;
    double doubleVal;
    char strVal[5000];
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
