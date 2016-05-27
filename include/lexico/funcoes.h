#ifndef FUNCOES_H
#define FUNCOES_H

#include <stdio.h>
#include <util/debug.h>
#include <estruturas/systable.h>

unsigned int coluna;
unsigned int linha;
struct SysTable* tabela;

void inicializa();
void termina();
void erro(const char *erro);
void debug(const char *msg);
void ignorar_comentario(const char *comentario, unsigned int tam);
void ignorar(unsigned int tam);
unsigned int adicionar_token(char* lexema);

#endif
