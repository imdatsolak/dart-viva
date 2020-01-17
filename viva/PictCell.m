#import <streams/streams.h>
#import <appkit/Text.h>
#import <appkit/Button.h>
#import <appkit/NXImage.h>

#import "TheApp.h"
#import "PictCell.h"

#pragma .h #import <appkit/ButtonCell.h>

@implementation PictCell:ButtonCell
{
	id		theImage;
	char	filename[2048+1];
}

- doubleClickAction:sender
{
    return self;
}

- readRichText:(NXStream *)stream forView:view
{
	NXStream *theStream;
	[self setBordered:NO];
	[self setState: 1];
	[self setHighlightsBy:NX_NONE];
	NXScanf(stream, "%s", filename);
	[self setType: NX_ICONCELL];

	if ((theStream = NXMapFile(filename, NX_READONLY))== NULL) {
		return self;
	}
	theImage = [[[NXImage alloc] initFromStream:theStream] setDataRetained:YES];
	[self setImage:theImage];
	NXCloseMemory(theStream,NX_FREEBUFFER);
	[self sendActionOn: 0];
	return self;
}


- free
{
	[theImage free];
	return [super free];
}


- writeRichText:(NXStream *)stream forView:view
{
	NXPrintf(stream, " %s ",  filename);
	return self;
}

- drawInside:(const NXRect *)rect inView:view
{
//	if (NXDrawingStatus == NX_PRINTING) {
//		[[self image] setEPSUsedOnResolutionMismatch:YES];
//		[[self image] setFlipped:YES];
//		[[self image] drawRepresentation:[[self image] bestRepresentation] inRect:rect];
//	} else {
		[super drawInside:rect inView:view];
//	}
	return self;
}
@end
