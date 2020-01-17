#import <stdlib.h>
#import <strings.h>
#import <appkit/PopUpList.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/SortList.h"

#import "StringManager.h"
#import "TableManager.h"
#import "TableEditor.h"
#import "TheApp.h"

#import "CustomPopupButton.h"

#pragma .h #import <appkit/Button.h>

@implementation CustomPopupButton:Button
{
	id		entryList;
	char	*tableName;
	id		popup;
	id		delegate;
	BOOL	expandablePopup;
}

- initFrame:(const NXRect *)frameRect title:(const char *)aString tag:(int)anInt target:anObject action:(SEL)aSelector key:(unsigned short)charCode enabled:(BOOL)flag
{
	[super initFrame:frameRect title:aString tag:anInt target:anObject action:aSelector key:charCode enabled:flag];	
	[[NXApp popupMgr] registerCustomPopup:self];
	tableName = NULL;
	return self;
}

- setTableName:(const char *)tblName expandable:(BOOL)flag
{
	tableName = malloc(strlen(tblName)+1);
	strcpy(tableName,tblName);
	popup = [[PopUpList alloc] init];
	[self setTarget:popup];
	[self setAction:@selector(popUp:)];
	NXAttachPopUpList(self, popup);
	expandablePopup = flag;
	[self update];
	
	return self;
}
	
- (const char *)tableName
{
	[self setNewTableIfNecessary];
	return tableName;
}

- entryAsString:entry
{
	id aString =nil;
	
	if ([entry class] == [Integer class])  {
		aString = [entry copyAsString];
	} else if ([entry class] == [Double class]) {
		aString = [entry copyAsStringWidth:5 decimal:2];
	} else if ([entry class] == [String class]) {
		aString = [String str:[entry str]];
	}
	return aString;
}

- removeAllPopupEntries
{
	int i;
	for (i=[popup count]-1;i>=0;i--) {
		[popup removeItemAt:i];
	}
	return self;
}


- tableChanged:(const char *)aTableName
{
	if (strcmp([self tableName], aTableName)==0) {
		[self update];
	}
	return self;
}


- update
{
	int	i;
	id	aString;
	id	lastTitle = nil;
	
	if (entryList) {
		int	lastIntV=0;
		lastIntV = [[[popup target] selectedCell] tag];
		lastTitle = [[[entryList objectAt:lastIntV] objectAt:1] copy];
		[entryList free];
	}
	
	entryList = [[[NXApp popupMgr] tableFor:[self tableName]] copy];
	if ((entryList) && ([entryList count])) {
		[self removeAllPopupEntries];
		
		for (i=0;i<[entryList count];i++) {
			aString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
			if (aString) {
				[[[[popup addItem:[aString str]]
					setTarget:self] 
					setAction:@selector(itemSelected:)]
					setTag:i];
				[aString free];
			}
		}
	} else {
		[super setTitle:""];
		[self removeAllPopupEntries];
	}
	if (expandablePopup) {
		[[[popup addItem:
				[[NXApp stringMgr] stringFor:"EXPANDPOPUP"]] setTarget:self] setAction:@selector(addANewItem:)];
	}
	[popup display];
	if (lastTitle != nil) {
		[self setTitle:[lastTitle str]];
		[lastTitle free];
	}
	return self;
}

	
- addANewItem:sender 
{
	id theEditor = [[[TableEditor alloc] init] editTable:[self tableName]];
	if (theEditor) {
		[theEditor free];
		[self setIntValue:[self intValue]];
	}
	return self;
}


- setIntValue:(int )aValue
{
	int		i;
	id		aString;
	char	aValueStr[32];
	
	sprintf(aValueStr,"%d",aValue);
	[self setNewTableIfNecessary];
	DEBUG("CustomPopupButton(%s):setIntValue: %d\n", NXGetObjectName(self), aValue);
	for (i=0;i<[entryList count];i++) {
		id	aKey = [[entryList objectAt:i] objectAt:0];
		BOOL fnd = NO;
		
		if ([aKey isKindOf:[Integer class]]) {
			fnd = [aKey compareInt:aValue] == 0;
		} else if ([aKey isKindOf:[String class]]) {
			fnd = [aKey compareSTR:aValueStr] == 0;
		} else if ([aKey isKindOf:[Double class]]) {
			fnd = [aKey compareDouble:aValue];
		}
		
		if (fnd) {
			aString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
			if (aString) {
				[super setTitle:[aString str]];
				[aString free];
			} else {
				[super setTitle:""];
			}
			break;
		}
	}
	return self;
}

- sendCDC:sender
{
	if ([delegate respondsTo:@selector(controlDidChange:)]) 
		[delegate controlDidChange:self];
	return self;
}

