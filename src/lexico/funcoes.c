#include <lexico/funcoes.h>
#include <stdio.h>

void inicializa() {
	coluna = 1;
	linha = 1;
	tabela = SysTable_Create();
}

void erro(const char *erro) {
	fprintf(stdout, "Erro (%d, %d): %s\n", linha, coluna, erro);
}

void debug(const char *msg) {
	#if(DEBUG)
		printf("%s\n", msg);
	#endif
}

unsigned int adicionar_token(char* lexema) {
	struct SysTableNode *no = SysTableNode_Create(lexema);
	return SysTable_Add(tabela, no);
}

void ignorar_comentario(const char *comentario, unsigned int tam) {
	unsigned int i = 0;
	for (; i < tam; ++i) {
		if (comentario[i] == '\n') {
			++linha;
			coluna = 1;
		}
		++coluna;
	}
}

void ignorar(unsigned int tam) {
	coluna += tam;
}

void termina() {
	SysTable_Destroy(tabela);
}
