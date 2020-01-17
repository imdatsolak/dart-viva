#import "AngebotItem.h"
#import "AngebotsDocument.h"

#import "AngebotItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation AngebotItemList:MasterItemList
{
}

- itemClass
{ return [AngebotItem class]; }

- documentClass
{ return [AngebotsDocument class]; }
@end
