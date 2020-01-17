#import <stdlib.h>
#import <strings.h>

#import <appkit/Matrix.h>
#import <appkit/Cell.h>

#import "DartPrintPanel.h"

#pragma .h #import <appkit/PrintPanel.h>

@implementation DartPrintPanel: PrintPanel
{
	int 	pickedTag;
	BOOL	printStrict;
	char	*title;
	int		countCopies;
}

- (int )runModal
{
	pickedTag = 0;
	[self readPrintInfo];
	
	[self pickedAllPages:self];
	[pageMode setEnabled:YES];
	[firstPage setEnabled:YES];
	[lastPage setEnabled:YES];
	[ok setEnabled:YES];
	[cancel setEnabled:YES];
	[feed setEnabled:YES];
	[resolutionList setEnabled:YES];
	if (title) {
		[[[self contentView] findViewWithTag:NX_PPTITLEFIELD] setStringValue:title];
	} else {
		[[[self contentView] findViewWithTag:NX_PPTITLEFIELD] setStringValue:"Drucken"];
	}
	[super runModal];
	//	[NXApp runModalFor:self];
	[self writePrintInfo];
	printStrict = NO;
	if (title) {
		free(title);
		title = NULL;
	}
	countCopies = 1;
	return pickedTag;
}

- display
{
	[preview setEnabled:!printStrict];
	[save setEnabled:!printStrict];
	[[buttons findCellWithTag:NX_FAXTAG] setEnabled:!printStrict];
	[[copies setIntValue:(countCopies)? countCopies:1] setEnabled:!printStrict];
	return [super display];
}

- pickedButton:sender
{
	pickedTag= [sender tag];
//	DEBUG1("PickedTag in DartPrintPanel:%d\n",pickedTag);
	return [super pickedButton:sender];
}

- setPrintStrict:(BOOL)flag
{
	printStrict = flag;
	return self;
}

- (BOOL)printStrict
{
	return printStrict;
}

- setTitle:(const char *)theTitle
{
	if (title) {
		free(title);
		title = NULL;
	}
	title = malloc(strlen(theTitle)+1);
	strcpy(title,theTitle);
	return self;
}

- (const char *)title
{
	return title;
}

- free
{
	if (title) {
		free(title);
		title = NULL;
	}
	return [super free];
}

- setCountCopies:(int)anzCopies
{
	countCopies = anzCopies;
	return self;
}

- (int)countCopies
{
	return countCopies;
}

- (BOOL)wasReallySentToPrinter
{
	return ((NX_OKTAG == pickedTag) || (NX_FAXTAG == pickedTag));
}

@end
