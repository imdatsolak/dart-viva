#import <sys/param.h>
#import <math.h>
#import <stdlib.h>
#import <strings.h>

#import <appkit/Application.h>
#import <appkit/Font.h>
#import <appkit/Text.h>
#import <appkit/graphics.h>
#import <appkit/nextstd.h>
#import <appkit/publicWraps.h>
#import <dpsclient/psops.h>
#import <objc/List.h>

#import "dart/dartlib.h"
#import "dart/BrowserRow.h"

#import "ColumnBrowserCell.h"

#pragma .h #import <sys/param.h>
#pragma .h #import <appkit/NXBrowserCell.h>

@implementation ColumnBrowserCell:NXBrowserCell
{
	id		theCell;
	id		rowFormats;
	int		state;
	int		cellTag;
	float	backgroundgray;
	float	oneLineHeight;
	char	iconName[MAXPATHLEN];
}


- initTextCell:(const char *)aString
{
	[self setLeaf:YES];
	backgroundgray = NX_LTGRAY;
	sprintf(iconName,"");
	theCell = nil;
	rowFormats = [[List alloc] initCount:0];
	[rowFormats addObject:[[BrowserRow alloc] init]];
	return self;
}


- free
{
	[[rowFormats freeObjects] free];
	if (theCell)
		[theCell free];
	return [super free];
}

- setFont:fontObj
{
	[super setFont:fontObj];
	[rowFormats makeObjectsPerform:@selector(setFont:) with:fontObj];	
	return self;
}    

- (int)tag
{
	return cellTag;
}

- setTag:(int)anInt
{
	cellTag = anInt;
	return self;
}

- calcCellSize:(NXSize *)theSize inRect:(const NXRect *)aRect
{
	[super calcCellSize:theSize inRect:aRect];
	theSize->width = [self width];
	oneLineHeight = theSize->height;
	theSize->height *= (float )[rowFormats count];
	return self;
}

- drawInside:(const NXRect *)cellFrame inView:controlView
{
	char		tmpBuffer[1024];
	id			theFontAsker;
	float		cellHeight;
	NXRect		theRect;
	NXSize		theSize;
	float		offset;
	int			rows, countRows = [rowFormats count];
	
	cellHeight = NX_Y(cellFrame) + [[rowFormats objectAt:0] lineHeight] - [[rowFormats objectAt:0] descender];
	if( theCell == NULL ) {
 		theCell = [Cell new];
	}
	theRect.origin = cellFrame->origin;
	theRect.origin.x += 2;
	theRect.size.width = theRect.size.height = cellFrame->size.height;
	[theCell calcCellSize:&theSize inRect:&theRect];
	
	[super drawInside:cellFrame inView:controlView];

	/* set the font according to our drawing status */
	theFontAsker = [support set];

	/* erase the cell */
	if( cFlags1.state || cFlags1.highlighted ) {
		PSsetgray( NX_WHITE );
	} else {
		PSsetgray(backgroundgray);
	}
	if (strlen(iconName)==0) {
		NXRectFill( cellFrame );
	} else {
		NXRect newFrame = *cellFrame;
		newFrame.origin.x += cellFrame->size.height;
		NXRectFill(&newFrame);
	}
	
	/* draw the text */
	PSsetgray((state==0)? NX_BLACK:NX_DKGRAY);
	for (rows=0;rows<countRows;rows++) {
		id		theRow = [rowFormats objectAt:rows];
		float 	xPos = [self offsetOfFirstColumnInRow:rows];
		int		cnt, columnCount = [self columnCountInRow:rows];
		for(cnt=0; cnt<columnCount; cnt++ ) {
			
			if([theRow contentOfColumn:cnt]) {
				strncpy0(tmpBuffer,[theRow contentOfColumn:cnt],sizeof(tmpBuffer));
			} else {
				tmpBuffer[0] = (char)0;
			}
			if (strstr(tmpBuffer,"\n")!=0) {
				strstr(tmpBuffer,"\n")[0] = 0; 
			}
			if ((cnt<(columnCount-1))) {
				while ((strlen(tmpBuffer)>1) && ([theFontAsker getWidthOf:tmpBuffer]>=[theRow widthOfColumn:cnt])) {
					tmpBuffer[strlen(tmpBuffer)-2] = '¼';
					tmpBuffer[strlen(tmpBuffer)-1] = 0;
				}
			}
		
			switch ([theRow alignmentOfColumn:cnt]) {
				case NX_RIGHTALIGNED:
					offset = ([theRow widthOfColumn:cnt] -[theRow distance])- [theFontAsker getWidthOf:tmpBuffer];
					break;
				case NX_CENTERED:
					offset = (([theRow widthOfColumn:cnt] -[theRow distance]) - 
							   [theFontAsker getWidthOf:tmpBuffer]) / 2;
					break;
				case NX_LEFTALIGNED:
				default:
					offset = 0.0;
					break;
			}
		
			PSmoveto(xPos+offset, cellHeight-((rows * oneLineHeight)+2));
			PSshow(tmpBuffer);
			xPos += [theRow widthOfColumn:cnt];
		}
	}
	/* all drawing from now on will be in dark gray */
	PSsetgray(NX_DKGRAY);
	
	if (strlen(self->iconName)) {
		[theCell setIcon:self->iconName];
		[theCell drawSelf:&theRect inView:controlView];
	}
	return self;
}

