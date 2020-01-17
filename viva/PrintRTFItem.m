#import <stdlib.h>
#import <string.h>
#import <sys/param.h>

#import <appkit/NXImage.h>
#import <appkit/Speaker.h>
#import <appkit/Listener.h>

#import "dart/dartlib.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "SoundPlayer.h"
#import "ImageManager.h"
#import "PrintoutDocument.h"

#import "PrintRTFItem.h"

#pragma .h #import "AttachmentItem.h"

@implementation PrintRTFItem:AttachmentItem
{
	id	data;
}

- initPosition:aPosition identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid
{
	[super initPosition:aPosition identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid];
	[self setImageObject:[self getMyIcon]];
	return self;
}

- initIdentity:theIdentity description:aDescr supplDescription:aSupplDescr data:aData
{
	id	zero = [Integer int:0];
	[self initIdentity:theIdentity description:aDescr supplDescription:aSupplDescr bulkdataid:zero];
	[zero free];
	data = [aData copy];
	[self setEdited:YES];
	return self;
}

- free
{
	data = [data free];
	return [super free];
}

- copy
{
	id	theCopy = [super copy];
	data = [data copy];
	return theCopy;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteObject(stream, [self data]);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	data = NXReadObject(stream);
	[self setImageObject:[self getMyIcon]];
	return self;
}

- (BOOL)descriptionEditable
{
	return NO;
}

- (BOOL)save
{
	NXStream		*stream = NXOpenMemory(NULL,0,NX_READWRITE);
	NXTypedStream	*typedstream = NXOpenTypedStream(stream,NX_WRITEONLY);
	BOOL			retvalue = NO;
	NXWriteObject(typedstream,[self data]);
	if(0==[[self bulkdataid] int]) {
		[[self bulkdataid] setInt:[[NXApp defaultQuery] insertBinData:stream]];
		if(0 != [[self bulkdataid] int]) {
			id	newIdentity = [[self bulkdataid] copyAsString];
			[self setIdentity:newIdentity];
			[newIdentity free];
			retvalue = YES;
		} else {
			retvalue = NO;
		}
	} else {
		retvalue = [[NXApp defaultQuery] updateBinData:stream withID:[[self bulkdataid] int]];
	}
	NXCloseTypedStream(typedstream);
	NXCloseMemory(stream,NX_FREEBUFFER);
	[self setEdited:NO];
	return retvalue;
}

- (BOOL)saveYourBulkdataIfNecessary
{
	if([self isEdited]) {
		return [self save];
	} else {
		return YES;
	}
}

- open:sender
{
	[[[PrintoutDocument alloc] initItem:[self copy]] makeActive:self];
	return self;
}

- data
{
	if(data == nil) {
		if([[self bulkdataid] int] != 0) {
			NXStream *stream = [[NXApp defaultQuery] selectBinDataWithID:[[self bulkdataid] int]];
			if(stream) {
				NXTypedStream	*typedstream = NXOpenTypedStream(stream,NX_READONLY);
				data = NXReadObject(typedstream);
				NXCloseTypedStream(typedstream);
				NXCloseMemory(stream,NX_FREEBUFFER);
			}
		}
	}
	return data;
}

- reloadData
{
	data = [data free];
	return self;
}

- (const char *)miniIcon 
{
	return [[[NXApp imageMgr] iconFor:"MiniRTF"] name];
}

- getMyIcon
{
	return [[NXApp imageMgr] iconFor:"vivaRTF"];
}

- readRTFFromText:aText
{
	[[self data] readRTFFromText:aText];
	[self setEdited:YES];
	return self;
}

- writeRTFIntoText:aText
{
	[[self data] writeRTFIntoText:aText];
	return self;
}

@end
