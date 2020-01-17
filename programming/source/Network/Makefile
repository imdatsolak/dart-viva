# Makefile for NetworkSpeaker/NetworkListener

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/NetworkSpeaker.h $(LIBDIR)/NetworkSpeaker.o \
	$(INCLUDEDIR)/NetworkListener.h $(LIBDIR)/NetworkListener.o 
	

$(INCLUDEDIR)/NetworkSpeaker.h: NetworkSpeaker.h
	cp NetworkSpeaker.h $(INCLUDEDIR)/.

$(LIBDIR)/NetworkSpeaker.o: NetworkSpeaker.o
	cp NetworkSpeaker.o $(LIBDIR)/.

NetworkSpeaker.o : NetworkSpeaker.m $(INCLUDEDIR)/NetworkSpeaker.h


$(INCLUDEDIR)/NetworkListener.h: NetworkListener.h
	cp NetworkListener.h $(INCLUDEDIR)/.

$(LIBDIR)/NetworkListener.o: NetworkListener.o
	cp NetworkListener.o $(LIBDIR)/.

NetworkListener.o : NetworkListener.m  $(INCLUDEDIR)/NetworkListener.h

NetworkListener.h : Network
	msgwrap Network

NetworkListener.m : Network
	msgwrap Network

NetworkSpeaker.h : Network
	msgwrap Network

NetworkSpeaker.m : Network
	msgwrap Network

