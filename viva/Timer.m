#import <appkit/Application.h>

#import "dart/TimerView.h"
#import "dart/Localizer.h"

#import "TheApp.h"
#import "Timer.h"

#pragma .h #import <objc/Object.h>

@implementation Timer:Object
{
    id	timerTitle;
    id	timer;
}


- initTitle:(const char *)aTitle
{
	[super init];
	[[[TimerView alloc] init] free];
	[[NXApp localizer] loadLocalNib:"Timer" owner:self];
	[timerTitle setStringValue:aTitle];
	[timer reset];
	return self;
}

- showTimer:sender
{
	[[timer window] makeKeyAndOrderFront:self];
	return self;
}

- hideTimer:sender
{
	[[timer window] orderOut:self];
	return self;
}

- updateTimer:(double )percentage
{
	[timer setDoubleValue:[timer doubleValue] + percentage];
	return self;
}

- free
{
	[[timer window] orderOut:self];
	return [super free];
}
@end
