#import <appkit/View.h>

#import "dart/fieldvaluekit.h"

#import "MasterInspector.h"

@implementation MasterInspector
- init
{
	[super init];
	title = [String str:"<Unknown>"];
	oldSuperview = nil;
	return self;
}

- free
{
	if (title) {
		[title free];
	}
	return [super free];
}

- showInWindow:aWindow
{
	if (!oldSuperview) {
		oldSuperview = [cView superview];
		[cView removeFromSuperview];
		[[aWindow contentView] addSubview:cView];
	}
	return self;
}

- removeFromWindow:aWindow
{
	if (oldSuperview) {
		[cView removeFromSuperview];
		[oldSuperview addSubview:cView];
		oldSuperview = nil;
	}
	return self;
}	
	
- inspectorTitle
{
	return title;
}
	
- owner
{
	return owner;
}

- setOwner:anObject
{
	owner = anObject;
	return self;
}

@end
