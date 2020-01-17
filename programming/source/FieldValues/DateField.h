#import <appkit/TextField.h>

@interface DateField:TextField
{
	char	finalDate[12];
}

- (BOOL)checkEntryForAcceptance;
- (BOOL)finalCheck;
- (BOOL)isValid;
- textDidEnd:textObject endChar:(unsigned short)whyEnd;
- textDidGetKeys:textObject isEmpty:(BOOL)flag;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;

@end
