#import "ScrollingSound.h"
#import <soundkit/soundkit.h>

#pragma .h #import <appkit/ScrollView.h>

@implementation ScrollingSound:ScrollView
{
}


+ newFrame:(NXRect const *)theFrame
{
    NXRect tempRect = *theFrame;
    id theSoundView;
    int borderType = NX_BEZEL;
    
    [ScrollView getContentSize:&tempRect.size forFrameSize:&theFrame->size
    		horizScroller:YES vertScroller:NO borderType:borderType];
    theSoundView = [SoundView newFrame:&tempRect];
    [theSoundView setReductionFactor:32.0];
    self = [super newFrame:theFrame];
    [self setBorderType:borderType];
    [self setHorizScrollerRequired:YES];
    [self setDynamicScrolling:YES];
    [self setDocView:theSoundView];
    [self setBackgroundGray:NX_WHITE];
    [self setAutoresizeSubviews:YES];
    [self setAutosizing:NX_WIDTHSIZABLE|NX_HEIGHTSIZABLE];
    [[theSoundView superview] setAutoresizeSubviews:YES];
    [theSoundView setAutosizing:NX_HEIGHTSIZABLE];
    return self;
}

- setDelegate:anObject {return [[self docView] setDelegate:anObject];}
- play:sender {return [[self docView] play:sender];}
- stop:sender {return [[self docView] stop:sender];}
- record:sender {return [[self docView] record:sender];}

@end


