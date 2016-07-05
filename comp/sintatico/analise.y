%{
	#include <stdio.h>
	#include <string.h>
	#include <lexico/funcoes.h>
	#include <sintatico/erro.h>

	int yylex();
	void yyerror (const char *msg);
	extern FILE *yyin, *yyout;
	extern char* yytext;
	unsigned int errno;
	extern unsigned char pulou_linha;
	/*int yydebug = 1;*/
%}

%token INT FLOAT CHAR VOID STRUCT TIPO
%token IF ELSE WHILE RETURN PALAVRA_RESERVADA
%token RELACIONAL
%token SOMA SUB MULT DIV ATRIBUICAO
%token NUM_INT NUM
%token ABRE_CHAVE FECHA_CHAVE ABRE_COLCHETE FECHA_COLCHETE ABRE_PARENTESES FECHA_PARENTESES
%token LETRA DIGITO DIGITOS PALVRA BINARIO HEXA
%token IDENT
%token PONTO VIRGULA PONTO_VIRGULA
%token QUEBRA_LINHA WS COMENTARIO

%nonassoc IF_PREC
%nonassoc ELSE

%error-verbose

%start programa

%locations

%%

/* Ponto inicial da gramatica */
programa:
	declaracao_lista
	;

/* Lista de declaracoes do programa */
declaracao_lista:
	  declaracao fatoracao_declaracao_lista
	;

fatoracao_declaracao_lista:
	declaracao_lista
	|
	;

/* Uma unica declaracao do programa (variavel ou função) */
declaracao:
	  var_declaracao
	| fun_declaracao
	;

/* Declaracao de variavel (unitaria ou vetor) */
var_declaracao:
	tipo_especificador IDENT PONTO_VIRGULA
	| tipo_especificador IDENT var_colchete PONTO_VIRGULA
	| error		{ errno = NO_SEMICOLON; yyclearin;}
	;

/* Declaracao auxiliar para definir os colchetes de um vetor */
var_colchete:
	ABRE_COLCHETE NUM_INT FECHA_COLCHETE var_colchete
	| ABRE_COLCHETE NUM_INT FECHA_COLCHETE
	| ABRE_COLCHETE error FECHA_COLCHETE		{}
	;

/* Declaracao de um tipo de um programa. */
tipo_especificador:
	  TIPO
	| STRUCT IDENT ABRE_CHAVE atributos_declaracao FECHA_CHAVE
	;

/* Declaração de um ou mais atributos no programa */
atributos_declaracao:
	  var_declaracao fatoracao_atributos_declaracao
	;

fatoracao_atributos_declaracao:
	atributos_declaracao
	|
	;

/* Declaração de uma função do programa */
fun_declaracao:
	  tipo_especificador IDENT ABRE_PARENTESES params FECHA_PARENTESES composto_decl
	  | tipo_especificador IDENT ABRE_PARENTESES params error composto_decl {}
	  | tipo_especificador error ABRE_PARENTESES params FECHA_PARENTESES composto_decl {}
	  ;

/* Parametros de uma função */
params:
	  param_lista
	| VOID
	| error
	;

/* Lista de parametros de uma função, usando virgula como separador. */
param_lista:
	param fatoracao_params_lista
	;

fatoracao_params_lista:
	VIRGULA param_lista
	|
	;

/* Unico parametro */
param:
	  tipo_especificador IDENT
	| tipo_especificador IDENT ABRE_COLCHETE FECHA_COLCHETE
	| tipo_especificador IDENT ABRE_COLCHETE error 	{}
	;

/* Grupo de declarações */
composto_decl:
	ABRE_CHAVE local_declaracoes comando_lista FECHA_CHAVE
	;

/* declaração de variaveis */
local_declaracoes:
	  var_declaracao fatoracao_local_declaracoes
	|
	;

fatoracao_local_declaracoes:
	  local_declaracoes
	;

/* Lista de comandos */
comando_lista:
	  comando fatoracao_comando_lista
	|
	;

fatoracao_comando_lista:
	comando_lista
	;

/* Comando */
comando:
	  selecao_decl
	| iteracao_decl
	| retorno_decl
	| expressao_decl
	| composto_decl
	;

/* Declaracao de uma expressao */
expressao_decl:
	  expressao PONTO_VIRGULA
	| PONTO_VIRGULA
	;

/* Declaração de um IF */
selecao_decl:
	selecao fatoracao_selecao_decl
	;

fatoracao_selecao_decl:
	  %prec IF_PREC
	| ELSE comando
	;

selecao:
	  IF ABRE_PARENTESES expressao FECHA_PARENTESES comando

/* Laço de repetição */
iteracao_decl:
	WHILE ABRE_PARENTESES expressao FECHA_PARENTESES comando
	;