- setTitle:(const char *)aTitle
{
	int	i;
	id	aString;
	id	bString;
	id	cString;
	
	[self setNewTableIfNecessary];
	cString = [String str:""];
	if ([self title] != NULL) {
		[cString str:[self title]];
	}
	for (i=0;i<[entryList count];i++) {
		bString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
		if (bString) {
			if ([bString compareSTR:aTitle] == 0 ) {
				aString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
				if (aString) {
					[super setTitle:[aString str]];
					[aString free];
				} else {
					[super setTitle:""];
				}
				if ([cString compareSTR:aTitle] != 0) {
					[self perform:@selector(sendCDC:) with:self afterDelay:1 cancelPrevious:YES];
				}
				break;
			}
			[bString free];
		}
	}
	[cString free];
	return self;
}

- (const char *)titleForInt:(int)aValue
{
	static char string[256];
	int	i;
	id	aString;
	
	[self setNewTableIfNecessary];
	for (i=0;i<[entryList count];i++) {
		if ([[[entryList objectAt:i] objectAt:0] compareInt:aValue] == 0 ) {
			aString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
			if (aString) {
				strcpy(string,[aString str]);
				[aString free];
			} else {
				sprintf(string,"");
			}
			return string;
		}
	}
	return "";
}

- setStringValue:(const char *)aValue
{
	int		i;
	id		aString;
	int		aValueInt;
	
	aValueInt = atoi(aValue);
	[self setNewTableIfNecessary];
	DEBUG("CustomPopupButton(%s):setIntValue: %d\n", NXGetObjectName(self), aValue);
	for (i=0;i<[entryList count];i++) {
		id	aKey = [[entryList objectAt:i] objectAt:0];
		BOOL fnd = NO;
		
		if ([aKey isKindOf:[Integer class]]) {
			fnd = [aKey compareInt:aValueInt] == 0;
		} else if ([aKey isKindOf:[String class]]) {
			fnd = [aKey compareSTR:aValue] == 0;
		} else if ([aKey isKindOf:[Double class]]) {
			fnd = [aKey compareDouble:aValueInt];
		}
		
		if (fnd) {
			aString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
			if (aString) {
				[super setTitle:[aString str]];
				[aString free];
			} else {
				[super setTitle:""];
			}
			break;
		}
	}
	return self;
}
	
- (const char *)stringValue
{
	int			i;
	static	char	mySTR[128];
	id			bString;
	char		currTitle[512];
	
	sprintf(currTitle,"%s",[super title]);
	sprintf(mySTR,"");
	[self setNewTableIfNecessary];
	for (i=0;i<[entryList count];i++) {
		bString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
		if (bString) {
			if ([bString compareSTR:currTitle] == 0 ) {
				if ([[[entryList objectAt:i] objectAt:0] respondsTo:@selector(str)]) {
					sprintf(mySTR,"%s",[[[entryList objectAt:i] objectAt:0] str]);
				}
				break;
			}
			[bString free];
		}
	}
	return mySTR;
}


- setDelegate:anObject
{
	delegate = anObject;
	return self;
}

- delegate
{
	return delegate;
}

- free 
{
	if (tableName)
		free(tableName);
	if (popup)
		[popup free];
	if (entryList)
		[entryList free];
	[[NXApp popupMgr] unregisterCustomPopup:self];
	return [super free];
}

- itemSelected:sender
{
	int		oldVal;
	oldVal = [self intValue];
	if (oldVal != [[sender selectedCell] tag]) {
//		if ([delegate respondsTo:@selector(controlDidChange:)]) 
//			[delegate controlDidChange:self];
	}
	return self;
}

- (int)intValue	
{
	int	i;
	id	bString;
	int	myInt = 0;
	char	currTitle[512];
	
	sprintf(currTitle,"%s",[super title]);
	
	[self setNewTableIfNecessary];
	for (i=0;i<[entryList count];i++) {
		bString = [self entryAsString:[[entryList objectAt:i] objectAt:1]];
		if (bString) {
			if ([bString compareSTR:currTitle] == 0 ) {
				if ([[[entryList objectAt:i] objectAt:0] respondsTo:@selector(int)]) {
					myInt = [[[entryList objectAt:i] objectAt:0] int];
				}
				break;
			}
			[bString free];
		}
	}
	return myInt;
}


- setNewTableIfNecessary
{
	char	*tblName, *expStr, *str;
	BOOL	expandable;
	
	if (!tableName) {
		str = malloc(strlen(NXGetObjectName(self))+8);
		strcpy(str,NXGetObjectName(self));
		
		tblName = strtok(str," ");
		expStr = strtok(NULL," ");
		expandable = expStr && *expStr=='Y';
		
		[self setTableName:tblName expandable:expandable];
	}
	return self;
}

- drawSelf:(NXRect *)rects :(int) count
{
	[self setNewTableIfNecessary];
	[super drawSelf:rects :count];
	return self;

}
@end
