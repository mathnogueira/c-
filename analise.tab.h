/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_ANALISE_TAB_H_INCLUDED
# define YY_YY_ANALISE_TAB_H_INCLUDED
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
    INT = 258,
    FLOAT = 259,
    CHAR = 260,
    VOID = 261,
    STRUCT = 262,
    TIPO = 263,
    IF = 264,
    ELSE = 265,
    WHILE = 266,
    RETURN = 267,
    PALAVRA_RESERVADA = 268,
    RELACIONAL = 269,
    SOMA = 270,
    SUB = 271,
    MULT = 272,
    DIV = 273,
    ATRIBUICAO = 274,
    NUM_INT = 275,
    NUM = 276,
    ABRE_CHAVE = 277,
    FECHA_CHAVE = 278,
    ABRE_COLCHETE = 279,
    FECHA_COLCHETE = 280,
    ABRE_PARENTESES = 281,
    FECHA_PARENTESES = 282,
    LETRA = 283,
    DIGITO = 284,
    DIGITOS = 285,
    PALVRA = 286,
    BINARIO = 287,
    HEXA = 288,
    IDENT = 289,
    PONTO = 290,
    VIRGULA = 291,
    PONTO_VIRGULA = 292,
    QUEBRA_LINHA = 293,
    WS = 294,
    COMENTARIO = 295,
    IF_PREC = 296
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_ANALISE_TAB_H_INCLUDED  */
