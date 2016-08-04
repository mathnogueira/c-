#ifndef SYSTABLE_H
#define SYSTABLE_H

#include <util/lista.h>

struct SysTable {
	struct lista_encadeada *topo;
	unsigned int ultimoId;
};

struct SysTableNode {
	unsigned int id;
	char *lexema;
	char *type;
	unsigned int scopeId;
};

/**
 * Cria uma nova tabela de simbolos.
 *
 * @return uma tabela de simbolos vazia.
 */
struct SysTable* SysTable_Create();

/**
 * Cria um no da tabela de simbolos.
 *
 * @param lexema lexema que sera inserido na tabela.
 * @return no da tabela.
 */
struct SysTableNode* SysTableNode_Create(char* lexema);

/**
 * Destroi a tabela de simbolos.
 * @param table tabela de simbolos.
 */
void SysTable_Destroy(struct SysTable *table);

/**
 * Adiciona um elemento na tabela de simbolos.
 *
 * @param table tabela de simbolos
 * @param node elemento a ser inserido na tabela de simbolos.
 * @return id do elemento inserido na tabela.
 */
unsigned int SysTable_Add(struct SysTable *table, struct SysTableNode *node);

#endif
