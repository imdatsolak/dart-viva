#import <stdio.h>

#import "dart/String.h"

#import "TheApp.h"
#import "StringManager.h"
#import "DefaultsDatabase.h"
#import "LayoutItem.h"
#import "PrintRTFItem.h"

#import "LayoutManager.h"

#pragma .h #import <objc/Object.h>

@implementation LayoutManager:Object
{
	id	currentLayout;
}

- free
{
	if (currentLayout != nil) {
		currentLayout = [currentLayout free];
	} 
	return [super free];
}

- defaultLayoutFor:(const char *)what
{
	char	myKey[32];
	id	identity=nil;
	id	layout=nil;

	if (currentLayout != nil) {
		currentLayout = [currentLayout free];
	} 
	sprintf(myKey,"LayoutFor%s",what);
	identity = [[[NXApp defaultsDB] valueForKey:myKey] copy];
	if (identity != nil) {
		layout = [[LayoutItem alloc] initIdentity:identity];
		if (layout != nil) {
			currentLayout = [[[layout content] data] copy];
			[layout free];
		}
		[identity free];
	}
	if (currentLayout == nil) {
		currentLayout = [String str:[[NXApp stringMgr] stringFor:"NoLayoutChosen"]];
	}
	return currentLayout;
}

- defaultLayoutForAngebot
{
	return [self defaultLayoutFor:"AN"];
}

- defaultLayoutForAuftrag
{
	return [self defaultLayoutFor:"AU"];
}

- defaultLayoutForRechnung
{
	return [self defaultLayoutFor:"RE"];
}

- defaultLayoutForLieferschein
{
	return [self defaultLayoutFor:"LF"];
}

- defaultLayoutForBestellung
{
	return [self defaultLayoutFor:"BE"];
}

- defaultLayoutForPackzettel
{
	return [self defaultLayoutFor:"PZ"];
}

- defaultLayoutForMahnung:(int)index
{
	char	ind[30];
	sprintf(ind,"M%d",index);
	return [self defaultLayoutFor:ind];
}
@end
