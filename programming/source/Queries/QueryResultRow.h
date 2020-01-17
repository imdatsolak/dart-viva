#import <objc/List.h>

@interface QueryResultRow:List
{
	id	icon;
	int	tag;
}

+ new;
- (const char *)publicClassName;
- (int)tag;
- setTag:(int)aTag;
- init;
- copy;
- free;
- icon;
- setImage:anImage;
- objectWithTag:(int)aTag;
- replaceObjectWithTag:(int)aTag with:theNewObject;
- (int)compare:anotherObject byTag:(int)aTag;
- (int)compare:anotherObject byIndex:(int)i;
- (int)compare:anotherObject;
- moveToLeftColumnWithTag:(int)aTag;

@end
