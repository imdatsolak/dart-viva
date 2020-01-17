#import <appkit/Application.h>
#import <appkit/Button.h>
#import <appkit/ScrollView.h>
#import <soundkit/soundkit.h>

#import "SoundPlayer.h"
#import "TheApp.h"
#import "ImageManager.h"
#import "StringManager.h"

#pragma .h #import <objc/Object.h>

@implementation SoundPlayer:Object
{
    id		soundView;
    id		pauseButton;
    id		meter;
    id		recordButton;
    id		window;
    id		playButton;
    id		stopButton;
}


- init
{
	[super init];
	[NXApp loadNibSection:"SndController.nib" owner: self];
	soundView = [soundView docView];
    [soundView setDelegate:self];
	[[NXApp imageMgr] iconFor:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	[window setMiniwindowIcon:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	return self;
}

- readFromFile:(const char *)soundFile
{
	[soundView setSound: [Sound newFromSoundfile: (char *)soundFile]];
	[window setTitleAsFilename:soundFile];
	[window makeKeyAndOrderFront:self];
//	[soundView setSound:[Sound new]];
	return self;
}

- free
{
	[self stop:self];
	[[soundView sound] free];
	[window orderOut:nil];
	return [super free];
}

- window { return window; }
- play { return [self play:self]; }

- play:sender
{
	[[pauseButton setState:0] setEnabled:YES];
	[[recordButton setState:0] setEnabled:NO];
	[[playButton setEnabled:NO] setState:1];
	[soundView play:self];
	return self;
}

- willPlay:sender
{
	[meter setSound:[sender soundBeingProcessed]];
	[meter run:self];
	return self;
}

- didPlay:sender
{
	[[playButton setState:0] setEnabled:YES];
	[[recordButton setState:0] setEnabled:YES];
	[[pauseButton setState:0] setEnabled:NO];
	[meter stop:self];
	return self;
}

- stop:sender
{
	[soundView stop:sender];
	[[playButton setState:0] setEnabled:YES];
	[[recordButton setState:0] setEnabled:YES];
	[[pauseButton setState:0] setEnabled:NO];
	return self;
}

- pause:sender
{
	if ( ![playButton state] && ![recordButton state] ) {
		[pauseButton setState: 0];
		return self;
	}
	
	if ([pauseButton state]) {
		[soundView pause:sender];
	} else {
		[soundView resume:sender];
	}
	return self;
}

- record:sender
{
	[recordButton setEnabled:NO];
	[playButton setEnabled:NO];
	[soundView record:sender];
	return self;
}

- willRecord: sender
{
	[meter setSound:[sender soundBeingProcessed]];
	[meter run:self];
	return self;
}

- didRecord:sender
{
	[[playButton setState:0] setEnabled:YES];
	[[recordButton setState:0] setEnabled:YES];
	[[pauseButton setState:0] setEnabled:NO];
	[meter stop:self];
	return self;
}


- windowWillClose:sender
{
	[soundView stop:sender];	
	[sender setDelegate:nil];
	[self free];
	window = nil;
    return (id)YES;
}


@end
