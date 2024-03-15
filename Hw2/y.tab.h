#ifndef _yy_defines_h_
#define _yy_defines_h_

#define IDENT 257
#define STRING 258
#define CHAR 259
#define NULL_VAL 260
#define INT 261
#define FLOAT 262
#define TYPE_INT 263
#define TYPE_CHAR 264
#define TYPE_FLOAT 265
#define TYPE_DOUBLE 266
#define CONST 267
#define SIGNED 268
#define UNSIGNED 269
#define LONG_LONG 270
#define LONG 271
#define SHORT 272
#define VOID 273
#define ASSIGN 274
#define LOGIC_OR 275
#define LOGIC_AND 276
#define BITWISE_OR 277
#define BITWISE_XOR 278
#define EQUAL 279
#define NOT_EQUAL 280
#define LESS 281
#define LESS_EQUAL 282
#define GREATER 283
#define GREATER_EQUAL 284
#define SHIFT_LEFT 285
#define SHIFT_RIGHT 286
#define DIV 287
#define MOD 288
#define LOGIC_NOT 289
#define BITWISE_NOT 290
#define L_SQUARE 291
#define R_SQUARE 292
#define L_PAREN 293
#define R_PAREN 294
#define AND_SYMBOL 295
#define STAR_SYMBOL 296
#define PLUS_SYMBOL 297
#define MINUS_SYMBOL 298
#define INCREMENT 299
#define DECREMENT 300
#define COMMA 301
#define COLON 302
#define SEMI_COLON 303
#define L_BRACKET 304
#define R_BRACKET 305
#define IF 306
#define ELSE 307
#define SWITCH 308
#define CASE 309
#define DEFAULT 310
#define WHILE 311
#define DO 312
#define FOR 313
#define RETURN 314
#define BREAK 315
#define CONTINUE 316
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE{
    int intVal;
    double doubleVal;
    char* strVal;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
