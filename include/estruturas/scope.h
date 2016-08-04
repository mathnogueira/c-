#ifndef SCOPE_H
#define SCOPE_H

#include <estruturas/systable.h>
#include <util/lista.h>

/**
 * Estrutura de árvore de escopos.
 *
 */
struct ScopeTree {
	struct ScopeNode* root;
};

/**
 * Estrutura que representa um escopo da árvore de escopos.
 */
struct ScopeNode {
	unsigned int id;						///< Id do escopo.
	struct SysTable *escopo;				///< Estrutura que armazena as variáveis do escopo.
	struct lista_encadeada *subscopes;		///< Lista de escopos filhos.
	unsigned int numChildren;				///< Número de escopos filhos.
	struct ScopeNode *parent;				///< Pai do escopo.
};

/**
 * Cria uma nova árvore de escopo, com o escopo global.
 *
 * @return árvore de escopos.
 */
struct ScopeTree* ScopeTree_Create();

/**
 * Destroi a árvore de escopos.
 *
 * @param tree árvore de escopos.
 */
void ScopeTree_Destroy(struct ScopeTree *tree);

/**
 * Anexa um novo escopo a um escopo.
 *
 * @param parent escopo pai.
 * @return escopo filho.
 */
 struct ScopeNode* ScopeNode_AddChild(struct ScopeNode *parent);

/**
 * Cria um novo nó da árvore de escopos.
 *
 * @return nó da árvore.
 */
struct ScopeNode* ScopeNode_Create();

/**
 * Destroi um escopo.
 *
 * @param scope escopo que será destruído.
 */
void ScopeNode_Destroy(struct ScopeNode *scope);


#endif
