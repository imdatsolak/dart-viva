#import <string.h>
#import <appkit/Text.h>
#import <appkit/nextstd.h>
#import <appkit/Application.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

static BOOL initialized = NO;

static int err_handler(dbproc, severity, dberr, oserr, dberrstr, oserrstr)
DBPROCESS       *dbproc;
int             severity;
int             dberr;
int             oserr;
char            *dberrstr;
char            *oserrstr;
{
	DEBUG11("SYBASE-ERR dberr:%d oserr:%d %s%s,%s\n",dberr,oserr,DBDEAD(dbproc)?"DBDEAD ":"",dberrstr,oserrstr);
//	if (dbproc && DBDEAD(dbproc) )
//		return (INT_EXIT);
	return(INT_CANCEL);
}

static int msg_handler(dbproc, msgno, msgstate, severity, msgtext, 
                srvname, procname, line)

DBPROCESS       *dbproc;
DBINT           msgno;
int             msgstate;
int             severity;
char            *msgtext;
char            *srvname;
char            *procname;
DBUSMALLINT     line;

{
	DEBUG11("SYBASE-MSG %d state %d %s\n",msgno,msgstate,msgtext);
	[((id)dbgetuserdata(dbproc)) setLastMsg:msgno];
	if ((severity > 0) && (msgno != 4002)) {
		[((id)dbgetuserdata(dbproc)) setLastError:msgno lastErrorSTR:msgtext];
		if (msgno == 1105) {
			if ([NXApp respondsTo:@selector(errorMgr)]) {
				if ([[NXApp errorMgr] respondsTo:@selector(databaseFull)]) {
					[[NXApp errorMgr] databaseFull];
				} else {
					[[[Object alloc] init] error:"Database Full!"];
				}
			} else {
				[[[Object alloc] init] error:"Database Full!"];
			}
		} else {
			NXLogError("SYBASE-SQL\n\tError :#%d\n\tServer:%s\n\tErrorT:%s\n",msgno, srvname, msgtext);
		}
	} else {
		if (strstr(msgtext,"password incorrect") != NULL) {
			[((id)dbgetuserdata(dbproc)) setLastError:10000 lastErrorSTR:msgtext];
		} else {
			DEBUG5("SQL:#%d %s\n",msgno, msgtext);
		}
	}
	return(0);
}


static DBPROCESS *loginSyb(const char *username,const char *password,const char *program)
{
	LOGINREC	*login;
	DBPROCESS	*dbproc;
	
	login = dblogin();
	DBSETLUSER(login,username);
	DBSETLPWD(login,password);
	DBSETLAPP(login,program);
	BCP_SETL(login,TRUE);
	
	dbproc = dbopen(login, NULL);
	dbloginfree(login);
	
	return dbproc;
}


static RETCODE usedbSyb(DBPROCESS *dbproc,const char *database)
{
	return dbuse(dbproc,database);
}


static void logoutSyb(DBPROCESS *dbproc)
{
	dbclose(dbproc);
}


static const char *coltypestr(int coltype)
{
	switch(coltype) {
		case SYBTEXT:		return "SYBTEXT";		break;
		case SYBCHAR:		return "SYBCHAR";		break;
		case SYBBINARY:		return "SYBBINARY";		break;
		case SYBDATETIME:	return "SYBDATETIME";	break;
		case SYBMONEY:		return "SYBMONEY";		break;
		case SYBFLT8:		return "SYBFLT8";		break;
		case SYBINT1:		return "SYBINT1";		break;
		case SYBINT2:		return "SYBINT2";		break;
		case SYBINT4:		return "SYBINT4";		break;
		default:			return "UNKNOWNCOLTYPE";break;
	}
}


static int coltypealignment(int coltype)
{
	switch(coltype) {
		case SYBFLT8:
		case SYBINT1:
		case SYBINT2:
		case SYBINT4:
			return NX_RIGHTALIGNED;
		case SYBTEXT:
		case SYBCHAR:
		case SYBBINARY:
		case SYBDATETIME:
		case SYBMONEY:
		default:
			return NX_LEFTALIGNED;
	}
}


