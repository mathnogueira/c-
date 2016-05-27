#include <estruturas/systable.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*
 * Funcao usada para procurar por um lexema na tabela de simbolos.
 *
 * @param l1 lexema da tabela.
 * @param l2 lexema a ser comparado.
 */
int compara_lexema(void* l1, void* l2) {
	struct SysTableNode* n1 = (struct SysTableNode*) l1;
	struct SysTableNode* n2 = (struct SysTableNode*) l2;
	return strcmp(n1->lexema, n2->lexema);
}

struct SysTable* SysTable_Create() {
	struct SysTable* table = (struct SysTable*) malloc(sizeof(struct SysTable));
	table->topo = criar_lista();
	table->ultimoId = 1;
	return table;
}

struct SysTableNode* SysTableNode_Create(char* lexema) {
	struct SysTableNode* node = (struct SysTableNode*) malloc(sizeof(struct SysTableNode));
	unsigned long length = strlen(lexema);
	node->lexema = (char*) malloc(sizeof(length + 1));
	strcpy(node->lexema, lexema);
	return node;
}

void SysTable_Destroy(struct SysTable *table) {
	destruir_lista(table->topo);
	free(table);
}

unsigned int SysTable_Add(struct SysTable *table, struct SysTableNode *node) {
	struct SysTableNode* item;
	item = (struct SysTableNode*) procurar_lista(table->topo, node, compara_lexema);
	if (item == NULL) {
		node->id = table->ultimoId++;
		adicionar_elemento_lista(table->topo, node);
	} else {
		node->id = item->id;
	}
	return node->id;
}
