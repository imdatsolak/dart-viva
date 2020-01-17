#import <c.h>
#import <stdio.h>
#import <string.h>
#import <objc/Storage.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#import "dart/querykit.h"

typedef struct columnformat {
	id		titleString;
	int		length;
	int		alignment;
	int		tag;
	BOOL	numeric;
} COLUMNFORMAT;

@implementation QueryResult:SortList
{
	id	columnFormats;
	id	icon;
	int	myTag;
}

- (int)tag
{
	return myTag;
}


- setTag:(int)theTag
{
	myTag = theTag;
	return self;
}


- init
{
	return [self initCount:0];
}


- initCount:(unsigned)numSlots
{
	[super initCount:numSlots];
	columnFormats = [[Storage alloc] initCount:0
	                                 elementSize:sizeof(COLUMNFORMAT)
									 description:NULL];
	return self;
}


- free
{
	COLUMNFORMAT	*format;
	int				i, count = [columnFormats count];
	
	for(i=0; i<count; i++) {
		format = [columnFormats elementAt:i];
		if(format->titleString) [format->titleString free];
	}
	[columnFormats free];
	
	[self freeObjects];
	
	return [super free];
}


- copy
{
	const	char *title;
	int		i, count, length, alignment, tag;
	BOOL	numeric;
	id	theCopy;
	
	theCopy = [[[self class] alloc] initCount:[self count]];
	[theCopy setImage:icon];
	
	for(i=0, count=[self columnCount]; i<count; i++) {
		[self getTitle:&title length:&length alignment:&alignment
		      numeric:&numeric andTag:&tag ofColumn:i];
		[theCopy setTitle:title length:length alignment:alignment
		         numeric:numeric andTag:tag ofColumn:i];
	}
	
	for(i=0, count=[self count]; i<count; i++) {
		[theCopy addObject:[[self objectAt:i] copy]];
	}

	return theCopy;
}


- icon
{
	return icon;
}


- setImage:anImage
{
	icon = anImage;
	return self;
}


- (int)columnCount
{
	return [columnFormats count];
}


- setTitle:(const char *)title length:(int)length alignment:(int)alignment numeric:(BOOL)numeric andTag:(int)tag ofColumn:(int)column
{
	COLUMNFORMAT	*format;
	
	if(column >= [columnFormats count]) {
		[columnFormats setNumSlots:column+1];
	}
	
	format = [columnFormats elementAt:column];
	if(format->titleString) [format->titleString free];
	format->titleString = [String str:title];
	format->length = length;
	format->alignment = alignment;
	format->tag = tag;
	format->numeric = numeric;
		
	return self;
}

- setTitle:(const char *)title ofColumn:(int)column
{
	COLUMNFORMAT	*format;
	
	if(column >= [columnFormats count]) {
		[columnFormats setNumSlots:column+1];
	}
	
	format = [columnFormats elementAt:column];
	if(format->titleString) [format->titleString free];
	format->titleString = [String str:title];
	format->length = MAX(format->length,strlen(title))+1;
		
	return self;
}


- updateMaxLength:(int)length ofColumn:(int)column
{
	COLUMNFORMAT	*format;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
		if(format->length < length) format->length = length;
	}
	
	return self;
}


- (const char *)titleOfColumn:(int)column
{
	COLUMNFORMAT	*format;
	const char		*title;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
		title = [format->titleString str];
	} else {
		title = NULL;
	}
	
	return title;
}

- (int)lengthOfColumn:(int)column
{
	COLUMNFORMAT	*format;
	int				length;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
#if 1
		length = MAX((format->length*7500)/10000,[format->titleString length]);
#else
		length = format->length;
#endif
	} else {
		length = 0;
	}
	
	return length;
}

- (BOOL)isNumericColumn:(int)column
{
	COLUMNFORMAT	*format;
	BOOL			isNumeric;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
		isNumeric = format->numeric;
	} else {
		isNumeric = NO;
	}
	
	return isNumeric;
}

- (int)alignmentOfColumn:(int)column
{
	COLUMNFORMAT	*format;
	int				alignment;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
		alignment = format->alignment;
	} else {
		alignment = 0;
	}
	
	return alignment;
}

- (int)tagOfColumn:(int)column
{
	COLUMNFORMAT	*format;
	int				tag;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
		tag = format->tag;
	} else {
		tag = 0;
	}
	
	return tag;
}

- getTitle:(const char **)title length:(int *)length alignment:(int *)alignment numeric:(BOOL *)numeric andTag:(int *)tag ofColumn:(int)column
{
	COLUMNFORMAT	*format;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
#if 1
		*length = MAX((format->length*7500)/10000,[format->titleString length]);
#else
		*length = format->length;
#endif

		*title = [format->titleString str];
		*alignment = format->alignment;
		*tag = format->tag;
		*numeric = format->numeric;
	} else {
		*title = NULL;
		*length = 0;
		*alignment = 0;
		*tag = 0;
		*numeric = NO;
	}

	return self;
}


- getLength:(int *)length alignment:(int *)alignment andNumeric:(BOOL *)numeric ofColumn:(int)column
{
	COLUMNFORMAT	*format;
	
	if(column < [columnFormats count]) {
		format = [columnFormats elementAt:column];
#if 1
		*length = MAX((format->length*7500)/10000,[format->titleString length]);
#else
		*length = format->length;
#endif
		*alignment = format->alignment;
		*numeric = format->numeric;
	} else {
		*length = 0;
		*alignment = 0;
		*numeric = NO;
	}
	
	return self;
}


- moveToLeftColumnWithTag:(int)tag
{
	int i=0,done=0,count=[columnFormats count];
	
	while( !done && (i<count) ) {
		if( tag == ((COLUMNFORMAT *)[columnFormats elementAt:i])->tag ) {
			COLUMNFORMAT	d = *((COLUMNFORMAT *)[columnFormats elementAt:i]);
			[columnFormats removeAt:i];
			[columnFormats insert:&d at:0];
			done = 1;
		} else {
			i++;
		}
	}

	return [self makeObjectsPerform:@selector(moveToLeftColumnWithTag:) with:(id)tag];
}


- sortByTag:(int)tag
{
	[self moveToLeftColumnWithTag:tag];
	[self sort];
	return self;
}

- loadCell:cell withRow:(int)row
{
	if(row < [self count]) {
		id	anObj = [self objectAt:row];
		int	i, count = [anObj count];
	
		[cell setColumnCount:count];
		for(i=0; i<count; i++) {
			int		length, alignment;
			BOOL	numeric;
			[self getLength:&length alignment:&alignment andNumeric:&numeric ofColumn:i];
			[cell setLength:length alignment:alignment andNumeric:numeric ofColumn:i];
			[[anObj objectAt:i] writeIntoCell:cell inColumn:i];
		}
		[cell setLoaded:YES];
	}
	return self;
}



@end

