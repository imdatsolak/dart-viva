#import <sybase/sybfront.h>
#import <sybase/sybdb.h>
#import <objc/Object.h>
#define NOERROR	0

@interface Query:Object
{
	DBPROCESS	*dbproc;
	int 		lastError;
	int 		lastMsg;
	id			lastErrorStr;
}

+ (BOOL)initSybase;
+ (void)exitSybase;
+ (void)setTimeout:(int)timeoutSeconds;
+ (int)timeout;
- init;
- initUser:(const char *)username password:(const char *)password program:(const char *)program;
- free;
- setTextSize:(unsigned)size andLimit:(unsigned)limit;
- useDatabase:(const char *)database;
- (BOOL)beginTransaction;
- (BOOL)rollbackTransaction;
- (BOOL)commitTransaction;
- performQuery:queryString;
- checkDead;
- (BOOL)isDead;
- (int)lastError;
- (int)lastMsg;
- setLastError:(int)error;
- setLastError:(int)error lastErrorSTR:(const char *)msgtext;
- (const char *)lastErrorSTR;
- setLastMsg:(int)msg;
- (DBPROCESS *)dbproc;

@end


@interface Object(QueryErrorManager)
- databaseFull;

@end


@interface Object(QueryApplication)
- errorMgr;
- dbDead;

@end

