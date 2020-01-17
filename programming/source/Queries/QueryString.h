#import <dart/String.h>

@interface QueryString:String
{
}

- concatField:aField;
- concatFieldComma:aField;
- translateRTF;
- translateQuotes;
- concatINT:(int)i;
- concatDOUBLE:(double)d;
- concatINTComma:(int)i;
- concatDOUBLEComma:(double)d;

@end
