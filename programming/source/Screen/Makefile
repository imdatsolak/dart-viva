# Makefile for Screen

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/Animator.h $(LIBDIR)/Animator.o \
	$(INCLUDEDIR)/NiftyMatrix.h $(LIBDIR)/NiftyMatrix.o \
	$(INCLUDEDIR)/HeadButton.h $(LIBDIR)/HeadButton.o \
	$(INCLUDEDIR)/PaletteView.h $(LIBDIR)/PaletteView.o \
	$(INCLUDEDIR)/TimerView.h $(LIBDIR)/TimerView.o \
	$(INCLUDEDIR)/TransparentWindow.h $(LIBDIR)/TransparentWindow.o \
	$(INCLUDEDIR)/dartPSwraps.h $(LIBDIR)/dartPSwraps.o
	

$(INCLUDEDIR)/dartPSwraps.h: dartPSwraps.h
	cp dartPSwraps.h $(INCLUDEDIR)/.

$(LIBDIR)/dartPSwraps.o: dartPSwraps.o
	cp dartPSwraps.o $(LIBDIR)/.

dartPSwraps.o : dartPSwraps.c $(INCLUDEDIR)/dartPSwraps.h

dartPSwraps.h : dartPSwraps.psw


$(INCLUDEDIR)/Animator.h: Animator.h
	cp Animator.h $(INCLUDEDIR)/.

$(LIBDIR)/Animator.o: Animator.o
	cp Animator.o $(LIBDIR)/.

Animator.o : Animator.m $(INCLUDEDIR)/Animator.h


$(INCLUDEDIR)/NiftyMatrix.h: NiftyMatrix.h
	cp NiftyMatrix.h $(INCLUDEDIR)/.

$(LIBDIR)/NiftyMatrix.o: NiftyMatrix.o
	cp NiftyMatrix.o $(LIBDIR)/.

NiftyMatrix.o : NiftyMatrix.m $(INCLUDEDIR)/NiftyMatrix.h


$(INCLUDEDIR)/HeadButton.h: HeadButton.h
	cp HeadButton.h $(INCLUDEDIR)/.

$(LIBDIR)/HeadButton.o: HeadButton.o
	cp HeadButton.o $(LIBDIR)/.

HeadButton.o : HeadButton.m $(INCLUDEDIR)/HeadButton.h


$(INCLUDEDIR)/PaletteView.h: PaletteView.h
	cp PaletteView.h $(INCLUDEDIR)/.

$(LIBDIR)/PaletteView.o: PaletteView.o
	cp PaletteView.o $(LIBDIR)/.

PaletteView.o : PaletteView.m $(INCLUDEDIR)/PaletteView.h $(INCLUDEDIR)/TransparentWindow.h $(INCLUDEDIR)/String.h 


$(INCLUDEDIR)/TimerView.h: TimerView.h
	cp TimerView.h $(INCLUDEDIR)/.

$(LIBDIR)/TimerView.o: TimerView.o
	cp TimerView.o $(LIBDIR)/.

TimerView.o : TimerView.m $(INCLUDEDIR)/TimerView.h


$(INCLUDEDIR)/TransparentWindow.h: TransparentWindow.h
	cp TransparentWindow.h $(INCLUDEDIR)/.

$(LIBDIR)/TransparentWindow.o: TransparentWindow.o
	cp TransparentWindow.o $(LIBDIR)/.

TransparentWindow.o : TransparentWindow.m $(INCLUDEDIR)/TransparentWindow.h $(INCLUDEDIR)/Animator.h $(INCLUDEDIR)/dartPSwraps.h


