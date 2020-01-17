#import <objc/List.h>
#import <appkit/PopUpList.h>

#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "NilInspector.h"

#import "InspectorManager.h"

@implementation InspectorManager
- init
{
	[super init];
	[NXApp loadNibFile:"MasterInspector.nib" owner:self];
	inspectorList = [[List alloc] init];
	nilInspector = [[NilInspector alloc] init];
	return self;
}

- free
{
	inspectorList = [inspectorList free];
	return [super free];
}

- addInspector:anInspector
{
	[inspectorPopup addItem:[[anInspector inspectorTitle] str]];
	[inspectorList addObject:anInspector];
	return self;
}

- removeInspector:anInspector
{
	[inspectorPopup removeItem:[[anInspector inspectorTitle] str]];
	[inspectorList removeObject:anInspector];
	return self;
}

- selectInspector:sender
{
	int		i = 0, count = [inspectorList count];
	BOOL 	found=NO;
	id	theNewInspector = nil;
	
	[showingInspector removeFromWindow:window];
	while (i<count) {
		theNewInspector = [inspectorList objectAt:i];
		found = ([[theNewInspector inspectorTitle] compareSTR:[sender title]] == 0);
		i++;
	}
	if (found) {
		showingInspector = theNewInspector;
		[theNewInspector showInWindow:window];
	} else {
		[nilInspector showInWindow:window];
		showingInspector = nilInspector;
	}
	return self;
}

- hide:sender
{ 
	[window orderOut:self];
	return self;
}

- show:sender
{
	[window makeKeyAndOrderFront:self];
	return self;
}

- setOwner:anObject
{
	owner = anObject;
	return self;
}

- owner
{
	return owner;
}
@end
