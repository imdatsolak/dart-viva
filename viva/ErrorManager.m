#import <stdlib.h>

#import <appkit/Window.h>
#import <appkit/ScrollView.h>
#import <appkit/Text.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/Localizer.h"

#import "StringManager.h"
#import "TheApp.h"

#import "ErrorManager.h"

#pragma .h #import <objc/Object.h>
#pragma .h #define EHSTUPID_PROGRAMMER        0
#pragma .h #define EHYES_BUTTON               1
#pragma .h #define EHNO_BUTTON                2
#pragma .h #define EHALT_BUTTON               3
  
@implementation ErrorManager:Object
{
	id	errorWindow;
	id	helpWindow;
	id	scrollingView;
	id	errorTitle;
	id	errorText;
	id	programLogo;
	
	id	thisExplainKey;
	id	thisExplainParam;
	id	myAnotherDialog;
	
	BOOL	showingHelp;
}

- fatalError:(const char *)name
{
	[self showDialog:name yesButton:"Quit"];
	return [self error:"%s",name];
}


- showDialogDatum
{
	[NXApp runModalFor:myAnotherDialog];
	return self;
}

- showLastSybaseErrorFrom:aQuery
{
	id		errTxt = [String str:""];
	[errTxt concatINT:[aQuery lastError]];
	[errTxt concatSTR:": "];
	[errTxt concatSTR:[aQuery lastErrorSTR]];
	[[self moveButton:100 withFrameOf:100 move:YES] setTitle:[[NXApp stringMgr] textForErrCode:"OK"]];
	[errorTitle setStringValue:"Datenbank-Fehler"];
	[errorText setStringValue:[errTxt str]];
	[NXApp runModalFor:errorWindow];
	[errorWindow orderOut:self];
	[self cleanUp:"OK" :NULL :NULL :NULL];
	[errTxt free];
	return self;
}

- (BOOL)discardChanges:aWindow
{
	if ([aWindow isDocEdited]) {
		return ([self showDialog:"DISCARD CHANGES" yesButton:"NO"
		 	noButton:"YES" explain:"DISCARD CHANGES EXP"] == EHNO_BUTTON);
	} else {
		return YES;
	}
}
/* ======================================= PRIVATE METHODS ==================================== */
- finishModal:sender
{
	return [NXApp stopModal:[sender tag]];
}


- moveButton:(int )tagOf withFrameOf:(int )frameOf move:(BOOL)flag
{
	id source,dest,button;
	NXRect theFrame;
	
	if (flag) {
		source = helpWindow;
		dest = errorWindow;
	} else {
		source = errorWindow;
		dest = helpWindow;
	}
	
	button = [[source contentView] findViewWithTag:tagOf];
	if (!flag) {
		[button removeFromSuperview];
	} else {
		button = [button copy];
		[button removeFromSuperview];
		[[[source contentView] findViewWithTag:frameOf] getFrame:&theFrame];
		[button setFrame:&theFrame];
		[[dest contentView] addSubview:button];
		[button setTarget:self];
		if (tagOf == 400) 
			[button setAction:@selector(showHelp:)];
		else
			[button setAction:@selector(finishModal:)];
		return button;
	}
	return nil;
	
}


- cleanUp:(const char *)button1 :(const char *)button2 :(const char *)button3 :(const char *)explainKey
{
	if (button1) { 
		[self moveButton:100 withFrameOf:0 move:NO];
	}
	if (button2) {
		[self moveButton:200 withFrameOf:0 move:NO];
	}
	if (button3) {
		[self moveButton:300 withFrameOf:0 move:NO];
	}
	if (explainKey) {
		[self moveButton:400 withFrameOf:0 move:NO];
	}
	return self;
}


- showHelp:sender /*n*/
{
	NXRect mainFrame, helpFrame;
	
	[errorWindow getFrame:&mainFrame];
	[scrollingView getFrame:&helpFrame];
	
	[scrollingView removeFromSuperview];
	if (showingHelp) {
		mainFrame.size.height -= helpFrame.size.height + 8;
		mainFrame.origin.y += helpFrame.size.height + 8;
		[[helpWindow contentView] addSubview:scrollingView];
	} else {
		mainFrame.size.height += helpFrame.size.height + 8;
		mainFrame.origin.y -= helpFrame.size.height + 8;
		[[errorWindow contentView] addSubview:scrollingView];
	}
	[errorWindow placeWindowAndDisplay:&mainFrame];

	if (!showingHelp) {
		if ([thisExplainParam length]) {
			id theText = [String str:[[NXApp stringMgr] textForErrCode:[thisExplainKey str]]];
			[theText concat:thisExplainParam];
			[theText writeIntoText:[scrollingView docView]];
			[theText free];
		} else {
			[[scrollingView docView] setText:[[NXApp stringMgr] textForErrCode:[thisExplainKey str]]];
		}
	}
	if (sender != self)
		[errorWindow display];

	showingHelp = !showingHelp;
	return self;
}


