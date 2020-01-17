#import <appkit/TextField.h>
#import <appkit/Form.h>
#import <appkit/PrintInfo.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "DefaultsDatabase.h"

#import "DartPageLayout.h"

#pragma .h #import <appkit/PageLayout.h>

@implementation DartPageLayout:PageLayout
{
	id left;
	id right;
	id top;
	id bottom;
}

- setMarginView:anObject
{
	left = [anObject findViewWithTag:5000];
	right= [anObject findViewWithTag:5001];
	top  = [anObject findViewWithTag:5002];
	bottom=[anObject findViewWithTag:5003];
	[scale setNextText:left];
	[[left setTarget:ok] setAction:@selector(performClick:)];
	[[right setTarget:ok] setAction:@selector(performClick:)];
	[[top setTarget:ok] setAction:@selector(performClick:)];
	[[bottom setTarget:ok] setAction:@selector(performClick:)];
	[bottom setNextText:width];
	return self;
}

- pickedUnits:sender
{
    float old, new;

    [self convertOldFactor:&old newFactor:&new];
	[[left setFloatValue:([left floatValue] * new / old)] display];
	[[right setFloatValue:([right floatValue] * new / old)] display];
	[[top setFloatValue:([top floatValue] * new / old)] display];
	[[bottom setFloatValue:([bottom floatValue] * new / old)] display];

    return [super pickedUnits:sender];
}

- writePrintInfo
{
    float old, new;
	NXCoord	leftMargin, rightMargin, topMargin, bottomMargin;
	const NXRect *aRect;
	id	anObject = [Double double:0.0];
	
	[super writePrintInfo];
    [self convertOldFactor:&old newFactor:&new];
	aRect = [[NXApp printInfo] paperRect];
	leftMargin = [left floatValue] / old;
	rightMargin =([right floatValue] / old);
	topMargin = [top floatValue] / old;
	bottomMargin =([bottom floatValue] / old);
	DEBUG2("writePrintInfo:left:%lf right:%lf top:%lf bottom:%lf\n",
			leftMargin, rightMargin, topMargin, bottomMargin);

	[[NXApp printInfo] setMarginLeft:0 right:0 top:topMargin bottom:bottomMargin];
	[anObject setDouble:leftMargin];
	[[NXApp defaultsDB] setValue:anObject forKey:"LeftMargin"];
	[anObject setDouble:rightMargin];
	[[NXApp defaultsDB] setValue:anObject forKey:"RightMargin"];
	[anObject setDouble:topMargin];
	[[NXApp defaultsDB] setValue:anObject forKey:"TopMargin"];
	[anObject setDouble:bottomMargin];
	[[NXApp defaultsDB] setValue:anObject forKey:"BottomMargin"];
	[anObject free];
	anObject = [String str:[[NXApp printInfo] paperType]];
	[[NXApp defaultsDB] setValue:anObject forKey:"PaperType"];
	[anObject free];
	return self;
}

- display
{
    float old, new;
	id	aValue;
    [self convertOldFactor:&old newFactor:&new];
	aValue = [[NXApp defaultsDB] valueForKey:"LeftMargin"];
	if (aValue != nil) 	[[left setFloatValue:([aValue double] * old)] display];
	aValue = [[NXApp defaultsDB] valueForKey:"RightMargin"];
	if (aValue != nil) 	[[right setFloatValue:([aValue double] * old)] display];
	aValue = [[NXApp defaultsDB] valueForKey:"TopMargin"];
	if (aValue != nil) 	[[top setFloatValue:([aValue double] * old)] display];
	aValue = [[NXApp defaultsDB] valueForKey:"BottomMargin"];
	if (aValue != nil) 	[[bottom setFloatValue:([aValue double] * old)] display];
	aValue = [[NXApp defaultsDB] valueForKey:"PaperType"];
	if (aValue != nil) 	[[NXApp printInfo] setPaperType:[aValue str] andAdjust:YES];
    return [super display];
}

@end
