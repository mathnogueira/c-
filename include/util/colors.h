#ifndef COLOR_H
#define COLOR_H

#ifdef linux
	#define RED   "\033[31;1m"
	#define GRN   "\033[32m"
	#define YEL   "\033[33m"
	#define BLU   "\033[34m"
	#define MAG   "\033[35m"
	#define CYN   "\033[36m"
	#define WHT   "\033[37m"
	#define RESET "\033[0m"
#else
	#define RED	""
	#define GRN ""
	#define YEL ""
	#define BLU ""
	#define MAG ""
	#define CYN ""
	#define WHT ""
	#define RESET ""
#endif

#endif
