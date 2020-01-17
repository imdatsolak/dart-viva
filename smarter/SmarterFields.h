#import <appkit/TextField.h>

@interface SmarterFields:TextField
{
}
+ initialize;
- textDidEnd:anObject endChar:(unsigned short)whyEnd;
- (BOOL)textWillEnd:textObject;
- (const char *)inspectorName;
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
- (long)dateAsLong;
@end
