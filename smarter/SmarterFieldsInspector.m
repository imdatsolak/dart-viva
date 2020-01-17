#import <appkit/Application.h>
#import <appkit/TextFieldCell.h>
#import <appkit/TextField.h>
#import <appkit/Matrix.h>
#import <appkit/PopUpList.h>
#import <appkit/Window.h>
#import <appkit/Text.h>

#import "SmarterFields.h"
#import "SmarterTFCell.h"

#import "SmarterFieldsInspector.h"

@implementation SmarterFieldsInspector

+ finishLoading:(struct mach_header *) hdr 
{
    NIBDidLoadClass(self, hdr);
    return nil;
}

+ startUnloading
{
    NIBWillUnloadClass(self);
    return nil;
}

- init
{
    [super init];
    [NXApp loadNibSection:"SmarterFieldsInspector.nib" owner:self];
	currentView = nil;
	currentViewsOwner = nil;
    return self;
}

- enterPressed:sender
{
	return [self performClick:sender];
}

- ok:sender
{
    int	t;

    [[NXApp mainWindow] makeFirstResponder:[NXApp mainWindow]];
    [window endEditingFor:self];

    if ((t = [[backGrayMatrix selectedCell] tag]) == 0) {
		[object setBackgroundGray:-1.0];
    } else {
		[object setBackgroundGray:(t - 1) / 3.0];
    }

    [object setTextGray:[[textGrayMatrix selectedCell] tag] / 3.0];

    if ((t = [[borderMatrix selectedCell] tag]) == 0) {
		[object setBezeled:NO];
		[object setBordered:NO];
    } else if (t == 1) {
		[object setBordered:NO];
		[object setBezeled:YES];
    } else {
		[object setBezeled:NO];
		[object setBordered:YES];
    }

    if ((t = [[alignMatrix selectedCell] tag]) == 0) {
		[object setAlignment:NX_LEFTALIGNED];
    } else if (t == 1) {
		[object setAlignment:NX_CENTERED];
    } else {
		[object setAlignment:NX_RIGHTALIGNED];
    }
	
	if ([selectable state]) {
		if ([editable state]) {
			[object setEditable:YES];
			[[selectable setState:1] setEnabled:NO];
		} else {
			[object setEditable:NO];
			[object setSelectable:YES];
			[selectable setEnabled:YES];
		}
	} else {
		if ([editable state]) {
			[[selectable setState:1] setEnabled:NO];
			[object setSelectable:YES];
			[object setEditable:YES];
		} else {
			[selectable setEnabled:YES];
			[object setSelectable:NO];
			[object setEditable:NO];
		}
	}
	[[object cell] setScrollable:[scrollable state]==1];
	[self readSelection];
	[super ok:sender];
	return self;

}


- readSelection
{
	switch ([[[[dataTypeButton target] itemList] selectedCell] tag]) {
		case	6666:
			[self readOutAlphaNumeric];
			break;
		case	6667:
			[self readOutAlpha];
			break;
		case	6668:
			[self readOutNumeric];
			break;
		case	6669:
			[self readOutFloat];
			break;
		case	6670:
			[self readOutCurrency];
			break;
		case	6671:
			[self readOutDate];
			break;
		default:
			break;
	}
	return self;
}

- readOutAlphaNumeric
{
	[object setFieldType:SMTFC_ALNUM];
	[object setAlnumMinLength:[alnumMinField intValue]];
	[object setAlnumMaxLength:[alnumMaxField intValue]];
	return self;
}

- readOutAlpha
{
	[object setFieldType:SMTFC_ALPHA];
	[object setAlphaMinLength:[alphaMinField intValue]];
	[object setAlphaMaxLength:[alphaMaxField intValue]];
	[object setAlphaIsName:[alphaNameSwitch state]];
	return self;
}

- readOutNumeric
{
	[object setFieldType:SMTFC_NUMERIC];
	[object setNumericMinValue:[numericMinField intValue]];
	[object setNumericMaxValue:[numericMaxField intValue]];
	return self;
}

- readOutFloat
{
	[object setFieldType:SMTFC_FLOAT];
	[object setDoubleMinValue:[floatMinField doubleValue]];
	[object setDoubleMaxValue:[floatMaxField doubleValue]];
	return self;
}

- readOutCurrency
{
	[object setFieldType:SMTFC_CURRENCY];
	[object setCurrencyMinValue:[currencyMinField doubleValue]];
	[object setCurrencyMaxValue:[currencyMaxField doubleValue]];
	[object setCurrencyDecimalDelimiter:[currencyDecimalField stringValue][0]];
	[object setCurrencyThousandsDelimiter:[currencyThousandsField stringValue][0]];
	[object setCurrencyShowType:[[currencyDisplayMatrix selectedCell] tag]+1];
	return self;
}

- readOutDate
{
	[object setFieldType:SMTFC_DATE];
	[object setDateKind:[[dateKindMatrix selectedCell] tag]+1];
	[object setDateDelimiter:[dateDelimiter stringValue][0]];
	return self;
}

