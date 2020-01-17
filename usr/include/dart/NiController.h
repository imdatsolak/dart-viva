#import <objc/Object.h>
#import <netinfo/ni.h>

@interface NiController:Object
{
	ni_status		status;
}

- machineNames;
- (ni_status)lastStatus;
- (const char *)lastError;

@end
