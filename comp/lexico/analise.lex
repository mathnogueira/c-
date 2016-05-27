%{

#include <stdio.h>
#include <lexico/funcoes.h>

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
caracteres_especiais 		{soma}|{sub}|{mult}|{div}|{atribuicao}|\n
comentario					{abre_comentario}([^(*/)]|{caracteres_especiais})*{fecha_comentario}


/* PALAVRAS RESERVADAS */
if							"if"
else						"else"
while						"while"
return						"return"
palavra_reservada			{if}|{else}|{while}|{return}

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
espaco						[ ]
tabulacao					\t
quebra_linha				[\n]
ws							({espaco}|{tabulacao}|\r)+

/* DELIMITADORES */
eof 						<<EOF>>

/* ERRO */

/* DELIMITADORES */
ponto 						"."
virgula						","
ponto_virgula				";"

outros 						.


%%


{quebra_linha}				{ linha++; coluna = 1;}
{ws}						{ /* sem acao */ }
{comentario}				{ ignorar_comentario(yytext, yyleng); }
{tipo}						{ printf("<TIPO, %s>", yytext); coluna += yyleng; }
{palavra_reservada}			{ printf("<PALAVRA_RESERVADA, %s>", yytext); coluna += yyleng; }
{ident}						{ printf("<IDENT, %s>", yytext); coluna += yyleng; }
{relacional}				{ printf("<RELOP, %s>", yytext); coluna += yyleng; }
{atribuicao}				{ printf("<ATRIBUICAO, %s>", yytext); coluna += yyleng; }
{soma}						{ printf("<SOMA, %s>", yytext); coluna += yyleng; }
{mult}						{ printf("<MULT, %s>", yytext); coluna += yyleng; }
{num_int}					{ printf("<NUM_INT, %d>", atoi(yytext)); coluna += yyleng; }
{num}						{ printf("<NUM, %f>", atof(yytext)); coluna += yyleng; }
{ponto_virgula}				{ printf("<PONTO_VIRGULA, %s>", yytext); coluna += yyleng; }
{abre_chave}				{}
{fecha_chave}				{}
{abre_parenteses} 			{}
{virgula}					{}
{fecha_parenteses}			{}



%%

int main(int argc, char *argv[]) {
	inicializa();
	yyin = fopen(argv[1], "r");
	yyout = stdout;
	yylex();
	fclose(yyin);
	return 0;
}

int yywrap() {
    return 1;
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
