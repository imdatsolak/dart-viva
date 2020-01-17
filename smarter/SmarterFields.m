#import <stdlib.h>
#import <strings.h>
#import <time.h>
#import "SmarterFields.h"
#import "SmarterTFCell.h"

@implementation SmarterFields
+ initialize
{
	return [super initialize];
}

+ alloc
{
	[SmarterFields setCellClass:[SmarterTFCell class]];
	return [super alloc];
}

- textDidEnd:anObject endChar:(unsigned short)whyEnd
{
	[super textDidEnd:anObject endChar:whyEnd];
	if ([[self cell] fieldType] == SMTFC_CURRENCY) {
		id fp = [[self window] firstResponder];
		if ([fp respondsTo:@selector(delegate)] && ([fp delegate] == self)) {
			[super selectText:anObject];
		} else {
			const char *currVal = [self stringValue];
			const char *newVal = endCURRENCYEditing(self, currVal);
			if (newVal != NULL) {
				[self setStringValue:newVal];
			}
		}
	}
	return self;
}

- (BOOL)textWillEnd:textObject
{
	const char *currVal = [self stringValue];
	if ([[self cell] fieldType] == SMTFC_CURRENCY) {
		if (endCURRENCYEditing(self, currVal) == NULL) {
			return YES;
		} else {
			return [super textWillEnd:textObject];
		}
	} else {
		if (endEditing(self, currVal)==0) {
			return YES;
		} else {
			return [super textWillEnd:textObject];
		}
	}
}

- selectText:sender
{
	if (([self isEditable]) && ([[self cell] fieldType] == SMTFC_CURRENCY)) {
		if (sender != self) {
			char fmtStr[32];
			sprintf(fmtStr,"1000%c00",[[self cell] currencyDecimalDelimiter]);
			[[self cell] setStringValue:SF_ParseDoubleSTR(fmtStr,[[self cell] doubleValue])];
		}
	}
	return [super selectText:sender];
}

- mouseDown:(NXEvent *)theEvent
{
	if (([self isEditable]) && ([[self cell] fieldType] == SMTFC_CURRENCY)) {
		char fmtStr[32];
		sprintf(fmtStr,"1000%c00",[[self cell] currencyDecimalDelimiter]);
		[[self cell] setStringValue:SF_ParseDoubleSTR(fmtStr,[[self cell] doubleValue])];
	}
	return [super mouseDown:theEvent];
}

- (const char *)inspectorName
{
	return "SmarterFieldsInspector";
}

- setFieldType:(int)aType
{
	[[self cell] setFieldType:aType];
	return self;
}

- (int)fieldType
{
	return [[self cell] fieldType];
}


- setAlnumMinLength:(int )aValue
{
	[[self cell] setAlnumMinLength:aValue];
	return self;
}

- (int)alnumMinLength { return [[self cell] alnumMinLength]; }


- setAlnumMaxLength:(int )aValue
{
	[[self cell] setAlnumMaxLength:aValue];
	return self;
}

- (int)alnumMaxLength { return [[self cell] alnumMaxLength]; }


- setAlphaMinLength:(int )aValue
{
	[[self cell] setAlphaMinLength:aValue];
	return self;
}

- (int)alphaMinLength { return [[self cell] alphaMinLength]; }


- setAlphaMaxLength:(int )aValue
{
	[[self cell] setAlphaMaxLength:aValue];
	return self;
}

- (int)alphaMaxLength { return [[self cell] alphaMaxLength]; }


- setAlphaIsName:(int )aValue
{
	[[self cell] setAlphaIsName:aValue];
	return self;
}

- (int)alphaIsName { return [[self cell] alphaIsName]; }


- setNumericMinValue:(int )aValue
{
	[[self cell] setNumericMinValue:aValue];
	return self;
}

- (int)numericMinValue { return [[self cell] numericMinValue]; }


- setNumericMaxValue:(int )aValue
{
	[[self cell] setNumericMaxValue:aValue];
	return self;
}

- (int)numericMaxValue { return [[self cell] numericMaxValue]; }


- setDoubleMinValue:(double )aValue
{
	[[self cell] setDoubleMinValue:aValue];
	return self;
}

- (double)doubleMinValue { return [[self cell] doubleMinValue]; }


- setDoubleMaxValue:(double )aValue
{
	[[self cell] setDoubleMaxValue:aValue];
	return self;
}

- (double)doubleMaxValue { return [[self cell] doubleMaxValue]; }


- setCurrencyMinValue:(double )aValue
{
	[[self cell] setCurrencyMinValue:aValue];
	return self;
}

- (double)currencyMinValue { return [[self cell] currencyMinValue]; }


- setCurrencyMaxValue:(double )aValue
{
	[[self cell] setCurrencyMaxValue:aValue];
	return self;
}

- (double)currencyMaxValue { return [[self cell] currencyMaxValue]; }


- setCurrencyDecimalDelimiter:(char )aValue
{
	[[self cell] setCurrencyDecimalDelimiter:aValue];
	return self;
}

- (char)currencyDecimalDelimiter { return [[self cell] currencyDecimalDelimiter]; }


- setCurrencyThousandsDelimiter:(char )aValue
{
	[[self cell] setCurrencyThousandsDelimiter:aValue];
	return self;
}

- (char)currencyThousandsDelimiter { return [[self cell] currencyThousandsDelimiter]; }

- setCurrencyShowType:(int)aType
{
	[[self cell] setCurrencyShowType:aType];
	return self;
}

- (int)currencyShowType { return [[self cell] currencyShowType]; }

- setDateKind:(int )aValue
{
	[[self cell] setDateKind:aValue];
	return self;
}

- (int)dateKind { return [[self cell] dateKind]; }


- setDateDelimiter:(char )aValue
{
	[[self cell] setDateDelimiter:aValue];
	return self;
}

- (char)dateDelimiter { return [[self cell] dateDelimiter]; }
- (long)dateAsLong { return [[self cell] dateAsLong]; }

@end
