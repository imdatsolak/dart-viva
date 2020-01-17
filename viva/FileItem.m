#import <stdlib.h>
#import <string.h>
#import <sys/param.h>

#import <appkit/NXImage.h>
#import <appkit/Speaker.h>
#import <appkit/Listener.h>

#import "dart/debug.h"
#import "dart/dartlib.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "SoundPlayer.h"
#import "RTFEditor.h"
#import "ImageManager.h"

#import "FileItem.h"

#pragma .h #import "AttachmentItem.h"

@implementation FileItem:AttachmentItem
{
	id	extension;
}

- initPosition:aPosition identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid
{
	[super initPosition:aPosition identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid];
	[self setImageObject:[self getIconForFile:[self identity]]];
	[self createExtensionFrom:description];
	return self;
}

- initFilename:aFilename
{	
	if (aFilename != nil) {
		id		path;
		id		name;
		id		zero = [Integer int:0];
		char	s[MAXPATHLEN];
		strncpy0(s,[aFilename str],sizeof(s));
		
		if (strrchr(s,'/') != s) {
			name = [String str:strrchr(s,'/')+1];
			path = [String str:""];
			if(rindex(s,'/')) {
				*(rindex(s,'/')) = '\0';
				[path str:s];
			}
		} else {
			path = [String str:"/"];
			name = [String str:s];
		}
		
		[super initPosition:zero identity:aFilename description:name supplDescription:path bulkdataid:zero];
		[self setImageObject:[self getIconForFile:[self identity]]];
		[self createExtensionFrom:description];
		[name free];
		[path free];
		[zero free];
		DEBUG2("initFileName:[%s]\n",[aFilename str]);
	} else {
		[super initPosition:nil identity:nil description:nil supplDescription:nil bulkdataid:nil];
	}
	
	return self;
}

- createExtensionFrom:aDescription
{
	extension = [String str:""];
	if (aDescription != nil) {
		char	s[MAXPATHLEN];
		strncpy0(s,[aDescription str],sizeof(s));
		if(rindex(s,'.')) {
			[extension str:rindex(s,'.')+1];
		}
	}
	return self;
}


- getIconForFile:aFile
{	
	id			newIcon = nil;
	char		*theData;
	int			length;
	int			flag;
	NXStream	*stream;
	id			speaker = [NXApp appSpeaker];
	
	if ([aFile length]) {
		[speaker setSendPort:NXPortFromName(NX_WORKSPACEREQUEST, NULL)];
		[speaker getFileIconFor:(char *)[aFile str] TIFF:&theData TIFFLength:&length ok:&flag];
		
		stream = NXOpenMemory(theData, length, NX_READONLY);
		newIcon = [[NXImage alloc] initFromStream:stream];
		NXCloseMemory(stream, NX_SAVEBUFFER);
	}
	return newIcon;
}

- free
{
	extension = [extension free];
	return [super free];
}

- copy
{
	id	theCopy = [super copy];
	extension = [extension copy];
	return theCopy;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteObject(stream, extension);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	extension = NXReadObject(stream);
	[self setImageObject:[self getIconForFile:[self identity]]];
	return self;
}

- open:sender
{
	[[NXApp appSpeaker] setSendPort:NXPortFromName(NX_WORKSPACEREQUEST, NULL)];
	
	if(0 == [extension compareSTR:"snd"]) {
		[[[SoundPlayer alloc] init] readFromFile:[[self identity] str]];
	} else {
		int	flag = 0;
		[[NXApp appSpeaker] launchProgram:[[self identity] str] ok:&flag];
		if(flag == 0) [[NXApp appSpeaker] openFile:[[self identity] str] ok:&flag];
	}

	return self;
}

- (const char *)miniIcon 
{
	DEBUG1("The Extension is:[%s]\n", [extension str]);
	if ([extension compareSTR:"tiff"]==0) {
		return [[[NXApp imageMgr] iconFor:"MiniTIFF"] name];
	} else if ([extension compareSTR:"eps"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniEPS"] name];
	} else if ([extension compareSTR:"snd"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniSND"] name];
	} else if ([extension compareSTR:"score"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniSCORE"] name];
	} else if ([extension compareSTR:"playscore"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniPLAYSCORE"] name];
	} else if ([extension compareSTR:"rtf"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniRTF"] name];
	} else if ([extension compareSTR:"rtfd"] == 0) {
		return [[[NXApp imageMgr] iconFor:"MiniRTF"] name];
	} else {
		return [[[NXApp imageMgr] iconFor:"MiniTXT"] name];
	}
}

@end
