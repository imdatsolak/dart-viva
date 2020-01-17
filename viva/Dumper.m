#import <stdlib.h>
#import <strings.h>
#import <stdio.h>
#import <ctype.h>
#import <time.h>
#import <sys/param.h>
#import <sys/file.h>
#import <sys/fcntl.h>
#import <sys/vnode.h>
#import <libc.h>
#import <appkit/SavePanel.h>
#import <appkit/OpenPanel.h>
#import <appkit/Button.h>
#import <appkit/Text.h>
#import <appkit/NXBrowser.h>
#import <appkit/publicWraps.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/Localizer.h"

#import "TheApp.h" 
#import "ErrorManager.h"

#import "Dumper.h"

#pragma .h #import "MasterDocument.h"

@implementation Dumper:MasterDocument
{
	id	dumpsBrowser;
	id	lDumpDateField;
	id	lDumpNameField;
	id	dumpWaitPanel;
	id	restoreWaitPanel;
	id	dumpButton;
	id	restoreButton;
	id	lastdumps;
	id	selectedDump;
}

+ canHaveMultipleInstances { return NO; }

- init
{
	NXRect	aFrame;
	[super init];
	selectedDump = [String str:"~/Unknown"];
	[dumpsBrowser setCellClass:[ColumnBrowserCell class]];
	[dumpsBrowser setDelegate:self];
	[[dumpsBrowser setTarget:self] setAction:@selector(browserClicked:)];
	[[window contentView] getFrame:&aFrame];
	maxSize.width = aFrame.size.width * 1.5;
	maxSize.height = 832;
	minSize.width = aFrame.size.width;
	minSize.height = aFrame.size.height;
	return self;
}

- free
{
	[lastdumps free];
	[selectedDump free];
	return [super free];
}

- makeActive:sender
{
	id	result;
	id	queryString = [QueryString str:"select dateofdump,filename from vivadumps"];
	
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
	} else {
		lastdumps = result;
	}
	[dumpsBrowser loadColumnZero];
	[window makeKeyAndOrderFront:self];
	iamNew = YES;
	return self;
}


- dump:sender
{
	id		theID;
	id		today;
	id		theFileName;
		
	theID = [SavePanel new];
	if (![theID runModalForDirectory:"~" file:"viva2DBBackup.dsqldmp"]) {
		return self;
	}
	theFileName = [String str:[theID filename]];

	if (strstr([theID filename],".dsqldmp")== NULL) {
		[theFileName concatSTR:".dsqldmp"];
	}
	[dumpWaitPanel makeKeyAndOrderFront:self];
	
	if ([self dumpToDevice:theFileName]) {
		id	queryString;
		today = [Date today];
		[[NXApp defaultQuery] useDatabase:"viva2DB"];
		queryString = [QueryString str:"insert into vivadumps values("];
		[queryString concatFieldComma:today];
		[queryString concatField:theFileName];
		[queryString concatSTR:")"];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		[queryString free];
		[self garbageCollection];
		[dumpWaitPanel orderOut:self];
		[self makeActive:self];
		[today free];
	} else { 
		[dumpWaitPanel orderOut:self];
		NXBeep();
	}
	[theFileName free];
	return self;
}



- recover:sender
{
	static char *restoreTypes[] = { "dsqldmp", NULL };
	char	restoreFileName[2050];
	char	restoreDirName[2050];
	char	*lastSlash;
	id		openPanel;
	
	if( [[NXApp errorMgr] showDialog:"RestoreDB"
							  yesButton:"YES"
							  noButton:"NO"]==EHYES_BUTTON ) {
		strcpy( restoreDirName, [selectedDump str] );
		lastSlash = rindex( restoreDirName, '/' ) + 1;
		strcpy( restoreFileName, lastSlash );
		*lastSlash = (char)0;

		openPanel = [OpenPanel new];
		[openPanel allowMultipleFiles:NO];
		if( [openPanel runModalForDirectory:restoreDirName
						file:restoreFileName
						types:restoreTypes] ) {
			strcpy( restoreFileName, [openPanel directory] );
			strcat( restoreFileName, "/" );
			strcat( restoreFileName, *[openPanel filenames] );

			if( [[NXApp errorMgr] showDialog:"RestoringDB"
								      yesButton:"OK"
							      	  noButton:"CANCEL"] == EHYES_BUTTON ) {
				
				[restoreWaitPanel makeKeyAndOrderFront:self];
				[self loadFromDevice:restoreFileName];
				[restoreWaitPanel orderOut:self];
			}
		}
	}
	
	return self;
}


