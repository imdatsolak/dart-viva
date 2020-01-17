#import "AuftragItem.h"
#import "AuftragsDocument.h"

#import "AuftragItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation AuftragItemList:MasterItemList
{
}

- itemClass
{ return [AuftragItem class]; }

- documentClass
{ return [AuftragsDocument class]; }
@end
