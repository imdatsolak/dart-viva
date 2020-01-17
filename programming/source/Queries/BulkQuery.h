#import "Query.h"

@interface BulkQuery:Query
{
	BOOL	usesLog;
}

- initUser:(const char *)user password:(const char *)password program:(const char *)program;
- (BOOL)usesLog;
- useLog:(BOOL)flag;
- (BOOL)updateBinData:(NXStream *)stream withID:(int)ID;
- (int)insertBinData:(NXStream *)stream;
- (BOOL)deleteBinDataWithID:(int)ID;
- (NXStream *)selectBinDataWithID:(int)ID;

@end

