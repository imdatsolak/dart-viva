#import <sys/param.h>
#import <appkit/NXBrowserCell.h>

struct ColumnFormat {
		float	width;
		int		alignment;
		char	*content;
	};
	
@interface ColumnBrowserCell:NXBrowserCell
{
	int					cellTag, columns;
	struct ColumnFormat	*colFormat;
	float				numWidth;
	float				nonnumWidth;
	float				distance;
	float				backgroundgray;
	NXCoord				ascender;
	NXCoord				descender;
	NXCoord				lineHeight;
	int					state;
	id					theCell;
	char				iconName[MAXPATHLEN];
}

- init;
- freeColFormat;
- free;
- setFont:fontObj;
- (int)tag;
- setTag:(int)anInt;
- drawInside:(const NXRect *)cellFrame inView:controlView;
- setColumnCount:(int)columnCount;
- setLength:(int)len alignment:(int)alignment numeric:(BOOL)numeric andStringValue:(const char *)str ofColumn:(int)column;
- setLength:(int)len alignment:(int)alignment andNumeric:(BOOL)numeric ofColumn:(int)column;
- (float)widthOfColumn:(int)column;
- (float)width;
- (float)offsetOfFirstColumn;
- setStringValue:(const char *)string ofColumn:(int)column;
- setDoubleValue:(double)d ofColumn:(int)column;
- setIntValue:(int)i ofColumn:(int)column;
- setBackgroundgray:(float)gray;
- setIcon:(const char *)icon;
- (const char *)icon;
- setMyState:(int)aState;
- (int)myState;
- setSelected:(BOOL )flag;

@end
