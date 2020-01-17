#import "LieferscheinItem.h"
#import "LieferscheinDocument.h"

#import "LieferscheinItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation LieferscheinItemList:MasterItemList
{
}

- itemClass
{ return [LieferscheinItem class]; }

- documentClass
{ return [LieferscheinDocument class]; }
@end
