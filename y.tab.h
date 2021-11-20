/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    RESERVED = 258,
    SEMICOLON = 259,
    COMMA = 260,
    BLANKID = 261,
    STAR = 262,
    DIV = 263,
    MINUS = 264,
    PLUS = 265,
    EQ = 266,
    GE = 267,
    LBRACE = 268,
    LE = 269,
    LPAR = 270,
    LSQ = 271,
    MOD = 272,
    NE = 273,
    NOT = 274,
    AND = 275,
    OR = 276,
    RBRACE = 277,
    RPAR = 278,
    RSQ = 279,
    PACKAGE = 280,
    RETURN = 281,
    ELSE = 282,
    FOR = 283,
    IF = 284,
    VAR = 285,
    INT = 286,
    FLOAT32 = 287,
    BOOL = 288,
    STRING = 289,
    PRINT = 290,
    PARSEINT = 291,
    FUNC = 292,
    CMDARGS = 293,
    ASSIGN = 294,
    GT = 295,
    LT = 296,
    ID = 297,
    STRLIT = 298,
    REALLIT = 299,
    INTLIT = 300,
    END = 301
  };
#endif
/* Tokens.  */
#define RESERVED 258
#define SEMICOLON 259
#define COMMA 260
#define BLANKID 261
#define STAR 262
#define DIV 263
#define MINUS 264
#define PLUS 265
#define EQ 266
#define GE 267
#define LBRACE 268
#define LE 269
#define LPAR 270
#define LSQ 271
#define MOD 272
#define NE 273
#define NOT 274
#define AND 275
#define OR 276
#define RBRACE 277
#define RPAR 278
#define RSQ 279
#define PACKAGE 280
#define RETURN 281
#define ELSE 282
#define FOR 283
#define IF 284
#define VAR 285
#define INT 286
#define FLOAT32 287
#define BOOL 288
#define STRING 289
#define PRINT 290
#define PARSEINT 291
#define FUNC 292
#define CMDARGS 293
#define ASSIGN 294
#define GT 295
#define LT 296
#define ID 297
#define STRLIT 298
#define REALLIT 299
#define INTLIT 300
#define END 301

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 68 "gocompiler.y"

	struct Node *tree;
	char *string;

#line 154 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
