#ifndef DEBUG_H
#define DEBUG_H

#include <util/colors.h>

#define DEBUG_MODE 0

#if DEBUG_MODE
	#define DEBUG(format, ...) {				\
		printf(format, __VA_ARGS__);			\
	}
#else
	#define DEBUG(format, ...) {}
#endif

#define ERRO(...) {													\
	fprintf(stderr, "%sErro%s na linha %s%d%s, coluna %s%d%s: ", RED, RESET, BLU, linha, RESET, BLU, coluna, RESET);				\
	fprintf(stderr, __VA_ARGS__);									\
	coluna += yyleng;												\
}

#endif
