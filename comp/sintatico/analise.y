%{
	#include <stdio.h>
	#include <lexico/funcoes.h>

	int yylex(void);
	void yyerror(const char *s);
	extern FILE *yyin, *yyout;
	extern char* yytext;
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

%start programa

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
	tipo_especificador IDENT
	| tipo_especificador IDENT var_colchete
	;

/* Declaracao auxiliar para definir os colchetes de um vetor */
var_colchete:
	ABRE_COLCHETE NUM_INT FECHA_COLCHETE var_colchete
	| ABRE_COLCHETE NUM_INT FECHA_COLCHETE
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
	  | error FECHA_PARENTESES				{ yyerror("Fia da mae!!"); }
	  ;

/* Parametros de uma função */
params:
	VOID
	| param_lista
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
	;

/* Grupo de declarações */
composto_decl:
	ABRE_CHAVE local_declaracoes comando_lista FECHA_CHAVE
	;

/* declaração de variaveis */
local_declaracoes:
	  /* Lambda */
	| var_declaracao local_declaracoes
	;

/* Lista de comandos */
comando_lista:
	  /* Lambda */
	| comando comando_lista
	;

/* Comando */
comando:
	  expressao_decl
	| composto_decl
	| selecao_decl
	| iteracao_decl
	| retorno_decl
	;

/* Declaracao de uma expressao */
expressao_decl:
	  expressao PONTO_VIRGULA
	| PONTO_VIRGULA
	;

/* Declaração de um IF */
selecao_decl:
	      /*IF ABRE_PARENTESES expressao FECHA_PARENTESES comando %prec IFX
		| IF ABRE_PARENTESES expressao FECHA_PARENTESES ELSE comando*/
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
	| var
	| ativacao
	| NUM
	| NUM_INT
	;

ativacao:
	IDENT ABRE_PARENTESES args FECHA_PARENTESES

args:
	  /* Lambda */
	| arg_lista
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
		printf("EOF %d\n", feof(yyin));
		yyparse();
		printf("EOF %d\n", feof(yyin));
	} while (!feof(yyin));
	fclose(yyin);
	termina();
	return 0;
}

void yyerror(const char *s) {
	/*return 1;*/
	printf("%s na linha %d, coluna %d\n", s, linha, coluna);
}
