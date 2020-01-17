#import <dart/String.h>

#import <dart/SortList.h>

#pragma .h #import <objc/List.h>

@implementation SortList:List
{
}

- sort
{
	if( [self count] ) {
		[self heapsort];
	}
	return self;
}

- quicksort
{
	if( [self count] ) {
		[self quickSortFrom:0 to:[self count]-1];
	}
	return self;
}

- heapsort
{
	int	l, j, ir, i, n;
	id	rra;
	
	n = [self count];
	l = (n >> 1) + 1;
	ir = n;
	
	for (;;) {
		if(l > 1) {
			l--;
			rra = [self objectAt:l-1];
		} else {
			rra = [self objectAt:ir-1];
			[self replaceObjectAt:ir-1 with:[self objectAt:1-1]];
//			if(--ir == 1) {
			if(--ir <= 1) {
				[self replaceObjectAt:1-1 with:rra];
				return self;
			}
		}
		i = l;
		j = l << 1;
		while(j <= ir) {
			if(j < ir && 0 > [[self objectAt:j-1] compare:[self objectAt:j+1-1]]) j++;
			if(0 > [rra compare:[self objectAt:j-1]]) {
				[self replaceObjectAt:i-1 with:[self objectAt:j-1]];
				j += (i=j);
			}
			else j = ir + 1;
		}
		[self replaceObjectAt:i-1 with:rra];
	}
}


- swapObjectAt:(int)i withObjectAt:(int)j
{
	[self replaceObjectAt:j with:[self replaceObjectAt:i with:[self objectAt:j]]];
	return self;
}


- quickSortFrom:(int)begin to:(int)end
{
	if( begin<end ) {
		int	left=begin, right=end;
		id	pivot = [self objectAt:begin];
		while( left<right ) {
			while( 0 > [pivot compare:[self objectAt:right]] ) {
				right--;
			}
			while((left<right)&&(0<=[pivot compare:[self objectAt:left]])) {
				left++;
			}
			if( left<right ) {
				[self swapObjectAt:right withObjectAt:left];
			}
		}
		[self swapObjectAt:right withObjectAt:begin];
		[self quickSortFrom:begin to:(right-1)];
		[self quickSortFrom:(right+1) to:end];
	}
	return self;
}


@end
