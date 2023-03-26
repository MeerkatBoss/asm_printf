CC:=g++

CFLAGS:=-D _DEBUG -ggdb3 -std=c++2a -O0 -Wall -Wextra -Weffc++\
-Waggressive-loop-optimizations -Wc++14-compat -Wmissing-declarations\
-Wcast-align -Wcast-qual -Wchar-subscripts -Wconditionally-supported\
-Wconversion -Wctor-dtor-privacy -Wempty-body -Wfloat-equal -Wformat-nonliteral\
-Wformat-security -Wformat-signedness -Wformat=2 -Winline -Wlogical-op\
-Wnon-virtual-dtor -Wopenmp-simd -Woverloaded-virtual -Wpacked -Wpointer-arith\
-Winit-self -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo\
-Wstrict-null-sentinel -Wstrict-overflow=2 -Wsuggest-attribute=noreturn\
-Wsuggest-final-methods -Wsuggest-final-types -Wsuggest-override\
-Wswitch-default -Wswitch-enum -Wsync-nand -Wundef -Wunreachable-code -Wunused\
-Wuseless-cast -Wvariadic-macros -Wno-literal-suffix\
-Wno-missing-field-initializers -Wno-narrowing -Wno-old-style-cast\
-Wno-varargs -Wstack-protector -Wlarger-than=8192 -Wstack-usage=8192\
-pie -fPIE

CHECK_FLAGS= -fcheck-new -fsized-deallocation -fstack-protector\
-fstrict-overflow -flto-odr-type-merging -fno-omit-frame-pointer\
-fsanitize=address,alignment,bool,bounds,enum,float-cast-overflow,${strip \
}float-divide-by-zero,integer-divide-by-zero,leak,nonnull-attribute,${strip \
}null,object-size,return,returns-nonnull-attribute,shift,${strip \
}signed-integer-overflow,undefined,unreachable,vla-bound,vptr\

BUILDTYPE?=Debug

ifeq ($(BUILDTYPE), Release)
	CFLAGS:=-std=c++2a -O3 -Wall
endif

ifndef NOCHECK
	CFLAGS:=$(CFLAGS) $(CHECK_FLAGS)
endif

PROJECT	:= printf
VERSION := 0.0.1

SRCDIR	:= src
OBJDIR 	:= obj
BINDIR	:= bin
LIBDIR	:= lib
INCDIR	:= include

SRCEXT	:= cpp
HEADEXT	:= h
OBJEXT	:= o
ASMEXT	:= asm


SOURCES := $(shell find $(SRCDIR) -type f -name "*.$(SRCEXT)")
ASMSRCS := $(shell find $(SRCDIR) -type f -name "*.$(ASMEXT)")
LIBS	:= $(patsubst lib%.a, %, $(shell find $(LIBDIR) -type f))
OBJECTS	:= $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))
ASMOBJS	:= $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(ASMSRCS:.$(ASMEXT)=.$(OBJEXT)))

INCFLAGS:= -I$(SRCDIR) -I$(INCDIR)
LFLAGS  := -Llib/ $(addprefix -l, $(LIBS))

all: $(BINDIR)/$(PROJECT)

remake: cleaner all

init:
	@mkdir $(SRCDIR)
	@mkdir $(INCDIR)
	@mkdir $(LIBDIR)
	@mkdir $(OBJDIR)
	@mkdir $(BINDIR)

build_lib: $(OBJECTS)
	@mkdir -p dist/include
	@mkdir -p dist/lib
	@ar rcs dist/lib/lib$(PROJECT).a $^
	@find $(SRCDIR) -type f -name *.$(HEADEXT) -exec\
		bash -c 'cp -p --parents {} dist/include' \;
	@tar -czf dist/$(PROJECT)-$(VERSION)-linux-x86_64.tar.gz dist/*
	@rm -r dist/include
	@rm -r dist/lib



$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $(INCFLAGS) -c $< -o $@

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(ASMEXT)
	@mkdir -p $(dir $@)
	@nasm -f elf64 $(INCFLAGS) $< -o $@

$(BINDIR)/$(PROJECT): $(OBJECTS) $(ASMOBJS)
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $^ $(LFLAGS) -o $(BINDIR)/$(PROJECT)

clean:
	@rm -rf $(OBJDIR)

cleaner: clean
	@rm -rf $(BINDIR)

run: $(BINDIR)/$(PROJECT)
	$(BINDIR)/$(PROJECT) $(ARGS)

.PHONY: all remake clean cleaner

