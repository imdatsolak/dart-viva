#import <appkit/SavePanel.h>
#import <appkit/Matrix.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"
#import "Timer.h"
#import "TheApp.h"
#import "StringManager.h"
#import "DefaultsDatabase.h"

#pragma .h #import <objc/Object.h>
#pragma .h #import <streams/streams.h>

#import "ExportManager.h"

@implementation ExportManager:Object
{
	id	currentExporter;
	id	exportFieldDelimiter;
	id	exportRecordDelimiter;
	id	exportWithFieldNames;
	id	exporterName;
	id	theTimer;
	id	selectionMatrix;
	id	theEntryList;

	NXStream	*exportStream;
	
	int	numRows;
	int	numColumns;
	
	id	selectedRowsList;
}

- init
{
	id	dbValue;
	[super init];
	exportFieldDelimiter	= [String str:""];
	exportRecordDelimiter	= [String str:""];
	exportWithFieldNames	= [Integer int:1];
	exporterName			= [String str:""];
	if ((dbValue = [[NXApp defaultsDB] valueForKey:"exportColDelimiter"]) != nil) {
		[exportFieldDelimiter str:[dbValue str]];
	}
	if ((dbValue = [[NXApp defaultsDB] valueForKey:"exportRowDelimiter"]) != nil) {
		[exportRecordDelimiter str:[dbValue str]];
	}
	if ((dbValue = [[NXApp defaultsDB] valueForKey:"exportExportNames"]) != nil) {
		[exportWithFieldNames setInt:[dbValue int]];
	}
	if ((dbValue = [[NXApp defaultsDB] valueForKey:"exportFormat"]) != nil) {
		[exporterName str:[dbValue str]];
	}
	
	currentExporter = nil;
	return self;
}

- free
{
	[exportFieldDelimiter free];
	[exportRecordDelimiter free];
	[exportWithFieldNames free];
	[exporterName free];
	return [super free];
}

- export:sender
{
	id	fileToSaveTo;
	id	savePanel;
	id	exporter = nil;
	exporter = [NXApp classForString:[exporterName str]];
	if (numRows) { 
		[selectionMatrix scrollCellToVisible:0 :0];
		savePanel = [SavePanel new];
		if ([savePanel runModalForDirectory:"~" file:"viva-Export.txt"]) {
			fileToSaveTo = [String str:[savePanel filename]];
			exportStream = NXOpenMemory(NULL, 0, NX_WRITEONLY);
			theTimer = [[Timer alloc]  initTitle:[[NXApp stringMgr] stringFor:"Exporting"]];
			[theTimer showTimer:self];
			
			if (exporter != nil) {
				[self exportExternWithTimer:theTimer withExporter:exporter];
			} else {
				[self exportIntern];
			}
			
			NXSaveToFile(exportStream, [fileToSaveTo str]);
			NXCloseMemory(exportStream, NX_FREEBUFFER);

			theTimer = [theTimer free];
			[fileToSaveTo free];
		}
	} else {
		[NXApp beep:"Nothing selected"];
	}
	return self;
}

- exportIntern
{
	if ([exportWithFieldNames int] != 0) {
		[self writeFieldNamesToStream:exportStream];
	}
	[selectionMatrix sendAction:@selector(exportOneIntern:) to:self forAllCells:NO];
	return self;
}


- exportOneIntern:sender
{
	int		i;
	id		theRow = [theEntryList objectAt:[sender tag]];
	if (exportStream) {
		if (theTimer) {
			[theTimer updateTimer:100.0/numRows];
		}
		for (i=0; i<numColumns; i++) {
			[[theRow objectAt:i] writeIntoStream:exportStream];
			if (i < numColumns-1) {
				[self writeFieldDelimiterToStream:exportStream];
			}
		}
		[self writeRecordDelimiterToStream:exportStream];
	}
	[selectionMatrix scrollCellToVisible:[sender tag]+1 :0];
	return self;
}

- createListForExternExport:sender
{
	[selectedRowsList addObject:[[theEntryList objectAt:[sender tag]] copy]];
	[selectionMatrix scrollCellToVisible:[sender tag]+1 :0];
	return self;
}

