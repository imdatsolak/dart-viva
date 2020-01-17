#import <dpsclient/wraps.h>
#import <streams/streams.h>
#import <appkit/Font.h>
#import <appkit/Text.h>

#import "dart/debug.h"
#import "dart/String.h"

#import "ProtectedValueCell.h"

#pragma .h #import <appkit/Cell.h>

@implementation ProtectedValueCell:Cell
{
	id	mySubView;
}

- readRichText:(NXStream *)stream forView:view
{
	char		c;
	int			brOpen=0;
	BOOL		final = NO;
	NXStream	*txtStream = NXOpenMemory(NULL, 0, NX_READWRITE);

	[self sendActionOn: 0];
	[self setType: NX_TEXTCELL];
	while (!NXAtEOS(stream) && !final && (brOpen >= 0)) {
		NXRead(stream, &c, 1);
		if (c=='}') {
			brOpen--;
			final = brOpen == 0;
		}
		if (brOpen >= 1) {
			NXWrite(txtStream, &c, 1);
		}
		if (c=='{') brOpen++;
	}
	if (!mySubView) {
		NXRect aFrame = {{0,0},{100,100}};
		mySubView = [[Text alloc] initFrame:&aFrame];
		[[[mySubView setVertResizable:NO] setHorizResizable:YES] setMonoFont:NO];
	}
	NXSeek(txtStream, 0, NX_FROMSTART);
	[mySubView setSel:0 :[mySubView textLength]];
	[mySubView replaceSelWithRichText:txtStream];
	NXCloseMemory(txtStream, NX_FREEBUFFER);
	return self;
}

- free
{
	if (mySubView) {
		mySubView = [mySubView free];
	}
	return [super free];
}

- writeRichText:(NXStream *)stream forView:view
{
	NXPrintf(stream, " {");
	[mySubView writeRichText:stream];
	NXPrintf(stream, "} ");
	return self;
}

- calcCellSize:(NXSize *)theSize
{
//	NXCoord width;
//	NXCoord	height;
	id		fontObj;
	NXCoord	ascender, descender, lineHeight;
	id		aString = [[String str:""] readFromText:mySubView];
	[self setStringValue:[aString str]];
	[aString free];
	DEBUG7("Working in ProtectedCell...");
//	[mySubView calcLine];
	fontObj = [mySubView font];
	NXTextFontInfo(fontObj, &ascender, &descender, &lineHeight);

//	[mySubView getMinWidth:&width 
//			   minHeight:&height 
//			   maxWidth:10000000.0 
//			   maxHeight:[fontObj pointSize]+8];
//	height -= 8.0;
	theSize->width = [fontObj getWidthOf:[self stringValue]] + [fontObj getWidthOf:"W"];
	theSize->height = lineHeight; // height;
	DEBUG7("calcCellSize:font: %s\n",[fontObj name]);
	DEBUG7("            :asc:%f desc:%f lh:%f\n", ascender, descender, lineHeight);
	DEBUG7("            :newSize.h:%f .w:%f\n", theSize->height, theSize->width);
	return self;
}
/*
- drawInside:(const NXRect *)rect inView:view
{
	NXCoord	ascender, descender, lineHeight;
	id		fontObj = [mySubView font];
	NXRect	theRect = *rect;
	
	NXTextFontInfo(fontObj, &ascender, &descender, &lineHeight);
	theRect.size.width = [fontObj getWidthOf:[self stringValue]] + [fontObj getWidthOf:"W"];
	theRect.origin.y += descender; //(descender/3.0);
	[mySubView removeFromSuperview];
	[mySubView setFrame:&theRect];
	[view addSubview:mySubView];
	[mySubView display];
	[mySubView removeFromSuperview];
	
	return self;
}
*/
- drawInside:(const NXRect *)rect inView:view
{
	NXCoord	ascender, descender, lineHeight;
	id		fontObj = [mySubView font];
	NXRect	theRect = *rect;
	
	NXTextFontInfo(fontObj, &ascender, &descender, &lineHeight);
	theRect.origin.y += (descender/3.0);
//	[mySubView removeFromSuperview];
//	[mySubView setFrame:&theRect];
//	[view addSubview:mySubView];
//	[mySubView display];
//	[mySubView removeFromSuperview];
	[super drawInside:rect inView:view];
	
	return self;
}
	

	
@end
