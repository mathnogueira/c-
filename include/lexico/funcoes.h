#ifndef FUNCOES_H
#define FUNCOES_H

unsigned int coluna;
unsigned int linha;

void inicializa();
void erro(const char *erro);
void ignorar_comentario(const char *comentario, unsigned int tam);
void ignorar(unsigned int tam);

#endif
