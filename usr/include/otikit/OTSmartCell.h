/*
  File: OTSmartCell.h
  Authors: Alex B. Cone
  Modification History:
  
  Created ?? 2.0 version: 12/19/90
  
  Copyright (c) 1990 Objective Technologies, Inc.
  All Rights Reserved.
*/

#import <dpsclient/dpsclient.h>
#import <appkit/TextFieldCell.h>

#define OTSMARTCELL_CURRENT_VERSION 11

/* format - type == SF_DATE */
#ifndef DATEFMTS
#define	SF_MMDDYYYY		0
#define	SF_MMDDYY		1
#define	SF_YYYYMMDD		2
#define	SF_YYMMDD		3
#define	SF_MAXDATEFMT	3
#define SF_DATEFMTS
#endif

/* case flag */
#define SF_NOFORCECASE	0
#define SF_FORCEUP		1
#define SF_FORCEDOWN	2

#define SF_BASETEXT		0
#define SF_ALPHA		1
#define SF_ALPHANUM		2
#define SF_NUMERIC		3
#define SF_INT			4
#define SF_FLOAT		5
#define SF_DATE			6
#define SF_REGEX		7
#define SF_MONEY		8
#define SF_MAXTYPE		9

#define SF_MINDURATION	0.25
#define SF_MAXDURATION	15.0

/* errors */
#define SF_BADKEYSTROKE		1
#define SF_BADENTRY			2
#define SF_BADRANGE			3
#define SF_BADLIST			4
#define SF_BADREGEX			5
#define SF_BADDATE			6
#define SF_BADDAY			7
#define SF_BADMONTH			8
#define SF_BADYEAR			9
#define SF_BADPASTE			10
#define SF_BADMALLOC		11
#define SF_BADLENMIN		12
#define SF_BADLENMAX		13
#define SF_MAXERRNUM		13

#define SF_BADKEYMSG		"Invalid character in entry."
#define SF_BADENTRYMSG		"Invalid entry."
#define SF_BADRANGEMSG		"Entry out of range."
#define SF_BADLISTMSG		"Entry is not in list of valid values."
#define SF_BADREGEXMSG		"Entry does not match required pattern."
#define SF_BADDATEMSG		"Invalid date."
#define SF_BADDAYMSG		"Invalid day."
#define SF_BADMONTHMSG		"Invalid month."
#define SF_BADYEARMSG		"Invalid year."
#define SF_BADPASTEMSG		"Invalid paste."
#define SF_BADMALLOCMSG		"Memory allocation error."
#define SF_BADLENMINMSG		"Entry shorter than minimum length."
#define SF_BADLENMAXMSG		"Entry longer than maximum length."


@interface OTSmartCell:TextFieldCell
{
/* field type */
	int		fieldType;

/* error/alert delegate */
	id		errorDelegate;
	
/* bad entry alert info... */
	BOOL	alertPanel;
	BOOL	alertSound;
	BOOL	useSystemBeep;
	id		sound;

/* field value change alert info... */
	BOOL	alertOn;
	BOOL	blinkOn;
	BOOL	reverseOn;
	BOOL	isReversed;
	double	blinkInterval;
	double	duration;
	DPSTimedEntry teNum;
	BOOL	alertActive;
	
/* formatting info... */
	BOOL	formatInput;
	int		dateFormat;
	BOOL	useSeparator;
	char	separator;
	char	decimal;
	int		caseFlag;
	int		maxChars;
	int		minChars;
	BOOL	roundFlag;

/* range info... */
	id		rangeList;
	BOOL	rangeIsOn;
	BOOL	rangeIsList;
	id		regexStr;

/* dirty flag - field has changed since entry, cleared on succesful tab */
	BOOL	dirty;
	int		lastSize;
}
/* factory methods */
+ initialize;

- init;
- initTextCell;
- initTextCell:(const char *)aString;

- free;
- copy;
/* used to obtain the control view & to become the text object's delegate */
- edit:(const NXRect*)aRect inView:controlView editor:textObj delegate:anObject event:(NXEvent *)theEvent;