- revert:sender
{
    [window endEditingFor:self];

    if ([object backgroundGray] < 0.0) {
		[backGrayMatrix selectCellAt:0 :0];
    } else {
		[backGrayMatrix selectCellAt:0 :([object backgroundGray] * 3.0) + 1];
    }
    	[textGrayMatrix selectCellAt:0 :([object textGray] * 3.0)];

    if ([object isBordered]) {
		[borderMatrix selectCellAt:0 :2];
    } else if ([object isBezeled]) {
		[borderMatrix selectCellAt:0 :1];
    } else {
		[borderMatrix selectCellAt:0 :0];
    }

    if ([object alignment] == NX_LEFTALIGNED) {
		[alignMatrix selectCellAt:0 :0];
    } else if ([object alignment] == NX_CENTERED) {
		[alignMatrix selectCellAt:0 :1];
    } else if ([object alignment] == NX_RIGHTALIGNED) {
		[alignMatrix selectCellAt:0 :2];
    }

	[editable setState:([object isEditable])? 1:0];
	if ([object isEditable]) {
		[[selectable setState:1] setEnabled:NO];
	} else {
		[[selectable setState:([object isSelectable])? 1:0] setEnabled:YES];
	}
	[scrollable setState:([[object cell] isScrollable])? 1:0];
	[self revertSelection];
	[super revert:sender];
	return self;
}

- revertSelection
{
 	switch([object fieldType]) {
		case SMTFC_ALNUM:	
			[[[dataTypeButton target] itemList] selectCellWithTag:6666];
			break;
		case SMTFC_ALPHA:
			[[[dataTypeButton target] itemList] selectCellWithTag:6667];
			break;
		case SMTFC_NUMERIC:
			[[[dataTypeButton target] itemList] selectCellWithTag:6668];
			break;
		case SMTFC_FLOAT:
			[[[dataTypeButton target] itemList] selectCellWithTag:6669];
			break;
		case SMTFC_CURRENCY:
			[[[dataTypeButton target] itemList] selectCellWithTag:6670];
			break;
		case SMTFC_DATE:
			[[[dataTypeButton target] itemList] selectCellWithTag:6671];
			break;
		default: 
			[[[dataTypeButton target] itemList] selectCellWithTag:6666];
			break;
	}
	[dataTypeButton setTitle:[[[[dataTypeButton target] itemList] selectedCell] title]];
	[self dataTypePopupClicked:[[dataTypeButton target] itemList]];
	return self;
}


- optionsMatrixClicked:sender
{
	if ([editable state]) {
		[[selectable setEnabled:NO] setState:1];
	} else {
		[selectable setEnabled:YES];
	}
    return self;
}

- dataTypePopupClicked:sender
{
	switch ([[sender selectedCell] tag]) {
		case 6666:	
			[self alphaNumSelected]; 
			break;
		case 6667:	
			[self alphaSelected];
			break;
		case 6668:	
			[self numericSelected]; 
			break;
		case 6669:	
			[self floatSelected];
			break;
		case 6670:	
			[self currencySelected]; 
			break;
		case 6671:	
			[self dateSelected]; 
			break;
		default:	
			break;
	}
	return self;
}


- alphaNumSelected
{
	[self replaceCurrentViewWith:alnumGroup];
	[alnumMinField setIntValue:[object alnumMinLength]];
	[alnumMaxField setIntValue:[object alnumMaxLength]];
	return self;
}

- alphaSelected
{
	[self replaceCurrentViewWith:alphaGroup];
	[alphaMinField setIntValue:[object alphaMinLength]];
	[alphaMaxField setIntValue:[object alphaMaxLength]];
	[alphaNameSwitch setState:[object alphaIsName]];
	return self;
}

- numericSelected
{
	[self replaceCurrentViewWith:numericGroup];
	[numericMinField setIntValue:[object numericMinValue]];
	[numericMaxField setIntValue:[object numericMaxValue]];
	return self;
}


- floatSelected
{
	[self replaceCurrentViewWith:floatGroup];
	[floatMinField setDoubleValue:[object doubleMinValue]];
	[floatMaxField setDoubleValue:[object doubleMaxValue]];
	return self;
}

- currencySelected
{
	char del[2];
	[self replaceCurrentViewWith:currencyGroup];
	[currencyMinField setDoubleValue:[object currencyMinValue]];
	[currencyMaxField setDoubleValue:[object currencyMaxValue]];
	sprintf(del,"%c",[object currencyDecimalDelimiter]);
	[currencyDecimalField setStringValue:del];
	sprintf(del,"%c",[object currencyThousandsDelimiter]);
	[currencyThousandsField setStringValue:del];
	[currencyDisplayMatrix selectCellWithTag:[object currencyShowType]-1];
	return self;
}

- dateSelected
{
	char del[2];
	[self replaceCurrentViewWith:dateGroup];
	[dateKindMatrix selectCellWithTag:[object dateKind]-1];
	sprintf(del,"%c",[object dateDelimiter]);
	[dateDelimiter setStringValue:del];
	return self;
}

- replaceCurrentViewWith:destView
{
	if (currentView) {
		[currentView removeFromSuperview];
		[currentViewsOwner addSubview:currentView];
	}
	currentView = destView;
	[currentView removeFromSuperview];
	[inspectorMainGroup addSubview:currentView];
	[inspectorMainGroup display];
	return self;
}

@end
