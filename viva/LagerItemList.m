#import "LagerItem.h"
#import "LagerDocument.h"

#import "LagerItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation LagerItemList:MasterItemList
{
}


- itemClass
{ return [LagerItem class]; }

- documentClass
{ return [LagerDocument class]; }
@end