/* Return */
retorno_decl:
	  RETURN PONTO_VIRGULA
	| RETURN expressao PONTO_VIRGULA
	;

/* Expressão var = expressao ou outra expressao */
expressao:
	  var ATRIBUICAO expressao
	| expressao_simples
	;

/* Variavel */
var:
	  IDENT
	| IDENT colchete_var
	;

/* Auxiliar para declaracao de variaveis */
colchete_var:
	  ABRE_COLCHETE expressao FECHA_COLCHETE colchete_var
	| ABRE_COLCHETE expressao FECHA_COLCHETE
	;

/* Expressao com operadores relacionais */
expressao_simples:
	  expressao_soma relacional expressao_soma
	| expressao_soma
	;

/* Operadores relacionais */
relacional:
	RELACIONAL
	;

/* Expressão de soma ou sub */
expressao_soma:
	  termo soma expressao_soma
	| termo
	;

/* Soma ou sub */
soma:
	  SOMA
	| SUB
	;

/* Expressao de mult ou div */
termo:
	  fator mult termo
	| fator
	;

/* Mult ou div */
mult:
	  MULT
	| DIV
	;

/* Fator */
fator:
	  ABRE_PARENTESES expressao FECHA_PARENTESES
	| ABRE_PARENTESES expressao error
	| var
	| ativacao
	| NUM
	| NUM_INT
	;

ativacao:
	IDENT ABRE_PARENTESES args FECHA_PARENTESES
	| IDENT ABRE_PARENTESES args error 			{ errno = NO_RPARENTHESIS; yyerrok; yyclearin; }

args:
	arg_lista
	|
	;

arg_lista:
	  expressao fatoracao_arg_lista
	;

fatoracao_arg_lista:
	VIRGULA arg_lista
	|
	;

%%

int main(int argc, char *argv[]) {
	inicializa();
	yyin = fopen(argv[1], "r");
	/*yyout = stdout;*/
	do {
		yyparse();
	} while (!feof(yyin));
	fclose(yyin);
	termina();
	return 0;
}

void yyerror (const char *msg) {
	char* message = (char*) msg;
	/*printf("%s na linha %d, coluna %d\n", msg, yylloc.first_line, yylloc.first_column);*/
	/*if (errno == NO_RBRACE)
		message = "Missing }";
	else if (errno == NO_RPARENTHESIS)
		message = "Missing )";
	else if (errno == NO_SEMICOLON)
		message = "Missing ;";*/
	if (strcmp(msg, "syntax error, unexpected IDENT, expecting ABRE_COLCHETE or PONTO_VIRGULA") == 0) {
		message = "Você esqueceu de colocar ; ou []";
	} else if (strcmp(msg, "syntax error, unexpected IDENT, expecting PONTO_VIRGULA") == 0) {
		message = "Você esqueceu de colocar ;";
	} else if (strcmp(msg, "syntax error, unexpected FECHA_PARENTESES, expecting NUM_INT or NUM or ABRE_PARENTESES or IDENT") == 0) {
		message = "Você declarou a lista de argumentos de maneira errada";
	} else if (strcmp(msg, "syntax error, unexpected ABRE_CHAVE, expecting FECHA_PARENTESES") == 0) {
		message = "Você não fechou o parenteses da função";
	} else if (strcmp(msg, "syntax error, unexpected FECHA_PARENTESES, expecting FECHA_COLCHETE") == 0) {
		message = "Você esqueceu de fechar o colchete";
	} else if (strcmp(msg, "syntax error, unexpected FECHA_COLCHETE, expecting NUM_INT") == 0) {
		message = "Você não definiu o tamanho do vetor";
	} else if (strcmp(msg, "syntax error, unexpected ABRE_PARENTESES, expecting IDENT") == 0) {
		message = "Você esqueceu de definir um nome para a função";
	} else if (strcmp(msg, "syntax error, unexpected FECHA_PARENTESES, expecting VOID or STRUCT or TIPO") == 0) {
		message = "Você deve definir sua função recebendo void como parametro";
	} else if (
		strcmp(msg, "syntax error, unexpected IDENT, expecting FECHA_PARENTESES") == 0 ||
		strcmp(msg, "syntax error, unexpected FECHA_PARENTESES, expecting PONTO_VIRGULA") == 0
		) {
		message = "Você esqueceu de fechar o parenteses da chamada de função ou separar os parametros por virgula";
	} else if (strcmp(msg, "syntax error, unexpected PONTO_VIRGULA, expecting FECHA_PARENTESES") == 0) {
		message = "Você esqueceu de fechar o parenteses";
	}
	unsigned int linha = yylloc.first_line;
	unsigned int coluna = yylloc.first_column;
	printf("%s na linha %d, coluna %d\n", message, linha, coluna);
}
