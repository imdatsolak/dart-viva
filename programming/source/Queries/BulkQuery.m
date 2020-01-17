#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#pragma .h #import "Query.h"

@implementation BulkQuery:Query
{
	BOOL	usesLog;
}

- initUser:(const char *)user password:(const char *)password program:(const char *)program
{
	id	retVal = [super initUser:user password:password program:program];
	usesLog = NO;
	return retVal;
}

- (BOOL)usesLog
{
	return usesLog;
}

- useLog:(BOOL)flag
{
	usesLog = flag;
	return self;
}

- (BOOL)updateBinData:(NXStream *)stream withID:(int)ID
{
	DEBUG5("updateBinData:%d", ID);
	dbfcmd([self dbproc],"select data from bindata where id=%d",ID);
	if((dbsqlexec([self dbproc]) == SUCCEED) && (dbresults([self dbproc]) == SUCCEED)) {
		if(dbnextrow([self dbproc]) && dbtxptr([self dbproc],1)) {
			char	*streambuf;
			int		len, maxlen, result;
			NXGetMemoryBuffer(stream,&streambuf,&len,&maxlen);
			DEBUG5(", len=%d, maxlen=%d",len,maxlen);
			result = SUCCEED == dbwritetext([self dbproc],
											"bindata.data",
											dbtxptr([self dbproc],1),
											DBTXPLEN,
											dbtxtimestamp([self dbproc],1),
											usesLog,
											(DBINT)len,
											streambuf);
			DEBUG5(" --> %s\n",result?"YES":"NO");
			return result;
		}
	}
	DEBUG5(" --> NO\n");
	[self checkDead];
	return NO;
}
			
- (int)insertBinData:(NXStream *)stream
{
	id	queryString;
	id	result;

	DEBUG5("insertBinData:\n");
	if ([self beginTransaction]) {
		queryString = [QueryString str:"select maxid from maxbindataid holdlock"];
		result = [self performQuery:queryString];
		queryString = [queryString free];
		if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
			int	i = [[[[result objectAt:0] objectAt:0] increment] int];
			result = [result free];
			queryString = [QueryString str:"update maxbindataid set maxid=maxid+1"];
			[[self performQuery:queryString] free];
			queryString = [queryString free];
			if(([self lastError] == NOERROR) && [self commitTransaction]) {
				queryString = [QueryString str:"insert into bindata values("];
				[queryString concatINTComma:i];
				[queryString concatSTR:"'leer')"];
				[[self performQuery:queryString] free];
				queryString = [queryString free];
				if(([self lastError] == NOERROR) && [self updateBinData:stream withID:i]) {
					return i;
				} else {
					return 0;
				}
			} else {
				[self rollbackTransaction];
				return 0;
			}
		} else {
			[self rollbackTransaction];
			result = [result free];
			return 0;
		}
	} else {
		return 0;
	}
}

- (BOOL)deleteBinDataWithID:(int)ID
{
	id	queryString;
	DEBUG5("deleteBinDataWithID:%d\n", ID);
	queryString = [QueryString str:"delete from bindata where id="];
	[queryString concatINT:ID];
	[[self performQuery:queryString] free];
	[queryString free];
	[self checkDead];
	return [self lastError] == NOERROR;
}

- (NXStream *)selectBinDataWithID:(int)ID
{
	DEBUG5("selectBinDataWithID:%d",ID);
	dbfcmd(dbproc,"select data from bindata where id=%d",ID);
	if(	   (dbsqlexec(dbproc) == SUCCEED)
		&& (dbresults(dbproc) == SUCCEED)
		&& (dbnextrow(dbproc) == REG_ROW)
		&& (dbdata(dbproc,1) != NULL)) {
		
		NXStream	*stream = NXOpenMemory(NULL,0,NX_READWRITE);
		NXWrite(stream,dbdata(dbproc,1),dbdatlen(dbproc,1));
		NXSeek(stream,0,NX_FROMSTART);
		DEBUG5(" --> size:%d\n",dbdatlen(dbproc,1));
		[self checkDead];
		return stream;
	} else {
		DEBUG5(" --> NULL\n");
		[self checkDead];
		return NULL;
	}
}

@end

#if 0

BEGIN TABLE DEFS
create table bindata (id int,data image)
create table maxbindataid ( maxid int )
insert into maxbindataid values(1)
go
END TABLE DEFS

#endif