- dumpToDevice:(id)whichOne
{
	id	retVal = self;
	id	dumpString;
	int	oldTO= [Query timeout];
	
	[Query setTimeout:0];
	[[NXApp defaultQuery] useDatabase:"master"];
	dumpString = [QueryString str:"sp_addumpdevice \"disk\", vivaDumpdevice,"];
	[dumpString concatFieldComma:whichOne];
	[dumpString concatSTR:"2"];
	[[[NXApp defaultQuery] performQuery:dumpString] free];
	if ([[NXApp defaultQuery] lastError] == NOERROR){
		[dumpString free];
		dumpString = [QueryString str:"dump tran viva2DB to diskdump with NO_LOG"];
		[[[NXApp defaultQuery] performQuery:dumpString] free];
		if ([[NXApp defaultQuery] lastError] == NOERROR){
			[dumpString free];
			dumpString = [QueryString str:"dump database viva2DB to vivaDumpdevice with NO_LOG"];
			[[[NXApp defaultQuery] performQuery:dumpString] free];
			if ([[NXApp defaultQuery] lastError] != NOERROR) {
				[[NXApp errorMgr] showDialog:"ErrorOnBackup" yesButton:"OK"];
				retVal = nil;
			}
			[dumpString free];
			dumpString = [QueryString str:"sp_dropdevice vivaDumpdevice"];
			[[[NXApp defaultQuery] performQuery:dumpString] free];
		} else {
			[[NXApp errorMgr] showDialog:"ErrorOnBackup" yesButton:"OK"];
			retVal = nil;
		}
	} else {
		[[NXApp errorMgr] showDialog:"ErrorOnBackup" yesButton:"OK"];
		retVal = nil;
	}
	[dumpString free];
	[[NXApp defaultQuery] useDatabase:"viva2DB"];
	[Query setTimeout:oldTO];
	return retVal;
}

- loadFromDevice:(const char *)whichOne
{
	id	dumpString;
	int	oldTO= [Query timeout];
	
	[Query setTimeout:0];
	[[NXApp defaultQuery] useDatabase:"master"];
	dumpString = [QueryString str:"sp_addumpdevice \"disk\", vivaDumpdevice,\""];
	[dumpString concatSTR:whichOne];
	[dumpString concatSTR:"\",2"];
	[[[NXApp defaultQuery] performQuery:dumpString] free];
	if ([[NXApp defaultQuery] lastError] == NOERROR){
		[dumpString free];
		dumpString = [QueryString str:"load database viva2DB from vivaDumpdevice"];
		[[[NXApp defaultQuery] performQuery:dumpString] free];
		if ([[NXApp defaultQuery] lastError] != NOERROR) {
			[[NXApp errorMgr] showDialog:"ErrorOnRestore" yesButton:"OK"];
		}
		dumpString = [QueryString str:"sp_dropdevice vivaDumpdevice"];
		[[[NXApp defaultQuery] performQuery:dumpString] free];
	} else {
		[[NXApp errorMgr] showDialog:"ErrorOnRestore" yesButton:"OK"];
	}
	[dumpString free];
	[[NXApp defaultQuery] useDatabase:"viva2DB"];
	[Query setTimeout:oldTO];
	return self;
}

- (BOOL)garbageCollection
{
	BOOL	result;
	id		queryString = [QueryString str:"delete from bindata where id not in (select bulkdataid from attachments)"];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	result = [[NXApp defaultQuery] lastError] == NOERROR;
	if(!result) {
		[[NXApp errorMgr] showDialog:"ErrorOnGarbageCollection" yesButton:"OK"];
	}
	return result;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [lastdumps count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	aDump = [lastdumps objectAt:row];
	[cell setColumnCount:2];
	[cell setDistance:8.0];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:50 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[[aDump objectAt:0] writeIntoCell:cell inColumn:0];
	[[aDump objectAt:1] writeIntoCell:cell inColumn:1];
	[cell setTag:row];
	[cell setLoaded:YES];
	return self;
}

- browserClicked:sender
{	
	int	selCell = [[[dumpsBrowser matrixInColumn:0] selectedCell] tag];
	id	obj = [lastdumps objectAt:selCell];
	if (obj != NULL) {
		[selectedDump str:[[obj objectAt:1] str]];
		[[obj objectAt:0] writeIntoCell:lDumpDateField];
		[[obj objectAt:1] writeIntoCell:lDumpNameField];
	} else {
		[lDumpDateField setStringValue:""];
		[lDumpNameField setStringValue:""];
		[selectedDump str:"~/Unknown"];
	}
	return self;
}

- (BOOL)save
{
	[dumpButton performClick:self];
	return YES;
}

- (BOOL)revertToSaved
{
	[restoreButton performClick:self];
	return YES;
}

- checkMenus
{
	[super checkMenus];
	[[NXApp newButton] setEnabled:NO];
	[[NXApp destroyButton] setEnabled:NO];
	[[NXApp findButton] setEnabled:NO];
	return self;
}
@end

#if 0
BEGIN TABLE DEFS
create table vivadumps
(
	dateofdump	datetime,
	filename	text
)
go
END TABLE DEFS
#endif
