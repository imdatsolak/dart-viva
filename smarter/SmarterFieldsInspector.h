#import <nib/InterfaceBuilder.h>

@interface SmarterFieldsInspector:Inspector
{
    id	alignMatrix;
    id	textGrayMatrix;
    id	borderMatrix;
    id	backGrayMatrix;
	id	optionsMatrix;
	
	id	dataTypeButton;
	id	inspectorMainGroup;

	id	alnumGroup;
	id	alnumMinField;
	id	alnumMaxField;
	
	id	alphaGroup;
	id	alphaMinField;
	id	alphaMaxField;
	id	alphaNameSwitch;
	
	id	numericGroup;
	id	numericMinField;
	id	numericMaxField;
	
	id	floatGroup;
	id	floatMinField;
	id	floatMaxField;
	
	id	currencyGroup;
	id	currencyMinField;
	id	currencyMaxField;
	id	currencyDecimalField;
	id	currencyThousandsField;
	id	currencyDisplayMatrix;
	
	id	dateGroup;
	id	dateKindMatrix;
	id	dateDelimiter;
	
	id	editable;
	id	selectable;
	id	scrollable;
	
	id	currentView;
	id	currentViewsOwner;
}

+ finishLoading:(struct mach_header *) hdr ;
+ startUnloading;
- init;
- enterPressed:sender;
- ok:sender;
- readSelection;
- readOutAlphaNumeric;
- readOutAlpha;
- readOutNumeric;
- readOutFloat;
- readOutCurrency;
- readOutDate;
- revert:sender;
- revertSelection;
- optionsMatrixClicked:sender;
- dataTypePopupClicked:sender;
- alphaNumSelected;
- alphaSelected;
- numericSelected;
- floatSelected;
- currencySelected;
- dateSelected;
- replaceCurrentViewWith:destView;
@end
