#import "BankItem.h"
#import "BankenDocument.h"

#import "BankItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation BankItemList:MasterItemList
{
}

- itemClass
{ return [BankItem class]; }

- documentClass
{ return [BankenDocument class]; }

@end
