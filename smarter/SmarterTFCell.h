#import <appkit/TextFieldCell.h>
#import <appkit/Text.h>

#define	SMTFC_ALNUM		1
#define	SMTFC_ALPHA		2
#define	SMTFC_NUMERIC	3
#define	SMTFC_FLOAT		4
#define	SMTFC_CURRENCY	5
#define	SMTFC_DATE		6

#define SMTFC_DT_DDMMYY		1
#define SMTFC_DT_DDMMYYYY	2
#define SMTFC_DT_MMDDYY		3
#define SMTFC_DT_MMDDYYYY	4

#define SMTFC_CT_VVVVDVV	1
#define SMTFC_CT_VTVVVDVV	2

@interface SmarterTFCell:TextFieldCell
{
	NXTextFilterFunc oldTextFilter;
	int		fieldType;

	int		alnumMinLength;
	int		alnumMaxLength;

	int		alphaMinLength;
	int		alphaMaxLength;
	int		alphaIsName;
	
	int		numericMinValue;
	int		numericMaxValue;
	
	double	doubleMinValue;
	double	doubleMaxValue;
	
	double	currencyMinValue;
	double	currencyMaxValue;
	char	currencyDecimalDelimiter;
	char	currencyThousandsDelimiter;
	int		currencyShowType;
	
	int		dateKind;
	char	dateDelimiter;
}
- initTextCell:(const char *)aString;
- select:(const NXRect *)aRect inView:controlView editor:textObj delegate:anObject start:(int)selStart length:(int)selLength;
- edit:(const NXRect *)aRect inView:controlView editor:textObj delegate:anObject event:(NXEvent *)theEvent;
- endEditing:anObject;
- (long)todayLong;
- (long)currentCentury;
- (long)dateAsLong;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- setIntValue:(int)aValue;
- setFloatValue:(float)aValue;
- setDoubleValue:(double)aValue;
- setOldDoubleValue:(double)aValue;
- (double)doubleValue;
- (float)floatValue;
- setFieldType:(int)aType;
- (int)fieldType;
- setAlnumMinLength:(int )aValue;
- (int)alnumMinLength;
- setAlnumMaxLength:(int )aValue;
- (int)alnumMaxLength;
- setAlphaMinLength:(int )aValue;
- (int)alphaMinLength;
- setAlphaMaxLength:(int )aValue;
- (int)alphaMaxLength;
- setAlphaIsName:(int )aValue;
- (int)alphaIsName;
- setNumericMinValue:(int )aValue;
- (int)numericMinValue;
- setNumericMaxValue:(int )aValue;
- (int)numericMaxValue;
- setDoubleMinValue:(double )aValue;
- (double)doubleMinValue;
- setDoubleMaxValue:(double )aValue;
- (double)doubleMaxValue;
- setCurrencyMinValue:(double )aValue;
- (double)currencyMinValue;
- setCurrencyMaxValue:(double )aValue;
- (double)currencyMaxValue;
- setCurrencyDecimalDelimiter:(char )aValue;
- (char)currencyDecimalDelimiter;
- setCurrencyThousandsDelimiter:(char )aValue;
- (char)currencyThousandsDelimiter;
- setCurrencyShowType:(int)aType;
- (int)currencyShowType;
- setDateKind:(int )aValue;
- (int)dateKind;
- setDateDelimiter:(char )aValue;
- (char)dateDelimiter;

extern char *dateFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *alphaFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *alphaNumericFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *numericFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *numericFloatFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *currencyFilter(id textObj, char *inputText, int *inputLength, int position);
extern char *convertFloatToCurrency(id textObj, double theValue);
extern BOOL endEditing(id anObject, const char *aString);
extern BOOL endALNUMEditing(id	aField, const char *aString);
extern BOOL endALPHAEditing(id	aField, const char *aString);
extern BOOL endNUMERICEditing(id	aField, const char *aString);
extern BOOL endFLOATEditing(id	aField, const char *aString);
extern const char *SF_ParseDoubleSTR(const char *DF_local, double theValue);
const char * showCurrencyThousandsOLD(id aField, const char *aString);
const char * showCurrencyOLD(id aField, const char *aString);
extern const char * showCurrencyThousands(id aField, const char *aString);
extern const char * showCurrency(id aField, const char *aString);
extern const char * endCURRENCYEditing(id	aField, const char *aString);
extern BOOL endDATEEditing(id	aField, const char *aString);
@end
