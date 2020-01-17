#import "RechnungItem.h"
#import "RechnungsDocument.h"

#import "RechnungItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation RechnungItemList:MasterItemList
{
}

- itemClass
{ return [RechnungItem class]; }

- documentClass
{ return [RechnungsDocument class]; }
@end
