#import <objc/List.h>
#import <appkit/Window.h>
#import <appkit/TextField.h>
#import <appkit/Button.h>
#import <appkit/PopUpList.h>
#import <appkit/Matrix.h>

#import "dart/fieldvaluekit.h"

#import "DefaultsDatabase.h"
#import "StringManager.h"
#import "VivaObjectTypes.m"
#import "TheApp.h"

#import "ExportPrefs.h"

#pragma .h #import "MasterPrefs.h"

#define EXWRITENOW_TAG		1000
#define EXFRAME_TAG			2000
#define EXWORDPERFECT_TAG	3000
#define EXFREE_TAG			5000

@implementation ExportPrefs:MasterPrefs
{
	id	exportFormatButton;
	id	colDelimiterField;
	id	rowDelimiterField;
	id	exportNamesSwitch;
	id	copyrightField;
}

- init
{
	id	loadedClasses;
	[super init];
	loadedClasses = [NXApp getExportObjects];
	if ((loadedClasses != nil) && ([loadedClasses count]>0)) {
		int 		i, count = [loadedClasses count];
		const char 	*aName;
		id			popup = [exportFormatButton target];
		for (i=0;i<count;i++) {
			aName = [[loadedClasses objectAt:i] publicname];
				[[[[popup addItem:aName]
					setTarget:self] 
					setAction:@selector(exportFormatClicked:)]
					setTag:9999];
		}
	}
	[self reloadPrefs:self];
	return self;
}


- reloadPrefs:sender
{
	id	value;
	if ((value = [[NXApp defaultsDB] valueForKey:"exportFormat"]) != nil) {
		[exportFormatButton setTitle:[value str]];
	}
	if ((value = [[NXApp defaultsDB] valueForKey:"exportColDelimiter"]) != nil) {
		[colDelimiterField setStringValue:[value str]];
	}
	if ((value = [[NXApp defaultsDB] valueForKey:"exportRowDelimiter"]) != nil) {
		[rowDelimiterField setStringValue:[value str]];
	}
	if ((value = [[NXApp defaultsDB] valueForKey:"exportExportNames"]) != nil) {
		[exportNamesSwitch setState:[value int]? 1:0];
	}
	[exportFormatButton performClick:self];
	return self;
}

- savePrefs:sender
{
	if (needsSaving) {
		id	value = [Integer int:0];
		id	value1;
		
		[value setInt:[exportNamesSwitch state]];
		[[NXApp defaultsDB] setValue:value forKey:"exportExportNames"];
		[value free];
		
		value = [String str:""];
		value1 = [String str:""];
		[value str:[exportFormatButton title]];
		[[NXApp defaultsDB] setValue:value forKey:"exportFormat"];
		
		switch ([[[[exportFormatButton target] itemList] selectedCell] tag]) {
			case EXWRITENOW_TAG: [value str:","]; [value1 str:"^J"]; break;
			case EXWORDPERFECT_TAG:
			case EXFRAME_TAG:	 [value str:";"]; [value1 str:"^J"]; break;
			case EXFREE_TAG:	
					[value str:[colDelimiterField stringValue]];
					[value str:[rowDelimiterField stringValue]];
					break;
			default:
					[value str:""]; [value1 str:""]; break;
		}
		[[NXApp defaultsDB] setValue:value forKey:"exportColDelimiter"];
		[[NXApp defaultsDB] setValue:value1 forKey:"exportRowDelimiter"];
		[value free];
		[value1 free];
		[super savePrefs:sender];
	}
	return self;
}

- exportFormatClicked:sender
{
	BOOL	freeEx = [[[[exportFormatButton target] itemList] selectedCell] tag] == EXFREE_TAG;
	if ([[[[exportFormatButton target] itemList] selectedCell] tag]==9999) {
		const char *title = [[exportFormatButton target] selectedItem];
		if (title != NULL) {
			id currExpClass = [NXApp classForString:title];
			[exportNamesSwitch setEnabled:[currExpClass canWriteTitles]];
			[copyrightField setStringValue:[currExpClass copyright]];
		}
	} else {
		[copyrightField setStringValue:[[NXApp stringMgr] stringFor:"DefaultCopyright"]];
		[exportNamesSwitch setEnabled:YES];
	}
	[[colDelimiterField setEditable:freeEx] setBackgroundGray:freeEx? NX_WHITE:NX_LTGRAY];
	[[rowDelimiterField setEditable:freeEx] setBackgroundGray:freeEx? NX_WHITE:NX_LTGRAY];
	[[prefsWindow firstResponder] resignFirstResponder];
	[self controlDidChange:sender];
	return self;
}
@end
