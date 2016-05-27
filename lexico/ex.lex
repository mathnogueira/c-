/*
	Etapa 1: Analise Lexica
	Disciplina: Compiladores
	Turma: 10A
	Alunos:
		Monica Faria
		Thiago Nobre
		Wilson Camilo
*/

%{
/*-------------------------- Definitions --------------------------*/
#include<stdio.h>

	/* Linha e coluna para referenciar tokens e erros */
	int linha = 1;
	int coluna = 1;
	int cont_erros = 0;

	/* Funcoes utilizadas */
	void ignora_comentario(char *, int);
%}


/* Tipo */
tipo 		"int"|"float"|"char"|"void"

/* Comentarios */
comentario		"#"[^#]*"#"

/* Palavras Reservadas */
palavra_reservada		"if"|"then"|"else"|"repeat"|"until"|"return"

/* Operadores relacionais */
rel_op		"=="|"!="|">="|">"|"<="|"<"

/* Operadores aritmeticos e atribuicao */
atrib			"="
soma_sub		"+"|"-"
mult_div		"*"|"/"

/* Valores */
num_int			[+-]?{digito}+
num_float		[+-]?{digito}+\.{digito}+
caractere		'.'

/* Encapsuladores */
abre_parenteses		"("
fecha_parenteses	")"
abre_chaves			"{"
fecha_chaves		"}"
abre_colchete		"["
fecha_colchete		"]"

/* Auxiliares */
cifrao			$
circunflexo		^
digito			[0-9]
letra			[a-z]

/* Identificador */
id		{cifrao}{letra}({letra}|{digito})*

/* Caracteres brancos (ignorados) */
espaco			[ ]
tabulacao		\t
quebra_linha	\n

/* Delimitadores */
ponto			"\."
virgula			","
ponto_virgula	";"

/* Erro */
erro_id				({letra}({letra}|{digito})*)|({cifrao}{digito}({letra}|{digito})*)
erro_exponencial	({num_int}|{num_float})E({num_int}|{num_float})?
erro_aritmetico		({soma_sub}|{mult_div})({soma_sub}|{mult_div})+
outro				.


%%
%{
/*----------------------------- Rules -----------------------------*/
%}

{espaco}			{ coluna++; }
{tabulacao}			{ coluna += 4; }
{quebra_linha}		{ linha++; coluna = 1; }

{comentario}		{ ignora_comentario(yytext, yyleng); }

{num_int}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Numero inteiro: %s\n", linha, coluna, yytext); coluna += yyleng; }
{num_float}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Numero real: %s\n", linha, coluna, yytext); coluna += yyleng; }
{caractere}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Caractere: %s\n", linha, coluna, yytext); coluna += yyleng; }

{abre_colchete}		{ fprintf(yyout,"(Linha %4d, Coluna %4d) Abre colchete: %s\n", linha, coluna, yytext); coluna += yyleng; }
{fecha_colchete}	{ fprintf(yyout,"(Linha %4d, Coluna %4d) Fecha colchete: %s\n", linha, coluna, yytext); coluna += yyleng; }
{abre_chaves}		{ fprintf(yyout,"(Linha %4d, Coluna %4d) Abre chaves: %s\n", linha, coluna, yytext); coluna += yyleng; }
{fecha_chaves}		{ fprintf(yyout,"(Linha %4d, Coluna %4d) Fecha chaves: %s\n", linha, coluna, yytext); coluna += yyleng; }
{abre_parenteses}	{ fprintf(yyout,"(Linha %4d, Coluna %4d) Abre parenteses: %s\n", linha, coluna, yytext); coluna += yyleng; }
{fecha_parenteses}	{ fprintf(yyout,"(Linha %4d, Coluna %4d) Fecha parenteses: %s\n", linha, coluna, yytext); coluna += yyleng; }

{ponto}				{ fprintf(yyout,"(Linha %4d, Coluna %4d) Ponto: %s\n", linha, coluna, yytext); coluna += yyleng; }
{virgula}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Virgula: %s\n", linha, coluna, yytext); coluna += yyleng; }
{ponto_virgula}		{ fprintf(yyout,"(Linha %4d, Coluna %4d) Ponto e virgula: %s\n", linha, coluna, yytext); coluna += yyleng; }

{rel_op}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Operador relacional: %s\n", linha, coluna, yytext); coluna += yyleng; }

{atrib}				{ fprintf(yyout,"(Linha %4d, Coluna %4d) Atribuicao: %s\n", linha, coluna, yytext); coluna += yyleng; }
{soma_sub}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Operador aritmetico: %s\n", linha, coluna, yytext); coluna += yyleng; }
{mult_div}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Operador aritmetico: %s\n", linha, coluna, yytext); coluna += yyleng; }

{tipo}					{ fprintf(yyout,"(Linha %4d, Coluna %4d) Tipo: %s\n", linha, coluna, yytext); coluna += yyleng; }
{palavra_reservada}		{ fprintf(yyout,"(Linha %4d, Coluna %4d) Palavra reservada: %s\n", linha, coluna, yytext); coluna += yyleng; }


{id}				{ fprintf(yyout,"(Linha %4d, Coluna %4d) Identificador: %s\n", linha, coluna, yytext); coluna += yyleng; }

{erro_id}			{ fprintf(yyout,"(Linha %4d, Coluna %4d) Erro em: %s\n", linha, coluna, yytext); coluna += yyleng; cont_erros++; }
{erro_exponencial}	{ fprintf(yyout,"(Linha %4d, Coluna %4d) Erro em: %s\n", linha, coluna, yytext); coluna += yyleng; cont_erros++; }
{erro_aritmetico}	{ fprintf(yyout,"(Linha %4d, Coluna %4d) Erro em: %s\n", linha, coluna, yytext); coluna += yyleng; cont_erros++; }
{outro}				{ fprintf(yyout,"(Linha %4d, Coluna %4d) Erro em: %s\n", linha, coluna, yytext); coluna += yyleng; cont_erros++; }

%%
/*------------------------ User subrotines ------------------------*/

/* Percorre todo o comentario ignoroando-o */
void ignora_comentario(char * texto_comentario, int tamanho) {

	int i;
	for (i = 0 ; i < tamanho ; i++){
		if (texto_comentario[i] == '\n'){
			linha++;
		}
	}
	coluna = 1;
}

int main(int argc, char *argv[]) {

	yyin = fopen(argv[1], "r");
    yyout=stdout;
    yylex();
    fclose(yyin);

	printf("\nQuantidade de erros encontrados: %d\n", cont_erros);

	return 0;
}

int yywrap(){
    return 0;
}
