%{

#include <stdio.h>
#include "funcoes.h"

%}

/* TIPOS */
int 						"int"
float						"float"
char						"char"
void						"void"
struct						"struct"
tipo						{int}|{float}|{char}|{void}|{struct}

/* COMENTARIOS */
abre_comentario				"/*"
fecha_comentario			"*/"
comentario					{abre_comentario}[^\*\/]*{fecha_comentario}


/* PALAVRAS RESERVADAS */
if							"if"
else						"else"
while						"while"
return						"return"
palavra_reservada			{int}|{float}|{void}|{struct}|{if}|{else}|{while}|{return}

/* OPERADORES RELACIONAIS */
relacional					"<="|"<"|">"|">="|"=="|"!="

/* OPERADORES ARITMETICOS E ATRIBUICAO */
soma						"+"
sub							"-"
mult						"*"
div							"/"
atribuicao 					"="

/* VALORES */
num_int						{digitos}
num 						(\+|\-)?{digitos}({ponto}{digitos})?((e(\+|\-)?){digitos})?

/* ENCAPSULADORES */
abre_chave					"{"
fecha_chave					"}"
abre_colchete				"["
fecha_colchete				"]"
abre_parenteses 			"("
fecha_parenteses 			")"

/* AUXILIARES */
letra						[a-z]
digito						[0-9]
digitos						{digito}+
palavra						{letra}+

/* EXPRESSOES */

/* IDENTIFICADOR */
ident						{letra}({letra}|{digito})*

/* CARACTERES EM BRANCO */
espaco						" "
tabulacao					"\t"
quebra_linha				"\n"
ws							({espaco}|{tabulacao})+

/* DELIMITADORES */

/* ERRO */

/* DELIMITADORES */
ponto 						"."
virgula						","
ponto_virgula				";"

outros 						.


%%

{quebra_linha}				{ ; }
{ws}						{ ; }
{comentario}				{ printf("COMENTARIO   "); }
{tipo}						{ printf("<TIPO, %s>", yytext); }
{palavra_reservada}			{ printf("<PALAVRA_RESERVADA, %s>", yytext); }
{ident}						{ printf("<IDENT, %s>", yytext); }
{relacional}				{ printf("<RELOP, %s>", yytext); }
{atribuicao}				{ printf("<ATRIBUICAO, %s>", yytext); }
{soma}						{ printf("<SOMA, %s>", yytext); }
{mult}						{ printf("<MULT, %s>", yytext); }
{num_int}					{ printf("<NUM_INT, %d>", atoi(yytext)); }
{num}						{ printf("<NUM, %f>", atof(yytext)); }
{ponto_virgula}				{ printf("<PONTO_VIRGULA, %s>", yytext); }
{outros}					{ printf("ERRO: %s", yytext); }

%%

int main(int argc, char **argv) {
	yyin = fopen(argv[1], "r");
	return 0;
}

int yywrap() {
    return 0;
}

/*
	DUVIDAS:
	### Numero inteiro pode ser negativo?
	### Ponto e virgula depois de tipo?
	### (SINTATICA) Atributos-declaracao

	Erros a tratar:

	9.9e | 9.9e-- | 9.9ee | etc
	struct int
	2+2.9 ==> <num_int><num>

	Tipos não definidos:

	- Hexadecimal
	- Octal
	- Binario

	Comentario precisa ser ignorado (não precisa ter um token COMENTARIO)
	LEX precisa identificar erros.

	Usar ponto e virgula é um TOKEN.

	Dar print no nome dos tokens (linha a linha)

	ERRO: Exibir mensagem bonitinha pro usuário
*/
