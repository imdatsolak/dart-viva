# Makefile for Queries

include ../../lib/MakeMacros

all: $(INCLUDEDIR)/QueryResult.h $(LIBDIR)/QueryResult.o \
	$(INCLUDEDIR)/QueryResultRow.h $(LIBDIR)/QueryResultRow.o \
	$(INCLUDEDIR)/QueryString.h $(LIBDIR)/QueryString.o \
	$(INCLUDEDIR)/Query.h $(LIBDIR)/Query.o \
	$(INCLUDEDIR)/BulkQuery.h $(LIBDIR)/BulkQuery.o \
	$(INCLUDEDIR)/querykit.h


$(INCLUDEDIR)/querykit.h: querykit.h
	cp querykit.h $(INCLUDEDIR)/.

querykit.h: $(INCLUDEDIR)/QueryString.h $(INCLUDEDIR)/QueryResultRow.h $(INCLUDEDIR)/QueryResult.h $(INCLUDEDIR)/Query.h $(INCLUDEDIR)/BulkQuery.h
	touch querykit.h


QueryResult.h: $(INCLUDEDIR)/SortList.h
	touch QueryResult.h

$(INCLUDEDIR)/QueryResult.h: QueryResult.h
	cp QueryResult.h $(INCLUDEDIR)/.

$(LIBDIR)/QueryResult.o: QueryResult.o
	cp QueryResult.o $(LIBDIR)/.

QueryResult.o : QueryResult.m $(INCLUDEDIR)/querykit.h $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/ColumnBrowserCell.h



$(INCLUDEDIR)/QueryResultRow.h: QueryResultRow.h
	cp QueryResultRow.h $(INCLUDEDIR)/.

$(LIBDIR)/QueryResultRow.o: QueryResultRow.o
	cp QueryResultRow.o $(LIBDIR)/.

QueryResultRow.o : QueryResultRow.m $(INCLUDEDIR)/QueryResultRow.h



QueryString.h: $(INCLUDEDIR)/String.h
	touch QueryString.h

$(INCLUDEDIR)/QueryString.h: QueryString.h
	cp QueryString.h $(INCLUDEDIR)/.

$(LIBDIR)/QueryString.o: QueryString.o
	cp QueryString.o $(LIBDIR)/.

QueryString.o : QueryString.m $(INCLUDEDIR)/querykit.h $(INCLUDEDIR)/fieldvaluekit.h



$(INCLUDEDIR)/Query.h: Query.h
	cp Query.h $(INCLUDEDIR)/.

$(LIBDIR)/Query.o: Query.o
	cp Query.o $(LIBDIR)/.

Query.o : Query.m $(INCLUDEDIR)/querykit.h $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/debug.h



$(INCLUDEDIR)/BulkQuery.h: BulkQuery.h
	cp BulkQuery.h $(INCLUDEDIR)/.

$(LIBDIR)/BulkQuery.o: BulkQuery.o
	cp BulkQuery.o $(LIBDIR)/.

BulkQuery.o : BulkQuery.m $(INCLUDEDIR)/querykit.h $(INCLUDEDIR)/fieldvaluekit.h $(INCLUDEDIR)/debug.h

