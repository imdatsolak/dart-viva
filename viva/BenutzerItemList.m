#import "BenutzerItem.h"
#import "BenutzerDocument.h"

#import "BenutzerItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation BenutzerItemList:MasterItemList
{
}

- itemClass
{ return [BenutzerItem class]; }

- documentClass
{ return [BenutzerDocument class]; }

@end
