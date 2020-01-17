# Makefile for Localizer

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/Localizer.h $(LIBDIR)/Localizer.o

$(INCLUDEDIR)/Localizer.h: Localizer.h
	cp Localizer.h $(INCLUDEDIR)/.

$(LIBDIR)/Localizer.o: Localizer.o
	cp Localizer.o $(LIBDIR)/.

Localizer.o : Localizer.m $(INCLUDEDIR)/Localizer.h $(INCLUDEDIR)/String.h

