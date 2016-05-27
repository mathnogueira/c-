#include <util/lista.h>
#include <stdlib.h>

/* Estrutura que armazena um nó da lista. */
struct lista_encadeada_no {
        void* conteudo;                         /** Conteúdo do nó. */
        struct lista_encadeada_no* proximo;     /** Proximo nó da lista. */
};

/* Cria uma nova lista encadeada vazia. */
struct lista_encadeada* criar_lista()
{
        struct lista_encadeada* lista = (struct lista_encadeada*)
                malloc(sizeof(struct lista_encadeada));
        lista->cabeca = NULL;
        lista->tamanho = 0;
        return lista;
}

/* Destroi uma lista encadeada e todos os seus elementos. */
void destruir_lista(struct lista_encadeada* lista)
{
        struct lista_encadeada_no* cabeca = lista->cabeca;
        struct lista_encadeada_no* aux;
        while (cabeca != NULL) {
                aux = cabeca;
                cabeca = cabeca->proximo;
                free(aux);
        }
        free(lista);
}

/* Procura um elemento em uma lista utilizando um ponteiro para função,
 * assim determinando qual o método de comparação que será usado.
 *
 * Exemplo: buscar_regra_por_nome (regra.c)
 */
void* procurar_lista(struct lista_encadeada* lista,
                     void* procurado,
                     int (*cmp_fn)(void*, void*))
{
        struct lista_encadeada_no* cabeca = lista->cabeca;
        while (cabeca != NULL && cmp_fn(cabeca->conteudo, procurado))
                cabeca = cabeca->proximo;
        return cabeca ? cabeca->conteudo : NULL;
}

/* Retorna um elemento da lista utilizando uma posição como seletor. */
void* pegar_elemento_lista(struct lista_encadeada* lista, unsigned int pos)
{
        struct lista_encadeada_no* cabeca = lista->cabeca;
        if (cabeca == NULL)
                return NULL;
        unsigned int i = 0;
        while (i < pos && cabeca->proximo != NULL) {
                cabeca = cabeca->proximo;
                ++i;
        }
        return cabeca->conteudo;
}

/* Adiciona um novo elemento à lista encadeada. */
void adicionar_elemento_lista(struct lista_encadeada* lista, void* elemento)
{
        struct lista_encadeada_no* cabeca = lista->cabeca;
        struct lista_encadeada_no* no = (struct lista_encadeada_no*)
                malloc(sizeof(struct lista_encadeada_no));
        no->proximo = NULL;
        no->conteudo = elemento;
        if (cabeca == NULL) {
                lista->cabeca = no;
        } else {
                while (cabeca->proximo != NULL)
                        cabeca = cabeca->proximo;
                cabeca->proximo = no;
        }
        ++lista->tamanho;
}
