#ifndef LFA_LISTA_H
#define LFA_LISTA_H

/**
 * \file lista.h
 * \brief Arquivo contendo uma estrutura de lista encadeada.
 *
 * Arquivo que contém uma estrutura de lista encadeada que tem a capacidade
 * de armazenar qualquer tipo de dados.
 *
 * \author Matheus Henrique Nogueira de Paula
 * \author Rhyad Kryn Shamaon Janse
 * \author Victor Grudtner Boell
 */

/* Foward declaration do nó. */
struct lista_encadeada_no;

/**
 * Lista encadeada genérica.
 */
struct lista_encadeada {
        /** Cabeça da lista. */
        struct lista_encadeada_no* cabeca;
        /** Numero de elementos na lista. */
        unsigned int tamanho;
};

/**
 * Cria uma nova lista.
 * \return ponteiro para a nova lista vazia.
 */
struct lista_encadeada* criar_lista();

/**
 * Destroi uma lista existente.
 * \param lista lista a ser destruida.
 */
void destruir_lista(struct lista_encadeada* lista);

/**
 * Procura um elemento na lista.
 * \param lista lista onde o elemento será procurado.
 * \param procurado elemento que está sendo procurado na lista.
 * \param cmp_fn função de comparação que irá ser usada para procurar.
 * \return ponteiro para o elemento encontrado.
 */
void* procurar_lista(struct lista_encadeada* lista,
                     void* procurado,
                     int (*cmp_fn)(void*, void*));

/**
 * Pega um elemento que esteja localizado no indice especificao.
 * \param lista lista onde o elemento será procurado.
 * \param pos posição do elemento.
 */
void* pegar_elemento_lista(struct lista_encadeada* lista, unsigned int pos);

/**
 * Adiciona um novo elemento à lista.
 * \param lista lista onde o elemento será adicionado.
 * \param elemento ponteiro para o novo elemento da lista.
 */
void adicionar_elemento_lista(struct lista_encadeada* lista, void* elemento);

#endif
