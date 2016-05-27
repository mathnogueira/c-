#include <lexico/funcoes.h>
#include <stdio.h>

void inicializa() {
	coluna = 1;
	linha = 1;
}

void erro(const char *erro) {
	fprintf(stdout, "Erro (%d, %d): %s\n", linha, coluna, erro);
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
