# ----------------------------------------------------------------------------
# Makefile
#
# release: 0.1 (28-Ago-2010) create makefile
#
# purpose: searches recursively in current directory for c/cpp files (using find),
#          compile each source file and link them in a executable.
#
# Credits: https://lembra.wordpress.com/2011/09/04/recursive-makefile/
# ----------------------------------------------------------------------------

APP     = c-
CC      = gcc -ansi
FC		= lex -d
RM      = rm
SRCDIR  = src
TESTDIR = tests
SRCEXT  = c
OBJDIR  = build

LEX     := src/lexico/lex.yy.c
SRCS    := $(shell find $(SRCDIR) -name '*.$(SRCEXT)')
SRCDIRS := $(shell find . -name '*.$(SRCEXT)' -exec dirname {} \; | uniq)
OBJS    := $(patsubst %.$(SRCEXT),$(OBJDIR)/%.o,$(SRCS))

DEBUG   = -ggdb -O0
RELEASE = -O2
INCLUDE = -Iinclude -I /usr/include
LIBS 	=
CFLAGS  = -lm -c $(DEBUG) $(INCLUDE)
OFLAGS  = -lm -msse2 -ffast-math -ftree-vectorize
LDFLAGS =

all:    $(LEX) $(APP)

debug:  buildrepo $(OBJS)
		$(CC) $(OBJS) $(OFLAGS) $(LDFLAGS) -o $(OBJDIR)/$@

$(LEX):	comp/lexico/analise.lex
	$(FC) $^
	mv lex.yy.c src/lexico/lex.yy.c

$(APP): buildrepo $(OBJS)
		$(CC) $(OBJS) $(OFLAGS) $(LDFLAGS) -o $(OBJDIR)/$@

$(OBJDIR)/%.o: %.$(SRCEXT)
		@echo "$(CC) $(CFLAGS) $< -o $@";
		@$(CC) $(CFLAGS) $< -o $@

clean:
		$(RM) -r -f $(OBJDIR) docs
		rm $(LEX)

buildrepo:
		$(call make-repo)

documentation: doxyfile docs
	doxygen
	cd docs/latex && make > /dev/null
	ln -s `pwd`/docs/latex/refman.pdf docs/documentation.pdf

docs:
	mkdir -p $@

define make-repo
		for dir in $(SRCDIRS); \
		do \
				mkdir -p $(OBJDIR)/$$dir; \
		done
endef
