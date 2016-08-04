#include <estruturas/scope.h>
#include <stdlib.h>

/**
 * Cria uma nova árvore de escopo, com o escopo global.
 *
 * @return árvore de escopos.
 */
struct ScopeTree* ScopeTree_Create() {
	struct ScopeTree *tree = (struct ScopeTree*) malloc(sizeof(struct ScopeTree));
	// Cria o escopo global
	struct ScopeNode *global = ScopeNode_Create();
	tree->root = global;
	return tree;
}

/**
 * Destroi a árvore de escopos.
 *
 * @param tree árvore de escopos.
 */
void ScopeTree_Destroy(struct ScopeTree *tree) {
	ScopeNode_Destroy(tree->root);
	free(tree);
}

/**
 * Cria um novo nó da árvore de escopos.
 *
 * @return nó da árvore.
 */
struct ScopeNode* ScopeNode_Create() {
	struct ScopeNode *node = (struct ScopeNode*) malloc(sizeof(struct ScopeNode));
	node->escopo = SysTable_Create();
	node->subscopes = criar_lista();
	node->parent = NULL;
	node->numChildren = 0;
	return node;
}

/**
 * Destroi um escopo.
 *
 * @param scope escopo que será destruído.
 */
void ScopeNode_Destroy(struct ScopeNode *scope) {
	unsigned int i = 0;
	struct ScopeNode* child;
	for (; i < scope->numChildren; ++i) {
		child = (struct ScopeNode*) pegar_elemento_lista(scope->subscopes, i);
		ScopeNode_Destroy(child);
	}
	SysTable_Destroy(scope->escopo);
	destruir_lista(scope->subscopes);
	free(scope);
}

/**
 * Anexa um novo escopo a um escopo.
 *
 * @param parent escopo pai.
 * @return escopo filho.
 */
struct ScopeNode* ScopeNode_AddChild(struct ScopeNode *parent) {
	struct ScopeNode *child = ScopeNode_Create();
	child->parent = parent;
	adicionar_elemento_lista(parent->subscopes, child);
	return child;
}
