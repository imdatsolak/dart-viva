#import <sys/param.h>
#import <objc/Object.h>

struct ColumnFormat {
float	width;
int		alignment;
char	*content;
};

@interface BrowserRow:Object
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

- init;
- freeColFormat;
- free;
- setFont:fontObj;
- (NXCoord)lineHeight;
- (NXCoord)descender;
- (NXCoord)ascender;
- (NXCoord)distance;
- setDistance:(NXCoord)aDistance;
- setColumnCount:(int)columnCount;
- (int)columnCount;
- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column;
- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column;
- (int)alignmentOfColumn:(int)column;
- (float)widthOfColumn:(int)column;
- (float)width;
- (float)offsetOfFirstColumn;
- setStringValue:(const char *)string ofColumn:(int)column;
- (const char *)contentOfColumn:(int)column;
- setDoubleValue:(double)d ofColumn:(int)column;
- setIntValue:(int)i ofColumn:(int)column;
- copy;

@end

