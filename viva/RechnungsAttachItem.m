#import "TheApp.h"
#import "ImageManager.h"

#import "RechnungsDocument.h"
#import "RechnungsAttachItem.h"

#pragma .h #import "AttachmentItem.h"

@implementation RechnungsAttachItem:AttachmentItem
{
}

- open:sender
{
	return [[[RechnungsDocument alloc] initIdentity:[self identity]] makeActive:self];
}

- (const char *)miniIcon 
{
	return [[[NXApp imageMgr] iconFor:"MiniTXT"] name];
}

- imageObject
{
	return [[NXApp imageMgr] iconFor:"RechnungItem"];
}

@end

