#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"

#import "DefaultsDatabase.h"
#import "TheApp.h"

#import "VivaPrefs.h"

#pragma .h #import "MasterPrefs.h"

@implementation VivaPrefs:MasterPrefs
{
	id	showDialogSwitch;
	id	deleteWarningSwitch;
	id	mwstField;
}

- init
{
	[super init];
	[self reloadPrefs:self];
	return self;
}

- reloadPrefs:sender
{
	id	value;
	if ((value = [[NXApp defaultsDB] valueForKey:"showDialogsInsteadBeep"]) != nil) {
		[showDialogSwitch setState:[value int]? 1:0];
	}
	if ((value = [[NXApp defaultsDB] valueForKey:"alwaysWarnDeletes"]) != nil) {
		[deleteWarningSwitch setState:[value int]? 1:0];
	}
	if ((value = [[NXApp defaultsDB] valueForKey:"defaultMwSt"]) != nil) {
		[value writeIntoCell:mwstField];
	}
	return self;
}

- savePrefs:sender
{
	if (needsSaving) {
		id	value = [Integer int:0];
		[value setInt:[showDialogSwitch state]];
		[[NXApp defaultsDB] setValue:value forKey:"showDialogsInsteadBeep"];
		
		[value setInt:[deleteWarningSwitch state]];
		[[NXApp defaultsDB] setValue:value forKey:"alwaysWarnDeletes"];
		
		[value free];
		value = [Double double:0.0];
		[value readFromCell:mwstField];
		[[NXApp defaultsDB] setValue:value forKey:"defaultMwSt"];
		[value free];
		[super savePrefs:sender];
	}
	return self;
}
@end
