#ifndef UTIL_STRING_H
#define UTIL_STRING_H

/**
 * \file string.h
 * \brief Arquivo contendo um conjunto de funções para manipulação de strings.
 *
 * Arquivo que contém diversas funções de manipulação de strings.
 *
 * \author Matheus Henrique Nogueira de Paula
 * \author Rhyad Kryn Shamaon Janse
 * \author Victor Grudtner Boell
 */

/**
 * \file string.h
 * \brief Arquivo contendo funções de manipulação de strings.
 *
 */

#include <util/types.h>

/**
 * Remove todos os espaços em branco de uma string.
 * \param str string de entrada
 * \return string de entrada sem espaços.
 */
char* str_trim(const char* str);

/**
 * Remove todos os TABS de uma string.
 * \param str string de entrada.
 * \return string de entrada sem tabs.
 */
char* str_remove_tab(const char* str);

/**
 * Remove todos os caracteres de quebra de linha do texto.
 * \param str string de entrada
 * \return string de entrada sem caracteres de quebra de linha.
 */
char* str_sanitize(const char* str);

/**
 * Checa se um caracter está dentro do intervalo de caracteres válido.
 * \param ch caracter que será testado.
 * \param liminf limite inferior do intervalo.
 * \param limsup limite superior do intervalo.
 * \return verdadeiro se o caracter é válido.
 */
bool_t char_inrange(char ch, char liminf, char limsup);

/**
 * Checa se um caracter está contido numa string.
 * \param busca caracter que está sendo buscado.
 * \param string string onde o caracter será buscado.
 * \return true se o caracter estiver na string, false caso contrário.
 */
bool_t str_contains_char(const char busca, const char* string);

/**
 * Checa se uma string está contida numa outra string.
 * \param busca string que está sendo buscada.
 * \param string string onde a string de busca está sendo buscada.
 * \return true se a string de busca estiver na string, false caso contrário.
 */
bool_t str_contains_str(const char* busca, const char* string);

#endif
