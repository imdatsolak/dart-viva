# Makefile for SortList

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/SortList.h $(LIBDIR)/SortList.o

$(INCLUDEDIR)/SortList.h: SortList.h
	cp SortList.h $(INCLUDEDIR)/.

$(LIBDIR)/SortList.o: SortList.o
	cp SortList.o $(LIBDIR)/.

SortList.o : SortList.m $(INCLUDEDIR)/SortList.h $(INCLUDEDIR)/String.h


