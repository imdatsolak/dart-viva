#import "LayoutItem.h"
#import "LayoutDocument.h"

#import "LayoutItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation LayoutItemList:MasterItemList
{
}

- itemClass
{ return [LayoutItem class]; }

- documentClass
{ return [LayoutDocument class]; }

@end
