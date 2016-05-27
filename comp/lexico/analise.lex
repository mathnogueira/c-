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
binario 					[0-1]
hexa 						[0-9a-fA-F]

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
erro_variavel_numero		{digito}+({letra}|{digito})*
erro_variavel_upcase		[A-Z]*({letra}|{digito})*[A-Z]+({letra}|{digito})*
erro_simbolo_invalido		"$"|"&"|"^"
erro_token_invalido			"+="|"-="|"*="|"/="
erro_real_invalido 			(\+|\-)?{digitos}({ponto}{digitos})?((e(\+|\-)?))?
erro_tipo_numerico			("0x"{hexa}+)|("0b"{binario}+)

/* DELIMITADORES */
ponto 						"."
virgula						","
ponto_virgula				";"

outros 						.


%%


{quebra_linha}				{ linha++; coluna = 1;}
{ws}						{ coluna += yyleng; }
{comentario}				{ ignorar_comentario(yytext, yyleng); }
{tipo}						{ DEBUG("<TIPO, %s>\n", yytext); coluna += yyleng; }
{palavra_reservada}			{ DEBUG("<PALAVRA_RESERVADA, %s>\n", yytext); coluna += yyleng; }
{ident}						{ DEBUG("<IDENT, %s>\n", yytext); coluna += yyleng; }
{relacional}				{ DEBUG("<RELOP, %s>\n", yytext); coluna += yyleng; }
{atribuicao}				{ DEBUG("<ATRIBUICAO, %s>\n", yytext); coluna += yyleng; }
{soma}						{ DEBUG("<SOMA, %s>\n", yytext); coluna += yyleng; }
{sub}						{ DEBUG("<SOMA, %s>\n", yytext); coluna += yyleng; }
{mult}						{ DEBUG("<MULT, %s>\n", yytext); coluna += yyleng; }
{div}						{ DEBUG("<SOMA, %s>\n", yytext); coluna += yyleng; }
{num_int}					{ DEBUG("<NUM_INT, %d>\n", atoi(yytext)); coluna += yyleng; }
{num}						{ DEBUG("<NUM, %f>\n", atof(yytext)); coluna += yyleng; }
{ponto_virgula}				{ DEBUG("<PONTO_VIRGULA, %s>\n", yytext); coluna += yyleng; }
{abre_chave}				{ coluna += yyleng; }
{fecha_chave}				{ coluna += yyleng; }
{abre_parenteses} 			{ coluna += yyleng; }
{fecha_parenteses}			{ coluna += yyleng; }
{abre_colchete}				{ coluna += yyleng; }
{fecha_colchete}			{ coluna += yyleng; }
{virgula}					{ coluna += yyleng; }
{erro_tipo_numerico}		{ ERRO("Numero definido em um tipo numerico que nao pertence a linguagem: %s\n", yytext);}
{erro_variavel_upcase}		{ ERRO("Variaveis nao podem conter letras maiusculas.\n"); }
{erro_variavel_numero}		{ ERRO("Variaveis devem comecar com uma letra.\n");}
{erro_simbolo_invalido}		{ ERRO("Caracter invalido: %s\n", yytext); }
{erro_real_invalido}		{ ERRO("Numero real invalido: %s\n", yytext);}
{erro_token_invalido}		{ ERRO("Token invalido: %s\n", yytext);}
{outros}					{ ERRO("Erro no lexema %s\n", yytext);}



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