static BOOL coltypeisnumeric(int coltype)
{
	switch(coltype) {
		case SYBFLT8:
		case SYBINT1:
		case SYBINT2:
		case SYBINT4:
		case SYBDATETIME:
		case SYBMONEY:
			return YES;
		case SYBTEXT:
		case SYBCHAR:
		case SYBBINARY:
		default:
			return NO;
	}
}


static id createObject(DBPROCESS *dbproc,int len,void *data,int type,int *width,int tag)
{
	id		anObject;
	int		i;
	char	tmpStr[30];
	
	DEBUG10("createObject(len=%d,tag=%d,type=%s,data=",len,tag,coltypestr(type));
	
	if(data == NULL) {
		DEBUG10("NULL)\n");
		anObject = [[NullValue alloc] init];
	} else {
		switch(type) {
			case SYBCHAR:
			case SYBTEXT:
				anObject = [String str:(char *)data len:len];
				*width = /* len; */ [anObject length];
				DEBUG10("\"%s\")\n",[anObject str]);
				break;
			case SYBFLT8:
				anObject = [Double double:*((double *)data)];
				*width = 10;
				DEBUG10("%lf)\n",[anObject double]);
				break;
			case SYBINT1:
				i = (int)*((char *)data);
				anObject = [Integer int:i];
				if(i < 10) {				*width = 1;
				} else if(i < 100) {		*width = 2;
				} else { 					*width = 3;
				}
				DEBUG10("%d)\n",[anObject int]);
				break;
			case SYBINT2:
				i = (int)*((short *)data);
				anObject = [Integer int:i];
				if(i < 10) {				*width = 1;
				} else if(i < 100) {		*width = 2;
				} else if(i < 1000) {		*width = 3;
				} else if(i < 10000) {		*width = 4;
				} else { 					*width = 5;
				}
				DEBUG10("%d)\n",[anObject int]);
				break;
			case SYBINT4:
				i = *((int *)data);
				anObject = [Integer int:i];
				if(i < 10) {				*width = 1;
				} else if(i < 100) {		*width = 2;
				} else if(i < 1000) {		*width = 3;
				} else if(i < 10000) {		*width = 4;
				} else if(i < 100000) {		*width = 5;
				} else if(i < 1000000) {	*width = 6;
				} else if(i < 10000000) {	*width = 7;
				} else if(i < 100000000) {	*width = 8;
				} else if(i < 1000000000) {	*width = 9;
				} else { 					*width = 10;
				}
				DEBUG10("%d)\n",[anObject int]);
				break;
			case SYBDATETIME:
				dbconvert(dbproc,SYBDATETIME,data,len,SYBCHAR,tmpStr,sizeof(tmpStr));
				anObject = [Date sybDate:tmpStr];
				*width = 10;
				DEBUG10("\"%s\")\n",[anObject dateSTR]);
				break;
			default:
				anObject = [String str:"UNKNOWNTYPE"];
				*width = [anObject length];
				DEBUG10("\"%*.*s\")\n",len,len,(char*)data);
				break;
		}
	}
	
	return [anObject setTag:tag];
}

#pragma .h #import <sybase/sybfront.h>
#pragma .h #import <sybase/sybdb.h>
#pragma .h #import <objc/Object.h>
#pragma .h #define NOERROR	0

@implementation Query:Object
{
	DBPROCESS	*dbproc;
	int 		lastError;
	int 		lastMsg;
	id			lastErrorStr;
}



+ (BOOL)initSybase
{
	if(!initialized) {
		initialized = (dbinit() == SUCCEED);
		if (initialized) {
			dberrhandle(err_handler);
			dbmsghandle(msg_handler);
		}
	}
	return initialized;
}


+ (void)exitSybase
{
	if(initialized) dbexit();
	initialized = NO;
}

+ (void)setTimeout:(int)timeoutSeconds
{
	dbsettime(timeoutSeconds);
}

+ (int)timeout
{
	return DBGETTIME();
}

- init
{
	return [self doesNotRecognize:_cmd];
}


- initUser:(const char *)username password:(const char *)password program:(const char *)program
{
	[super init];
	if(!initialized) [self error:"Sybase DBLIB not initialized.\n"];
	if((dbproc = loginSyb(username,password,program))) {
		dbsetuserdata(dbproc, self);
		[self setLastError:NOERROR];
		[self setLastMsg:NOERROR];
		return self;
	} else {
		return [super free];
	}
}


