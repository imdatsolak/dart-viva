#import <sys/param.h>
#import <appkit/NXBrowserCell.h>

@interface ColumnBrowserCell:NXBrowserCell
{
	id		theCell;
	id		rowFormats;
	int		state;
	int		cellTag;
	float	backgroundgray;
	float	oneLineHeight;
	char	iconName[MAXPATHLEN];
}

- initTextCell:(const char *)aString;
- free;
- setFont:fontObj;
- (int)tag;
- setTag:(int)anInt;
- calcCellSize:(NXSize *)theSize inRect:(const NXRect *)aRect;
- drawInside:(const NXRect *)cellFrame inView:controlView;
- setRowCount:(int)rowCount;
- setColumnCount:(int)columnCount;
- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column;
- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column;
- setColumnCount:(int)columnCount inRow:(int)theRow;
- (int)columnCountInRow:(int)theRow;
- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column andRow:(int)theRow;
- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column andRow:(int)theRow;
- setStringValue:(const char *)string ofColumn:(int)column;
- setDoubleValue:(double)d ofColumn:(int)column;
- setIntValue:(int)i ofColumn:(int)column;
- setStringValue:(const char *)string ofColumn:(int)column andRow:(int)aRow;
- setDoubleValue:(double)d ofColumn:(int)column andRow:(int)aRow;
- setIntValue:(int)i ofColumn:(int)column andRow:(int)aRow;
- setBackgroundgray:(float)gray;
- setIcon:(const char *)icon;
- (const char *)icon;
- setMyState:(int)aState;
- (int)myState;
- setSelected:(BOOL )flag;
- (float)widthOfColumn:(int)column;
- (float)width;
- (float)offsetOfFirstColumn;
- (float)widthOfColumn:(int)column inRow:(int)theRow;
- (float)widthOfRow:(int)theRow;
- (float)offsetOfFirstColumnInRow:(int)theRow;
- copy;
- (int)compareFirstCharacter:(char )aChar;
- setDistance:(NXCoord)aDistance;

@end

