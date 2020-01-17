#import <objc/List.h>

@interface SortList:List
{
}

- sort;
- swapObjectAt:(int)i withObjectAt:(int)j;
- quickSortFrom:(int)begin to:(int)end;

@end
