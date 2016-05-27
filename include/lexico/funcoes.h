#ifndef FUNCOES_H
#define FUNCOES_H

#include <stdio.h>
#include <util/debug.h>

unsigned int coluna;
unsigned int linha;

void inicializa();
void erro(const char *erro);
void debug(const char *msg);
void ignorar_comentario(const char *comentario, unsigned int tam);
void ignorar(unsigned int tam);

#endif
