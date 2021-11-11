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
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    SEMICOLON = 258,
    COMMA = 259,
    BLANKID = 260,
    STAR = 261,
    DIV = 262,
    MINUS = 263,
    PLUS = 264,
    EQ = 265,
    GE = 266,
    LBRACE = 267,
    LE = 268,
    LPAR = 269,
    LSQ = 270,
    MOD = 271,
    NE = 272,
    NOT = 273,
    AND = 274,
    OR = 275,
    RBRACE = 276,
    RPAR = 277,
    RSQ = 278,
    PACKAGE = 279,
    RETURN = 280,
    ELSE = 281,
    FOR = 282,
    IF = 283,
    VAR = 284,
    INT = 285,
    FLOAT32 = 286,
    BOOL = 287,
    STRING = 288,
    PRINT = 289,
    PARSEINT = 290,
    FUNC = 291,
    CMDARGS = 292,
    ASSIGN = 293,
    GT = 294,
    LT = 295
  };
#endif
/* Tokens.  */
#define SEMICOLON 258
#define COMMA 259
#define BLANKID 260
#define STAR 261
#define DIV 262
#define MINUS 263
#define PLUS 264
#define EQ 265
#define GE 266
#define LBRACE 267
#define LE 268
#define LPAR 269
#define LSQ 270
#define MOD 271
#define NE 272
#define NOT 273
#define AND 274
#define OR 275
#define RBRACE 276
#define RPAR 277
#define RSQ 278
#define PACKAGE 279
#define RETURN 280
#define ELSE 281
#define FOR 282
#define IF 283
#define VAR 284
#define INT 285
#define FLOAT32 286
#define BOOL 287
#define STRING 288
#define PRINT 289
#define PARSEINT 290
#define FUNC 291
#define CMDARGS 292
#define ASSIGN 293
#define GT 294
#define LT 295

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 48 "gocompiler.y"

    double value;
    char* string;

#line 142 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
