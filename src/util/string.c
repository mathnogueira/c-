#include <util/string.h>
#include <string.h>
#include <stdlib.h>

/* Função que remove todas as ocorrencias de um caracter em uma string. */
char* str_remove_char(const char* str, char c)
{
        unsigned int i, j;
        unsigned int tam;
        char* buffer;
        j = 0;
        tam = strlen(str);
        buffer = (char*) malloc(sizeof(char) * tam + 1);
        for (i = 0; i < tam; ++i) {
                if (str[i] != c) {
                        buffer[j++] = str[i];
                }
        }
        buffer[j] = '\0';
        return buffer;

}

/* Remove todos os espaços em branco de uma string. */
char* str_trim(const char* str)
{
        return str_remove_char(str, ' ');
}

/* Remove todas as tabulações de uma string. */
char* str_remove_tab(const char* str)
{
        return str_remove_char(str, '\t');
}

/* Remove todos os quebra linhas e todos os \r de uma string. */
char* str_sanitize(const char* str) 
{
        char* s = str_remove_char(str, '\r');
        return str_remove_char(s, '\n');
}

/* Checa se uma string contém um caracter especificado. */
bool_t str_contains_char(const char busca, const char* string)
{
        unsigned int i = 0;
        for (; i < strlen(string); ++i)
                if (busca == string[i])
                        return TRUE;
        return FALSE;
}

/* Checa se uma string contém uma substring */
bool_t str_contains_str(const char* busca, const char* string)
{
        int i = 0;
        int max = strlen(string) - strlen(busca) + 1;
        for (; i < max; ++i) {
                if (strncmp(string+i, busca, strlen(busca)) == 0)
                        return TRUE;
        }
        return FALSE;
}

/* Checa se um caracter está no intervalo de caracteres especificados (intervalo da ASCII table) */
bool_t char_inrange(char ch, char liminf, char limsup)
{
        char aux;
        if (limsup < liminf) {
                aux = limsup;
                limsup = liminf;
                liminf = aux;
        }
        return (liminf <= ch && ch <= limsup);
}
