# Makefile for SubProcess

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/Subprocess.h $(LIBDIR)/Subprocess.o

$(INCLUDEDIR)/Subprocess.h: Subprocess.h
	cp Subprocess.h $(INCLUDEDIR)/.

$(LIBDIR)/Subprocess.o: Subprocess.o
	cp Subprocess.o $(LIBDIR)/.

Subprocess.o : Subprocess.m $(INCLUDEDIR)/Subprocess.h


