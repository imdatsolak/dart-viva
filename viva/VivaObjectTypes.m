#import <objc/Object.h>
#define VIVA_EXPORTOBJECT	0x0001
#define VIVA_TOOLOBJECT		0x0002
#define VIVA_QUERYOBJECT	0x0004
#define VIVA_NEEDEDOBJECT	0x1000

@interface Object(Exporter)
+ (int)vivaObjectType;
+ (const char *)publicname;
+ (const char *)copyright;
+ (BOOL)canWriteTitles;
- init;
- setNumRows:(int)rows;
- setNumColumns:(int)columns;
- (BOOL)wantsAllRowsAtOnce;
- writeRow:theRow intoStream:(NXStream *)exportStream;
- writeAll:aListOfLists intoStream:(NXStream *)exportStream withTimer:aTimer exportFieldNames:(BOOL)flag;

@end


@interface Object(VivaCommands)
- localizer;
- loadLocalNib:(const char *)nibName owner:anOwner;
@end
