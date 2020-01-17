# Makefile for NiController

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/NiController.h $(LIBDIR)/NiController.o

$(INCLUDEDIR)/NiController.h: NiController.h
	cp NiController.h $(INCLUDEDIR)/.

$(LIBDIR)/NiController.o: NiController.o
	cp NiController.o $(LIBDIR)/.

NiController.o : NiController.m $(INCLUDEDIR)/NiController.h


