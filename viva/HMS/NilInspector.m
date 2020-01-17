#import "dart/String.h"
#import "NilInspector.h"

@implementation NilInspector

- init
{
	[super init];
	title = [String str:"<NIL>"];
	return self;
}

- free
{
	[title free];
	return [super free];
}

@end