/* ======================================== PUBLIC METHODS ==================================== */

- init
{
	[super init];
	[[NXApp localizer] loadLocalNib:"ErrorManager" owner:self];
	thisExplainKey = [String str:""];
	thisExplainParam = [String str:""];
	return self;
}


- (int) showDialog:(const char *)name
{
	return [self showDialog:name yesButton:"OK" noButton:NULL altButton:NULL explain:NULL
		explainParam:NULL];
}

- (int) showDialog:(const char *)name explain:(const char *)explainKey explainParam:(const char *)param
{
	return [self showDialog:name yesButton:"OK" noButton:NULL altButton:NULL explain:explainKey
		explainParam:param];
}


- (int) showDialog:(const char *)name explain:(const char *)explainKey
{
	return [self showDialog:name yesButton:"OK" noButton:NULL altButton:NULL explain:explainKey  explainParam:NULL];
}



- (int) showDialog:(const char *)name yesButton:(const char *)button1
{
	return [self showDialog:name yesButton:button1 noButton:NULL altButton:NULL explain:NULL explainParam:NULL];
}



- (int) showDialog:(const char *)name yesButton:(const char *)button1 noButton:(const char *)button2
{
	return [self showDialog:name yesButton:button1 noButton:button2 altButton:NULL explain:NULL explainParam:NULL];
}



- (int) showDialog:(const char *)name yesButton:(const char *)button1 explain:(const char *)explainKey
{
	return [self showDialog:name yesButton:button1 noButton:NULL altButton:NULL explain:explainKey explainParam:NULL];
}



- (int) showDialog:(const char *)name yesButton:(const char *)button1 noButton:(const char *)button2 explain:(const char *)explainKey
{
	return [self showDialog:name yesButton:button1 noButton:button2 altButton:NULL explain:explainKey explainParam:NULL];
}


- (int) showDialog:(const char *)name yesButton:(const char *)button1 noButton:(const char *)button2 altButton:(const char *)button3
{
	return [self showDialog:name yesButton:button1 noButton:button2 altButton:button3 explain:NULL explainParam:NULL];
}

- (int) showDialog:(const char *)name yesButton:(const char *)button1 noButton:(const char *)button2 altButton:(const char *)button3 explain:(const char *)explainKey
{
	return [self showDialog:name yesButton:button1 noButton:button2 altButton:button3 explain:explainKey explainParam:NULL];
}


- (int) showDialog:(const char *)name yesButton:(const char *)button1 noButton:(const char *)button2 altButton:(const char *)button3 explain:(const char *)explainKey explainParam:(const char *)param
{
	int 	aTag=100;
	id		titleKey;
	
	[thisExplainKey str:""];
	if (button1) { 
		[[self moveButton:100 withFrameOf:aTag move:YES] setTitle:[[NXApp stringMgr] textForErrCode:button1]];
		aTag += 100;
	}
	if (button2) {
		[[self moveButton:200 withFrameOf:aTag move:YES] setTitle:[[NXApp stringMgr] textForErrCode:button2]];
		aTag += 100;
	}
	if (button3) {
		[[self moveButton:300 withFrameOf:aTag move:YES] setTitle:[[NXApp stringMgr] textForErrCode:button3]];
		aTag += 100;
	}
	if (explainKey) {
		[thisExplainKey str:explainKey];
		[[self moveButton:400 withFrameOf:400 move:YES] setTitle:[[NXApp stringMgr] textForErrCode:"EH_Explain"]];
		aTag += 100;
		if (param) {
			[thisExplainParam str:param];
		}
	}
	[errorText setStringValue:[[NXApp stringMgr] textForErrCode:name]];

	titleKey = [String str:name];
	[titleKey concatSTR:"-TITLE"];
	[errorTitle setStringValue:[[NXApp stringMgr] textForErrCode:[titleKey str]]];
	[titleKey free];
	
	aTag = [NXApp runModalFor:errorWindow] / 100;
	[errorWindow orderOut:self];
	if (showingHelp)
		[self showHelp:self];
	if (thisExplainKey) {
		[thisExplainKey str:""];
	}
	if (thisExplainParam) {
		[thisExplainParam str:""];
	}
	[self cleanUp:button1 :button2 :button3 :explainKey];
	return aTag;
}


- free
{
	[thisExplainKey free];
	[thisExplainParam free];
	return [super free];
}

@end
