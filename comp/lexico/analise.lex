%{

#include <stdio.h>
#include <lexico/funcoes.h>
#include <sintatico/y.tab.h>

int yycolumn = 1;
unsigned char pulou_linha = 0;

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;

%}

%option yylineno

/* TIPOS */
int 						"int"
float						"float"
char						"char"
void						"void"
struct						"struct"
tipo						{int}|{float}|{char}|{void}

/* COMENTARIOS */
abre_comentario				"/*"
fecha_comentario			"*/"
caracteres_especiais 		{soma}|{sub}|{mult}|{div}|{atribuicao}
comentario					{abre_comentario}([^(*/)]|{caracteres_especiais})*{fecha_comentario}


/* PALAVRAS RESERVADAS */
if							"if"
else						"else"
while						"while"
return						"return"
/*palavra_reservada			{if}|{else}|{while}|{return}*/

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


{quebra_linha}				{
								linha++;
								yycolumn = 1;
								pulou_linha = 1;
							}
{ws}						{
	 							coluna += yyleng;
						 	}
{comentario}				{
								ignorar_comentario(yytext, yyleng);
								pulou_linha = 0;
							}
{void}						{
								DEBUG("<TIPO, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								pulou_linha = 0;
    							return VOID;
 							}
{tipo}						{
								DEBUG("<TIPO, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
								yylval.lexema = yytext;
   								return TIPO;
 							}
{if}						{
								DEBUG("<IF>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return IF;
 							}
{while}						{
								DEBUG("<WHILE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return WHILE;
 							}
{else}						{
								DEBUG("<ELSE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return ELSE;
 							}
{return}					{
								DEBUG("<RETURN>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return RETURN;
 							}
{ident}						{
								DEBUG("<IDENT, %s, %d>\n", yytext, adicionar_token(yytext));
 								coluna += yyleng;
  								pulou_linha = 0;
								yylval.lexema = yytext;
   								return IDENT;
 							}
{relacional}				{
								DEBUG("<RELOP, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return RELACIONAL;
 							}
{atribuicao}				{
								DEBUG("<ATRIBUICAO, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return ATRIBUICAO;
 							}
{soma}						{
								DEBUG("<SOMA, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return SOMA;
 							}
{sub}						{
								DEBUG("<SOMA, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return SUB;
 							}
{mult}						{
								DEBUG("<MULT, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return MULT;
 							}
{div}						{
								DEBUG("<SOMA, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return DIV;
 							}
{num_int}					{
								DEBUG("<NUM_INT, %d>\n", atoi(yytext));
 								coluna += yyleng;
  								pulou_linha = 0;
   								return NUM_INT;
 							}
{num}						{
								DEBUG("<NUM, %f>\n", atof(yytext));
 								coluna += yyleng;
  								pulou_linha = 0;
   								return NUM;
 							}
{ponto_virgula}				{
								DEBUG("<PONTO_VIRGULA, %s>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return PONTO_VIRGULA;
 							}
{abre_chave}				{
								DEBUG("<ABRE_CHAVE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return ABRE_CHAVE;
 							}
{fecha_chave}				{
								DEBUG("<FECHA_CHAVE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return FECHA_CHAVE;
 							}
{abre_parenteses} 			{
								DEBUG("<ABRE_PARENTESES>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return ABRE_PARENTESES;
 							}
{fecha_parenteses}			{
								DEBUG("<FECHA_PARENTESES>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return FECHA_PARENTESES;
 							}
{abre_colchete}				{
								DEBUG("<ABRE_COLCHETE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return ABRE_COLCHETE;
 							}
{fecha_colchete}			{
								DEBUG("<FECHA_COLCHETE>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return FECHA_COLCHETE;
 							}
{virgula}					{
								DEBUG("<VIRGULA>\n", yytext);
 								coluna += yyleng;
  								pulou_linha = 0;
   								return VIRGULA;
 							}
{erro_tipo_numerico}		{
								ERRO("Numero definido em um tipo numerico que nao pertence a linguagem: %s\n", yytext);
							}
{erro_variavel_upcase}		{
								ERRO("Variaveis nao podem conter letras maiusculas.\n");
 							}
{erro_variavel_numero}		{
								ERRO("Variaveis devem comecar com uma letra.\n");
							}
{erro_simbolo_invalido}		{
								ERRO("Caracter invalido: %s\n", yytext);
 							}
{erro_real_invalido}		{
								ERRO("Numero real invalido: %s\n", yytext);
							}
{erro_token_invalido}		{
								ERRO("Token invalido: %s\n", yytext);
							}
{outros}					{
								ERRO("Erro no lexema %s\n", yytext);
							}

%%

/*int main(int argc, char *argv[]) {
	inicializa();
	yyin = fopen(argv[1], "r");
	yyout = stdout;
	yylex();
	fclose(yyin);
	termina();
return 0;
}*/

int yywrap() {
    return 1;
}