/* the Error Delegate */
- setErrorDelegate:aDelegate;
- errorDelegate;
- (const char *)strerror:(int)errorNum;

/* bad entry handling */
- (BOOL) errorDidOccur:(int)errorNum from:anObject;
- showError:(const char *)errorMessage;

- (BOOL)alertPanelOn;
- setAlertPanelOn:(BOOL)yesOrNo;
- (BOOL)alertSoundOn;
- setAlertSoundOn:(BOOL)yesOrNo;
- (BOOL)beepOn;
- setBeepOn:(BOOL)yesOrNo;
- sound;
- setSound:aSound;

/* field value change handling */
- (BOOL)changeAlertOn;
- setChangeAlertOn:(BOOL)yesOrNo;
- setBlinkOn:(BOOL)yesOrNo;
- (BOOL)blinkOn;
- setReverseOn:(BOOL)yesOrNo;
- (BOOL)reverseOn;
- setBlinkInterval:(double)aRate;
- (double)blinkInterval;
- setDuration:(double)numSeconds;
- (double)duration;
- (BOOL)alertActive;

- turnChangeAlertOff;
- turnChangeAlertOn;
- controlDidChange:sender;

/* field type flag */
- setFieldType:(int)aType;
- (int)fieldType;

/* date format flag */
- (int)dateFormat;
- setDateFormat:(int)aFlag;

/* subfield separator */
- (BOOL)separatorUsed;
- setSeparatorUsed:(BOOL)yesOrNo;
- (char)separator;
- setSeparator:(char)aChar;
- (char)decimal;
- setDecimal:(char)aChar;

/* case flag */
- (int)caseFlag;
- setCaseFlag:(int)aFlag;

/* max & min chars */
- setMaxChars:(int)aLength;
- (int)maxChars;
- setMinChars:(int)aLength;
- (int)minChars;

/* range handling */
- (BOOL)rangeIsOn;
- setRangeIsOn:(BOOL)yesOrNo;
- setRangeIsList:(BOOL)yesOrNo;
- (BOOL)rangeIsList;
- (BOOL)rangeIsRange;
- setRangeLow:(const char *)low andHigh:(const char *)high;
- (const char *)rangeLow;
- (const char *)rangeHigh;
- (const char *)rangeStringValueAt:(int)index;
- addValidValue:(const char *)aString;
- (int)rangecmp:(const char *)string1 :(const char *)string2;
- rangeList;

/* regular expression functions */
- setRegexPattern:(const char *)aString;
- (const char*)regexPattern;

- setFixedPointOn:(BOOL)yesOrNo;
- (BOOL)fixedPoint;
- setFloatingPointPrecision:(int)rightDigits;
- (int)floatingPointPrecision;
- setRounding:(BOOL)yesOrNo;
- (BOOL)rounding;

- setFloatingPointFormat:(BOOL)autoRange left:(unsigned)leftDigits right:(unsigned)rightDigits;
- getFloatingPointFormat:(BOOL *)autoRange left:(unsigned *)leftDigits right:(unsigned *)rightDigits;

/* special date functions */
- (long)dateValue;
- (long)dateValueInFormat:(int)aFlag;
- (const char *)stringValueInFormat:(int)aFlag withSep:(int)aSep;
- setDateValue:(long)aDate inFormat:(int)aFlag;
- setDateValue:(long)aMonth :(long)aDay :(long)aYear;

/* entry processing */
/* text delegate methods...  */
- text:textObject isEmpty:(BOOL)flag;
- (BOOL)textWillEnd:textObject;
- (BOOL)textWillChange:textObject;

/* is current contents valid?  */
- (BOOL)isValid;

/* archiving methods */
- write:(NXTypedStream *) s;
- read:(NXTypedStream *) s;

/* overload cell's methods */
- setDoubleValue:(double)aValue;
- setFloatValue:(float)aValue;
- setIntValue:(int)aValue;
- setStringValue:(const char *)aString;
- (int)intValue;
- (float)floatValue;
- (double)doubleValue;

/* the Inspector General */
- (const char*)inspectorName;

@end


