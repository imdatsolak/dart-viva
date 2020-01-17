# Makefile for dartlib

include ../../lib/MakeMacros

all: 	$(INCLUDEDIR)/dartlib.h $(LIBDIR)/strncpy0.o \
		$(INCLUDEDIR)/debug.h $(LIBDIR)/debug.o

$(INCLUDEDIR)/debug.h: debug.h
	cp debug.h $(INCLUDEDIR)/.

$(LIBDIR)/debug.o: debug.o
	cp debug.o $(LIBDIR)/.

debug.o : debug.c $(INCLUDEDIR)/debug.h


$(INCLUDEDIR)/dartlib.h: dartlib.h
	cp dartlib.h $(INCLUDEDIR)/.

$(LIBDIR)/strncpy0.o: strncpy0.o
	cp strncpy0.o $(LIBDIR)/.

strncpy0.o : strncpy0.m $(INCLUDEDIR)/dartlib.h


