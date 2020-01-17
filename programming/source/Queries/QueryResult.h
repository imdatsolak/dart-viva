#import "dart/SortList.h"

@interface QueryResult:SortList
{
	id	columnFormats;
	id	icon;
	int	myTag;
}

- (int)tag;
- setTag:(int)theTag;
- init;
- initCount:(unsigned)numSlots;
- free;
- copy;
- icon;
- setImage:anImage;
- (int)columnCount;
- setTitle:(const char *)title length:(int)length alignment:(int)alignment numeric:(BOOL)numeric andTag:(int)tag ofColumn:(int)column;
- setTitle:(const char *)title ofColumn:(int)column;
- updateMaxLength:(int)length ofColumn:(int)column;
- (const char *)titleOfColumn:(int)column;
- (int)lengthOfColumn:(int)column;
- (BOOL)isNumericColumn:(int)column;
- (int)alignmentOfColumn:(int)column;
- (int)tagOfColumn:(int)column;
- getTitle:(const char **)title length:(int *)length alignment:(int *)alignment numeric:(BOOL *)numeric andTag:(int *)tag ofColumn:(int)column;
- getLength:(int *)length alignment:(int *)alignment andNumeric:(BOOL *)numeric ofColumn:(int)column;
- moveToLeftColumnWithTag:(int)tag;
- sortByTag:(int)tag;
- loadCell:cell withRow:(int)row;

@end

