#import "KundeItem.h"
#import "KundenDocument.h"

#import "KundeItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation KundeItemList:MasterItemList
{
}

- itemClass
{ return [KundeItem class]; }

- documentClass
{ return [KundenDocument class]; }
@end
