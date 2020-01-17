#import "KonditionenItem.h"
#import "KonditionenDocument.h"

#import "KonditionenItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation KonditionenItemList:MasterItemList
{
}

- itemClass
{ return [KonditionenItem class]; }

- documentClass
{ return [KonditionenDocument class]; }

@end
