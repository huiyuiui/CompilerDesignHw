#ifndef _yy_defines_h_
#define _yy_defines_h_

#define IDENT 257
#define STRING 258
#define CHAR 259
#define NULL_VAL 260
#define INT 261
#define VALUE 262
#define FLOAT 263
#define TYPE_INT 264
#define TYPE_CHAR 265
#define TYPE_FLOAT 266
#define TYPE_DOUBLE 267
#define CONST 268
#define SIGNED 269
#define UNSIGNED 270
#define LONG_LONG 271
#define LONG 272
#define SHORT 273
#define VOID 274
#define ASSIGN 275
#define LOGIC_OR 276
#define LOGIC_AND 277
#define BITWISE_OR 278
#define BITWISE_XOR 279
#define EQUAL 280
#define NOT_EQUAL 281
#define LESS 282
#define LESS_EQUAL 283
#define GREATER 284
#define GREATER_EQUAL 285
#define SHIFT_LEFT 286
#define SHIFT_RIGHT 287
#define DIV 288
#define MOD 289
#define LOGIC_NOT 290
#define BITWISE_NOT 291
#define L_SQUARE 292
#define R_SQUARE 293
#define L_PAREN 294
#define R_PAREN 295
#define AND_SYMBOL 296
#define STAR_SYMBOL 297
#define PLUS_SYMBOL 298
#define MINUS_SYMBOL 299
#define INCREMENT 300
#define DECREMENT 301
#define COMMA 302
#define COLON 303
#define SEMI_COLON 304
#define L_BRACKET 305
#define R_BRACKET 306
#define IF 307
#define ELSE 308
#define SWITCH 309
#define CASE 310
#define DEFAULT 311
#define WHILE 312
#define DO 313
#define FOR 314
#define RETURN 315
#define BREAK 316
#define CONTINUE 317
#define DIGITALWRITE 318
#define DELAY 319
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