- free
{
	logoutSyb(dbproc);
	return [super free];
}

- setTextSize:(unsigned)size andLimit:(unsigned)limit
{
	char	s[100];
	sprintf(s,"%d",size);
	dbsetopt(dbproc,DBTEXTLIMIT,s);
	sprintf(s,"%d",limit);
	dbsetopt(dbproc,DBTEXTSIZE,s);
	return self;
}

- useDatabase:(const char *)database
{
	if(usedbSyb(dbproc,database) == SUCCEED) {
		return self;
	} else {
		return nil;
	}
}


- (BOOL)beginTransaction
{
	id	queryString = [QueryString str:"begin tran"];
	[[self performQuery:queryString] free];
	[queryString free];
	return [self lastError] == NOERROR;
}

- (BOOL)rollbackTransaction
{
	id	queryString = [QueryString str:"rollback tran"];
	[[self performQuery:queryString] free];
	[queryString free];
	return [self lastError] == NOERROR;
}

- (BOOL)commitTransaction
{
	id	queryString = [QueryString str:"commit tran"];
	[[self performQuery:queryString] free];
	[queryString free];
	return [self lastError] == NOERROR;
}

- performQuery:queryString
{
	id			queryResult, row;
	int			i, count, width;
	const char	*querySTR = [queryString str];

	DEBUG5("performQuery:[%s]\n",[queryString str]);
	[self setLastError:NOERROR];
	[self setLastMsg:NOERROR];
		
	queryResult = nil;
	dbcmd(dbproc,querySTR);
	if((dbsqlexec(dbproc) == SUCCEED) && (dbresults(dbproc) == SUCCEED)) {
		DEBUG5("performQuery:query succeeded,\n");
		queryResult = [[QueryResult alloc] init];
		if(DBROWS(dbproc)) {
			DEBUG5("performQuery: %d columns\n",dbnumcols(dbproc));
			count = dbnumcols(dbproc);
			for(i=1; i<=count; i++) {
				[queryResult setTitle:dbcolname(dbproc,i)
				             length:0
							 alignment:coltypealignment(dbcoltype(dbproc,i))
							 numeric:coltypeisnumeric(dbcoltype(dbproc,i))
							 andTag:i
							 ofColumn:i-1];
			}
			while(dbnextrow(dbproc) == REG_ROW) {
				row = [[QueryResultRow alloc] initCount:count];
				for( i=1; i<=count; i++ ) {
					[row addObject:createObject(dbproc,
					                            dbdatlen(dbproc,i),
					                            dbdata(dbproc,i),
												dbcoltype(dbproc,i),
												&width,
												i)];
					[queryResult updateMaxLength:width ofColumn:i-1];
				}
				[queryResult addObject:row];
			}
			DEBUG5("performQuery: %d rows\n",[queryResult count]);
		}
	}
	[self checkDead];
	return queryResult;
}

- checkDead
{
	if([self isDead]) {
		if([NXApp respondsTo:@selector(dbDead)]) {
			[NXApp perform:@selector(dbDead) with:self afterDelay:1 cancelPrevious:YES];
		} else {
			[self error:"DBDEAD"];
		}
	}
	return self;
}

- (BOOL)isDead
{
	return dbproc==NULL || DBDEAD(dbproc);
}

- (int)lastError
{
	return lastError;
}

- (int)lastMsg
{
	return lastMsg;
}

- setLastError:(int)error
{
	return [self setLastError:error lastErrorSTR:""];
}

- setLastError:(int)error lastErrorSTR:(const char *)msgtext
{
	lastError = error;
	if (lastErrorStr == nil) {
		lastErrorStr = [String str:""];
	}
	[lastErrorStr str:msgtext];
	if (error != NOERROR) {
		DEBUG("Query:setLastError: %d\n", error);
	}				
	return self;
}

- (const char *)lastErrorSTR
{
	return [lastErrorStr str];
}

- setLastMsg:(int)msg
{
	lastMsg = msg;
	if (msg != NOERROR) {
		DEBUG("Query:setLastMsg: %d\n", msg);
	}
	return self;
}

- (DBPROCESS *)dbproc
{
	return dbproc;
}

@end

@interface Object(QueryErrorManager)
- databaseFull;
@end

@interface Object(QueryApplication)
- errorMgr;
- dbDead;
@end

