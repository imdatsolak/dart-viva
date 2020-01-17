#import <dart/dartlib.h>
#import <dpsclient/psops.h>
#import <appkit/nextstd.h>
#import <appkit/graphics.h>
#import <appkit/publicWraps.h>
#import <appkit/Application.h>
#import <appkit/Font.h>
#import <appkit/Text.h>
#import <objc/NXStringTable.h>

#import <math.h>
#import <stdlib.h>
#import <strings.h>

#import "dart/BrowserRow.h"

#pragma .h #import <sys/param.h>
#pragma .h #import <objc/Object.h>
#pragma .h 
#pragma .h struct ColumnFormat {
#pragma .h 		float	width;
#pragma .h 		int		alignment;
#pragma .h 		char	*content;
#pragma .h };
	
@implementation BrowserRow:Object
{
	int					cellTag, columns;
	struct ColumnFormat	*colFormat;
	float				numWidth;
	float				nonnumWidth;
	float				distance;
	NXCoord				lineHeight;
	NXCoord				ascender;
	NXCoord				descender;
}

- init
{
	[super init];
	colFormat = NULL;
	return self;
}


- freeColFormat
{
	if ( colFormat ) {
		int	i;
		for(i=0; i<columns; i++ ) {
			if( colFormat[i].content ) free(colFormat[i].content);
		}
		free(colFormat);
		colFormat = NULL;
	}

	return self;
}


- free
{
	[self freeColFormat];
	return [super free];
}

- setFont:fontObj
{
	NXTextFontInfo(fontObj, &ascender, &descender, &lineHeight);
	
#if 1
	numWidth = [fontObj getWidthOf:"m"];
	nonnumWidth = [fontObj getWidthOf:"m"];
	distance = nonnumWidth;
#else
	numWidth = [fontObj getWidthOf:"0"] * 1.05;
	nonnumWidth = [fontObj getWidthOf:"m"] * 0.666;
	distance = nonnumWidth*1.5;
#endif
	
	return self;
}    

- (NXCoord)lineHeight
{ return lineHeight; }

- (NXCoord)descender
{ return descender; }

- (NXCoord)ascender
{ return ascender; }

- (NXCoord)distance
{ return distance; }

- setDistance:(NXCoord)aDistance
{ distance = aDistance; return self; }

- setColumnCount:(int)columnCount
{
	int	i;

	[self freeColFormat];
	columns = columnCount;
	colFormat = malloc((columns+1) * sizeof(struct ColumnFormat));
	for(i=0; i<columns; i++ ) {
		colFormat[i] = (struct ColumnFormat){0.0,NO,NULL};
	}
	
	return self;
}

- (int)columnCount
{ return columns; }

- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column
{
	if( colFormat && (column < columns) ) {
		colFormat[column].width = len*(numeric?numWidth:nonnumWidth);
		colFormat[column].alignment = alignment;
		[self setStringValue:str ofColumn:column];
	}
	return self;
}


- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column
{
	if( colFormat && (column < columns) ) {
		colFormat[column].width = len*(numeric?numWidth:nonnumWidth);
		colFormat[column].alignment = alignment;
	}
	return self;
}

- (int)alignmentOfColumn:(int)column
{
	if( column < columns ) {
		return colFormat[column].alignment;
	} else {
		return -1;
	}
}

- (float)widthOfColumn:(int)column
{
	float	width = 0.0;
	if( column < columns ) {
		width = colFormat[column].width  + distance;
	}
	return width;
}


- (float)width
{
	int		i;
	float	width = [self offsetOfFirstColumn];
	
	for(i=0; i<columns; i++) {
		width += [self widthOfColumn:i];
	}
	
	return width;
}


- (float)offsetOfFirstColumn
{
	return 6.0 + lineHeight;
}


- setStringValue:(const char *)string ofColumn:(int)column
{
	if( string ) {
		if( colFormat[column].content ) free(colFormat[column].content);
		colFormat[column].content = malloc(strlen(string)+1);
		strcpy(colFormat[column].content,string);
	}
	return self;
}

- (const char *)contentOfColumn:(int)column
{
	if (column < columns) {
		return colFormat[column].content;	
	} else {
		return "NULL";
	}
}

- setDoubleValue:(double)d ofColumn:(int)column
{
	char	string[1000];
	sprintf(string,"%.2lf",d);
	[self setStringValue:string ofColumn:column];
	return self;
}


- setIntValue:(int)i ofColumn:(int)column
{
	char	string[1000];
	
	sprintf(string,"%d",i);
	[self setStringValue:string ofColumn:column];
	return self;
}

- copy
{
	id	newObject = [super copy];
	int	i;
	struct ColumnFormat	*newColFormat = malloc((columns+1) * sizeof(struct ColumnFormat));

	for(i=0; i<columns; i++ ) {
		newColFormat[i].content = malloc(strlen(colFormat[i].content)+1);
		strcpy(newColFormat[i].content, colFormat[i].content);
		newColFormat[i].width = colFormat[i].width;
		newColFormat[i].alignment = colFormat[i].alignment;
	}
	colFormat = newColFormat;
	return newObject;
}
	
@end
