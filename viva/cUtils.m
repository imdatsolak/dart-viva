#import <strings.h>
#import <libc.h>
#import <zone.h>

#import "cUtils.h"

#pragma .h #import <objc/objc.h>
#pragma .h extern char *textInString(char *text, char *string, BOOL ignoreCase);
#pragma .h extern char *textInStringReverse(char *text, char *string,
#pragma .h char* stringStart, BOOL ignoreCase);

char *textInString(char *text, char *string, BOOL ignoreCase)
{
    int    textLength, i;
    
    textLength = strlen(text);
    
    i = strlen(string) - textLength + 1;
    
    if (i <= 0) {
	return 0;
    }
    
    if (ignoreCase) {
	while (i--) {
	    if (!strncasecmp(string++, text, textLength)) {
		return (string-1);
	    }
	}
    } else {
	while (i--) {
	    if (!strncmp(string++, text, textLength)) {
		return (string-1);
	    }
	}
    }
   
    return 0;
}

char *textInStringReverse(char *text, char *string, char* stringStart, BOOL ignoreCase)
{
    int    textLength;
    
    textLength = strlen(text);
    string -= textLength;
    
    if ((strlen(stringStart) - strlen(string)) < strlen(text)) {
	return 0;
    }
    
    if (ignoreCase) {
	while (string >= stringStart) {
	    if (!strncasecmp(string--, text, textLength)) {
		return (string + 1);
	    }
	}
    } else {
	while (string >= stringStart) {
	    if (!strncmp(string--, text, textLength)) {
		return (string + 1);
	    }
	}
    }
   
    return 0;
}