- setRowCount:(int)rowCount
{
	int	i;
	[[rowFormats freeObjects] empty];
	for (i=0;i<rowCount;i++) {
		[rowFormats addObject:[[[BrowserRow alloc] init] setFont:[self font]]];
	}
	return self;
}

- setColumnCount:(int)columnCount
{
	return [self setColumnCount:columnCount inRow:0];
}

- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column
{
	return [self setLength:len alignment:alignment numeric:numeric andStringValue:str ofColumn:column andRow:0];
}

- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column
{
	return [self setLength:len alignment:alignment andNumeric:numeric ofColumn:column andRow:0];
}

- setColumnCount:(int)columnCount inRow:(int)theRow
{
	[[rowFormats objectAt:theRow] setColumnCount:columnCount];
	return self;
}

- (int)columnCountInRow:(int)theRow
{
	return [[rowFormats objectAt:theRow] columnCount];
}

- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column andRow:(int)theRow
{
	[[rowFormats objectAt:theRow] setLength:len alignment:alignment numeric:numeric andStringValue:str ofColumn:column];
	return self;
}

- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column andRow:(int)theRow
{
	[[rowFormats objectAt:theRow] setLength:len alignment:alignment andNumeric:numeric ofColumn:column];
	return self;
}

- setStringValue:(const char *)string ofColumn:(int)column
{
	[self setStringValue:string ofColumn:column andRow:0];
	return self;
}

- setDoubleValue:(double)d ofColumn:(int)column
{
	[self setDoubleValue:d ofColumn:column andRow:0];
	return self;
}

- setIntValue:(int)i ofColumn:(int)column
{
	[self setIntValue:i ofColumn:column andRow:0];
	return self;
}

- setStringValue:(const char *)string ofColumn:(int)column andRow:(int)aRow
{
	[[rowFormats objectAt:aRow] setStringValue:string ofColumn:column];
	return self;
}

- setDoubleValue:(double)d ofColumn:(int)column andRow:(int)aRow
{
	[[rowFormats objectAt:aRow] setDoubleValue:d ofColumn:column];
	return self;
}

- setIntValue:(int)i ofColumn:(int)column andRow:(int)aRow
{
	[[rowFormats objectAt:aRow] setIntValue:i ofColumn:column];
	return self;
}

- setBackgroundgray:(float)gray
{
	backgroundgray = gray;
	return self;
}

- setIcon:(const char *)icon
{
	strcpy(self->iconName,icon);
	return self;
}

- (const char *)icon
{
	return self->iconName;
}


- setMyState:(int)aState
{
	state = aState;
	return self;
}


- (int)myState
{
	return state;
}


- setSelected:(BOOL )flag
{
	cFlags1.state = flag;
	cFlags1.highlighted = flag;
	return self;
}


- (float)widthOfColumn:(int)column
{
	return [self widthOfColumn:column inRow:0];
}

- (float)width
{
	return [self widthOfRow:0];
}

- (float)offsetOfFirstColumn
{
	return [self offsetOfFirstColumnInRow:0];
}

- (float)widthOfColumn:(int)column inRow:(int)theRow
{
	return [[rowFormats objectAt:theRow] widthOfColumn:column];
}

- (float)widthOfRow:(int)theRow
{
	return [[rowFormats objectAt:theRow] width];
}

- (float)offsetOfFirstColumnInRow:(int)theRow
{
	return [[rowFormats objectAt:theRow] offsetOfFirstColumn];
}

- copy
{
	id	newObject = [super copy];
	id	newList = [[List alloc] initCount:0];
	int	i, count = [self->rowFormats count];
	
	for (i=0;i<count;i++) {
		[newList addObject:[[rowFormats objectAt:i] copy]];
	}
	
	rowFormats = newList;
	return newObject;	
}

- (int)compareFirstCharacter:(char )aChar
{
	char	firstChar = [[rowFormats objectAt:0] contentOfColumn:0][0];
	if (aChar >= 'a' && aChar <= 'z') aChar -= 32;
	if (firstChar >= 'a' && firstChar <= 'z') firstChar -= 32;
	if (aChar < firstChar) return -1;
	if (aChar > firstChar) return 1;
	return 0;
}

- setDistance:(NXCoord)aDistance
{ 
	int i, count = [rowFormats count];
	for (i=0;i<count;i++) {
		[[rowFormats objectAt:i] setDistance:aDistance];
	}
	return self; 
}

@end