- exportExternWithTimer:aTimer withExporter:exporter
{
	BOOL	fieldNamesFlag = ([exportWithFieldNames int] != 0);
	
	id	newExporter = [[[exporter class] alloc] init];
	if (newExporter) {
		if  (fieldNamesFlag) {
			[newExporter writeFieldNamesOf:theEntryList intoStream:exportStream];
		}
		[newExporter setNumRows:numRows];
		[newExporter setNumColumns:numColumns];
		if ([newExporter wantsAllRowsAtOnce]) {
			selectedRowsList = [[List alloc] initCount:numRows];
			[selectionMatrix sendAction:@selector(createListForExternExport:) to:self forAllCells:NO];
			[newExporter writeAll:selectedRowsList 
						 intoStream:exportStream 
						 withTimer:aTimer 
						 exportFieldNames:fieldNamesFlag];
			[[selectedRowsList freeObjects] free];
		} else {
			currentExporter= newExporter;
			[selectionMatrix sendAction:@selector(exportOneExtern:) to:self forAllCells:NO];
			currentExporter= nil;
		}
		[newExporter free];
	}
	return self;
}

- exportOneExtern:sender
{
	id	rVal = nil;
	id	theRow = [theEntryList objectAt:[sender tag]];
	if (exportStream && currentExporter) {
		if (theTimer) {
			[theTimer updateTimer:100.0/numRows];
		}
		rVal = [currentExporter writeRow:theRow intoStream:exportStream];
	}
	[selectionMatrix scrollCellToVisible:[sender tag]+1 :0];
	return rVal;
}

- setNumRows:(int)rows
{
	numRows = rows;
	return self;
}

- setNumColumns:(int)columns
{
	numColumns = columns;
	return self;
}

- setSelectionMatrix:matrix
{
	selectionMatrix = matrix;
	return self;
}

- setEntryList:anEntryList
{
	theEntryList = anEntryList;
	return self;
}

- writeAsControlCharacter:(const char *)what toStream:(NXStream *)aStream
{
	int	i;
	i = 0;
	while (what[i]) {
		if (what[i] != '^') {
			NXPrintf(aStream,"%c", what[i]);
		} else if ((what[i+1] >= '@') && (what[i+1] <= 'Z')) {
			NXPrintf(aStream,"%c", what[i+1]-64);
			i++;
		}
		i++;
	}
	return self;
}


- writeFieldDelimiterToStream:(NXStream *)theStream
{
	[self writeAsControlCharacter:[exportFieldDelimiter str] toStream:theStream];
	return self;
}


- writeRecordDelimiterToStream:(NXStream *)theStream
{
	[self writeAsControlCharacter:[exportRecordDelimiter str] toStream:theStream];
	return self;
}

- writeFieldNamesToStream:(NXStream *)aStream
{
	char	*title;
	BOOL	numeric;
	int		length, alignment, tag,i, columnCount = [[theEntryList objectAt:0] count];
	
	if (exportStream) {
		for (i=0;i<columnCount;i++) {
			[theEntryList getTitle:&title length:&length alignment:&alignment 
					numeric:&numeric andTag:&tag ofColumn:i];
			NXPrintf(exportStream,"%s",title);
			if (i < columnCount-1) {
				[self writeFieldDelimiterToStream:exportStream];
			}
		}
		[self writeRecordDelimiterToStream:exportStream];
	}
	return self;
}


@end

@interface Object(AnExporter)
+ (int)vivaObjectType;
+ (const char *)publicname;
+ (const char *)copyright;
- setNumRows:(int)rows;
- setNumColumns:(int)columns;
- (BOOL)wantsAllRowsAtOnce;
- writeRow:theRow intoStream:(NXStream *)exportStream;
- writeAll:aListOfLists intoStream:(NXStream *)exportStream withTimer:aTimer exportFieldNames:(BOOL)flag;
- writeFieldNamesOf:aListOfLists intoStream:(NXStream *)exportStream;
@end
