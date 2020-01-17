#import "BestellungItem.h"
#import "BestellungsDocument.h"

#import "BestellungItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation BestellungItemList:MasterItemList
{
}

- itemClass
{ return [BestellungItem class]; }

- documentClass
{ return [BestellungsDocument class]; }
@end
