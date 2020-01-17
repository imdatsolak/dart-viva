# Makefile for FieldValues + ColumnBrowserCell

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/FieldValue.h $(LIBDIR)/FieldValue.o \
	$(INCLUDEDIR)/NullValue.h $(LIBDIR)/NullValue.o \
	$(INCLUDEDIR)/String.h $(LIBDIR)/String.o \
	$(INCLUDEDIR)/Integer.h $(LIBDIR)/Integer.o \
	$(INCLUDEDIR)/Double.h $(LIBDIR)/Double.o \
	$(INCLUDEDIR)/Date.h $(LIBDIR)/Date.o \
	$(INCLUDEDIR)/DateField.h $(LIBDIR)/DateField.o \
	$(INCLUDEDIR)/BrowserRow.h $(LIBDIR)/BrowserRow.o \
	$(INCLUDEDIR)/ColumnBrowserCell.h $(LIBDIR)/ColumnBrowserCell.o \
	$(INCLUDEDIR)/fieldvaluekit.h


$(INCLUDEDIR)/fieldvaluekit.h: fieldvaluekit.h
	cp fieldvaluekit.h $(INCLUDEDIR)/.


fieldvaluekit.h: $(INCLUDEDIR)/FieldValue.h $(INCLUDEDIR)/NullValue.h $(INCLUDEDIR)/String.h $(INCLUDEDIR)/Integer.h $(INCLUDEDIR)/Double.h $(INCLUDEDIR)/Date.h
	touch fieldvaluekit.h


$(INCLUDEDIR)/FieldValue.h: FieldValue.h
	cp FieldValue.h $(INCLUDEDIR)/.

$(LIBDIR)/FieldValue.o: FieldValue.o
	cp FieldValue.o $(LIBDIR)/.

FieldValue.o : FieldValue.m $(INCLUDEDIR)/fieldvaluekit.h


$(INCLUDEDIR)/NullValue.h: NullValue.h
	cp NullValue.h $(INCLUDEDIR)/.

$(LIBDIR)/NullValue.o: NullValue.o
	cp NullValue.o $(LIBDIR)/.

NullValue.o : NullValue.m $(INCLUDEDIR)/fieldvaluekit.h


$(INCLUDEDIR)/String.h: String.h
	cp String.h $(INCLUDEDIR)/.

$(LIBDIR)/String.o: String.o
	cp String.o $(LIBDIR)/.

String.o : String.m  $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/ColumnBrowserCell.h


$(INCLUDEDIR)/Integer.h: Integer.h
	cp Integer.h $(INCLUDEDIR)/.

$(LIBDIR)/Integer.o: Integer.o
	cp Integer.o $(LIBDIR)/.

Integer.o : Integer.m $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/ColumnBrowserCell.h



$(INCLUDEDIR)/Double.h: Double.h
	cp Double.h $(INCLUDEDIR)/.

$(LIBDIR)/Double.o: Double.o
	cp Double.o $(LIBDIR)/.

Double.o : Double.m $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/ColumnBrowserCell.h


$(INCLUDEDIR)/Date.h: Date.h
	cp Date.h $(INCLUDEDIR)/.

$(LIBDIR)/Date.o: Date.o
	cp Date.o $(LIBDIR)/.

Date.o : Date.m $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/ColumnBrowserCell.h 


$(INCLUDEDIR)/DateField.h: DateField.h
	cp DateField.h $(INCLUDEDIR)/.

$(LIBDIR)/DateField.o: DateField.o
	cp DateField.o $(LIBDIR)/.

DateField.o : DateField.m $(INCLUDEDIR)/DateField.h


$(INCLUDEDIR)/BrowserRow.h: BrowserRow.h
	cp BrowserRow.h $(INCLUDEDIR)/.

$(LIBDIR)/BrowserRow.o: BrowserRow.o
	cp BrowserRow.o $(LIBDIR)/.

BrowserRow.o : BrowserRow.m $(INCLUDEDIR)/BrowserRow.h


$(INCLUDEDIR)/ColumnBrowserCell.h: $(INCLUDEDIR)/dartlib.h ColumnBrowserCell.h
	cp ColumnBrowserCell.h $(INCLUDEDIR)/.

$(LIBDIR)/ColumnBrowserCell.o: ColumnBrowserCell.o
	cp ColumnBrowserCell.o $(LIBDIR)/.

ColumnBrowserCell.o : ColumnBrowserCell.m $(INCLUDEDIR)/ColumnBrowserCell.h $(INCLUDEDIR)/BrowserRow.h $(INCLUDEDIR)/dartlib.h


