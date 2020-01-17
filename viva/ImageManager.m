#import <objc/List.h>
#import <appkit/NXImage.h>

#import "dart/Localizer.h"

#import "TheApp.h"

#import "ImageManager.h"

#pragma .h #import <objc/Object.h>

@implementation ImageManager:Object
{
	id	unknownIcon;
	id	iconList;
}

- init
{
	[super init];
	unknownIcon = [NXImage findImageNamed:"UnknownIcon"];
	iconList = [[List alloc] initCount:0];
	return self;
}

- unknownIcon
{
	return unknownIcon;
}


- iconFor:(const char *)name
{
	id		theIcon = nil;
	
	theIcon = [NXImage findImageNamed:name];
	if(theIcon == nil) {
		theIcon = [[NXApp localizer] loadLocalImage:name];
		if(theIcon == nil) {
			theIcon = [self unknownIcon];
		} else {
			[theIcon setName:name];
			[iconList addObject:theIcon];
		}
	}
	return theIcon;
}


- free
{
	[unknownIcon free];
	[[iconList freeObjects] free];
	return [super free];
}

@end
