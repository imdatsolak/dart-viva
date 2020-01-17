#import "TheApp.h"
#import "ImageManager.h"

#import "LieferscheinDocument.h"
#import "LieferscheinAttachItem.h"

#pragma .h #import "AttachmentItem.h"

@implementation LieferscheinAttachItem:AttachmentItem
{
}

- open:sender
{
	return [[[LieferscheinDocument alloc] initIdentity:[self identity]] makeActive:self];
}

- (const char *)miniIcon 
{
	return [[[NXApp imageMgr] iconFor:"MiniTXT"] name];
}

- imageObject
{
	return [[NXApp imageMgr] iconFor:"LieferscheinItem"];
}

@end

