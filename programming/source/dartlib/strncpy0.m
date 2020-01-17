#import <string.h>
#import <dart/dartlib.h>

char *strncpy0(char *dest,const char* source,int len)
{
	strncpy( dest, source, len );
	dest[len-1] = 0;
	
	return dest;
}
