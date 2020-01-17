/*
 *	sybdb.h	62.3	7/5/90
 *
 *	Sybase DB-LIBRARY Version 4.0
 *	Confidential Property of Sybase, Inc.
 *	(c) Copyright Sybase, Inc. 1988, 1989
 *	All rights reserved
 *
 *
 * Use, duplication, or disclosure by the United States Government
 * is subject to restrictions as set forth in subparagraph (c) (1) (ii)
 * of the Rights in Technical Data and Computer Software clause
 * at CFR 52.227-7013. Sybase, Inc. 6475 Christie Avenue, Emeryville,
 * CA 94608.
 *
 */

/* temporarily undef ABS since there is one in sybdbtokens.h */
#ifdef	ABS
#undef	ABS
#endif	/* ABS */
#include	<sybase/sybdbtoken.h>
#ifdef	ABS
#undef	ABS
#endif	/* ABS */
#define	ABS(a)		((a) > 0 ? (a) : -(a))

/*
**  Status code for dbnextrow() and dbgetrow().
**  Return of > 0 indicates ALTROW.
**  FAIL is another possible return.
*/
#define	MORE_ROWS	-1
#define	NO_MORE_ROWS	-2
#define	REG_ROW		MORE_ROWS
#define	BUF_FULL	-3

/*
**  Status code for dbresults(). Possible return values are
**  SUCCEED, FAIL, and NO_MORE_RESULTS.
*/
#define NO_MORE_RESULTS	2

/*
**  Return code for message-handlers. Indicates whether or not the handler
**  wants DB-LIBRARY to buffer the current Server message for later use
**  by the program.
*/
#define DBSAVE		1
#define DBNOSAVE	0

#define DBNOERR		-1

/*
** Default size of row buffer.  This is what people get if they do
** a dbsetopt(dbproc, DBBUFFER, 0).
*/
#define	DBBUFSIZE	1000

/* The size of a SYBTEXT timestamp, in bytes. This timestamp is not to be
 * confused with a browse-mode timestamp.
 */
#define DBTXTSLEN	8

/* The size of a text-pointer, in bytes. */
#if !VMS
#define DBTXPLEN	((DBTINYINT)16)
#else
#define DBTXPLEN	((unsigned char)16)
#endif

/*
** this is defined in the SQL Server server.h but it has alot of other 
** stuff that we don't want.
*/
#define	MAXNAME	30

#include	<sybase/syblogin.h>

#define	DBMAXCHAR	256
#define	DBMAXCOLNAME	30
#define	DBMAXBYLIST	16

/* maximum printing lengths for fixed-length data */
#define	PRINT4	11
#define	PRINT2	6
#define	PRINT1	3
#define	PRFLT8	20
#define	PRMONEY	24
#define	PRBIT	1
#define	PRDATETIME	20
#define	PRLDATETIME	24	/* includes milliseconds */

/* SQL Server variable typedefs */
typedef	unsigned short	DBUSMALLINT;	/* SQL Server 2 byte integer */
typedef struct dbvarychar		/* Pascal-type string. */
{
	DBSMALLINT	len;		/* length of the character string */
	DBCHAR		str[DBMAXCHAR];	/* string, with no NULL terminator */
} DBVARYCHAR;
typedef struct dbvarybin		/* Pascal-type binary array. */
{
	DBSMALLINT	len;		/* length of the binary array */
	BYTE		array[DBMAXCHAR];/* the array itself. */
} DBVARYBIN;

#define	TINYBIND	1
#define	SMALLBIND	2
#define	INTBIND		3
#define	CHARBIND	4
#define	TEXTBIND	5
#define	BINARYBIND	6
#define	ARRAYBIND	7
#define	BITBIND		8
#define	DATETIMEBIND	9
#define	MONEYBIND	10
#define	FLT8BIND	11
#define	STRINGBIND	12
#define	NTBSTRINGBIND	13
#define VARYCHARBIND	14
#define VARYBINBIND	15
#if VOS
#define	FIXEDBIND	16			/*kvk589*/
#define PACKEDBIND	17			/*kvk589*/
#define MAXBIND		PACKEDBIND		/*kvk589*/
#else
#define MAXBIND		VARYBINBIND
#endif

/*
** From pss.h SQL Server structure.
*/
/* Donepacket status bit defs go here */
# define DONE_CONT	(DBUSMALLINT) 0x1	
# define DONE_ERROR	(DBUSMALLINT) 0x2
# define DONE_INXACT	(DBUSMALLINT) 0x4
# define DONE_PROC	(DBUSMALLINT) 0x8
# define DONE_COUNT	(DBUSMALLINT) 0x10
# define DONE_ATTN	(DBUSMALLINT) 0x20

/*
**    OFFSETS DEFINITIONS
**
**    These are a subset of the token values for offset information.
**    These defines come from y.tab.h
**
*/
#define _SELECT 365
#define _EXECUTE 330
#define _FROM 335
#define _ORDER 357
#define _COMPUTE 313
#define _TABLE 371
#define _PROCEDURE 362
#define _STATEMENT 459
#define _PARAM 452
/* end y.tab.h */

/*
** HOSTSERVER.h - structures and defines for communicating with server
**
*/

/*
** Data structure used by both send and recv
*/
typedef struct servbuf
{
	BYTE	*serv_sbuf;	/* send: start of send buffer */
	BYTE	*serv_snb;	/* send: next place in buffer */
	int	serv_sleft;	/* send: room left in send buffer */
	int	serv_sbsize;	/* send: buffer size */
	int	serv_snum;	/* send # for network */
	int	serv_sstat;	/* send: status bits */
	BYTE	*serv_rbuf;	/* recv: start of recv buffer */
	BYTE	*serv_rnb;	/* recv: next place in buffer */
	int	serv_rleft;	/* recv: room left in recv buffer */
	int	serv_rbsize;	/* recv: buffer size */
	int	serv_rnum;	/* recv # for network */
	int	serv_rstat;	/* recv: status bits */
	int	serv_commtype;	/* communications type (tcp, etc.) */
	RETCODE	(*serv_attn)(); /* network-dependent routine to send
				 * an ATTN packet to the SQL Server.
				 */
	DBINT	(*serv_read)();	/* network-dependent routine to read
				 * a byte stream from the SQL Server.
				 */
	RETCODE	(*serv_read_a)();/* async version of serv_read(). */
	DBINT	(*serv_writ)();	/* network-dependent routine to write
				 * a byte stream to the SQL Server.
				 */
	RETCODE	(*serv_clos)();	/* network-dependent routine to close
				 * a connection to the SQL Server.
				 */
} SERVBUF;


/*
**  DBSTRING - This structure is just used for stringing text or parameters
**	together.
*/
struct dbstring
{
	BYTE 	*strtext;	/* actual byte string */
	DBINT	strtotlen;	/* allocated length of the byte string */
	struct dbstring	*strnext;
};
typedef struct dbstring	DBSTRING;

/*
**	DBROWDATA - This structure is used to hold the actual data that
**	comes back for every column in every row. The DBPROCESS structure
**	points to a linked-list of DBROW structures. Each DBROW strcture points
**	to an array of DBROWDATA structures. Since every DBROWDATA structure
**	contains pointers to separately allocated buffers, the members of
**	each array are linked together in a singly-linked list, to facilitate
**	the operation of simple row-freeing routines.
*/
struct dbrowdata
{
	BYTE 		*data;		/* actual data for this column in this
					 * row
					 */
	DBINT		datlen;		/* length, in bytes, of this data */
	DBBINARY	dattxptr[DBTXPLEN];/* This data's text-ptr, if it's of
					 * type SYBTEXT.
					 */
	DBTINYINT	dattxplen;	/* Length, in bytes, of the text-ptr. */
	DBBINARY	dattxts[DBTXTSLEN];/* The text-timestamp of this text
					 * value.
					 */
	DBTINYINT	dattxtslen;	/* Length, in bytes, of the
					 * text-timestamp.
					 */
	struct dbrowdata	*datnext;
};
typedef struct dbrowdata	DBROWDATA;

/*
**  BINDREC - This is the structure used to store information about
**	which columns should be bound to which programming variables
*/
struct	bindrec
{
	BYTE		*bindvar;	/* ptr to program variable */
	DBINT		bindlen;	/* length of program variable */
	DBINT		(*bindproc)();	/* procedure to use for data copy. */
	DBINT		*bindnullind;	/* IBM-type indicator variable. */
};
typedef struct bindrec	BINDREC;

/*
** NULLBIND - This structure is attached to the DBPROCESS and is used
**	to determine what to bind when bind values are NULL.
*/
struct	nullbind
{
	DBBIT		nullbit;
	DBTINYINT	nulltiny;
	DBSMALLINT	nullsmall;
	DBINT		nullint;
	DBCHAR		*nullchar;
	DBINT		nulllchar;	/* length of char string */
	DBBINARY	*nullbinary;
	DBINT		nulllbinary;	/* length of binary string */
	DBDATETIME	nulldatetime;
	DBMONEY		nullmoney;
	DBFLT8		nullflt8;
	DBCHAR		*nullstring;
	DBCHAR		*nullntbstring;
	DBVARYCHAR	nullvarychar;
	DBVARYBIN	nullvarybin;
};
typedef struct nullbind	NULLBIND;

/*
**  DBCOLINFO - This structure contains the format information about a column.
**	There is a linked list of DBCOLINFO structures in the DBPROCESS
**	structure.  There is one DBCOLINFO structure for each column in the
**	target list of the current command.  Format information for
**	alternate rows, like compute, is kept in the DBALTHEAD and
**	DBALTINFO structures.
*/
struct dbcolinfo
{
	char	colname[DBMAXCOLNAME+1];/* column name */
	BYTE	coltype;		/* column type */
	DBINT	coludtype;		/* user-defined type */
	DBINT	collen;			/* max length of column */
	DBINT	colprlen;		/* max printing length of column */
	char	*colcontrol;		/* control format, if any */
	struct bindrec	colbind;	/* binding info, if any */
	int	coltable;		/* for browse mode: which table
					 * did this column come from?
					 */
	BYTE		colstatus;	/* for browse mode: what kind of column
					 * is this?
					 */
	char	colorigname[DBMAXCOLNAME+1];/* for browse mode: what is the name
					 * of the table column that provided
					 * this select-list member?
					 */
	char	*coltxobjname;		/* the SQL Server always returns the
					 * qualified object-name for TEXT
					 * columns.
					 */
	struct dbcolinfo	*colnext;	/* next column */
};
typedef	struct dbcolinfo	DBCOLINFO;

/*
**  DBTABNAME - This structure contains information about the tables which
**	were used to produce the current set of results. The SQL Server only
**	provides this info for queries that are executed in "browse mode".
**
**	There is a linked list of DBTABNAME structures in the DBPROCESS
**	structure.  There is one DBTABNAME structure for each table used to
**	produce the target list of the current command.
**
**	If this query was executed without "browse mode", then this list will
**	have no members.
*/
struct dbtabname
{
	char			tabname[MAXNAME+1];	/* column name */
	struct dbtabname	*tabnext;		/* next column */
};
typedef	struct dbtabname	DBTABNAME;

/*
**  DBRETVAL - This structure contains any data which was returned as a function
**	value by the last command. Currently, "browse-mode" updates are the only
**	commands which return function values.
**
**	There is a linked list of DBRETVAL structures in the DBPROCESS
**	structure.  There is one DBRETVAL structure for each function value
**	returned by the current command.
**
**	If this command returned no function value, this list will
**	have no members.
*/
struct dbretval
{
	char		retname[MAXNAME+1];	/* value name */
	BYTE		retvalstat;		/* status byte */
	DBINT		retusertype;		/* user type */
	BYTE		rettype;		/* value type */
	DBINT		retmaxlen;		/* max value length (ignored) */
	DBINT		retlen;			/* value length */
	BYTE		*retdata;		/* the return-value itself. */
	struct dbretval	*retnext;		/* next return-value */
};
typedef	struct dbretval	DBRETVAL;

/*
**  DBALTHEAD - This structure contains information for ALT rows.  ALT
**	rows are COMPUTE results.  There is one DBALTHEAD for each COMPUTE
**	statement.  All the COMPUTE operators in a particular COMPUTE statement
**	must have the same bylist -- this is enforced by the SQL Server.
**	Off of each DBALTHEAD is a linked list of DBALTINFO structures that
**	describe the format for each particular COMPUTE operation in the
**	COMPUTE.
*/
struct	dbalthead
{
	DBUSMALLINT	althid;		/* id for this COMPUTE statement */
	BYTE	althalts;	/* number of DBALTINFO structures in althlist */
	BYTE	althsizeby;	/* number of elements in the bylist */
	BYTE	althbylist[DBMAXBYLIST];	/* colids of bylist elements */
	struct dbaltinfo	*althlist;	/* linked list of DBALTINFOs */
	struct dbprlist		*althprlist;	/* order print list for aops */
	struct dbalthead	*althnext;	/* next dbalthead */
};
typedef struct dbalthead	DBALTHEAD;

/*
**  DBPRLIST - This structure is used to create an 'ordered' printing list
**	for computes.  For example a compute might be:
**		compute sum(col1), avg(col2), sum(col2), avg(col3), avg(col1)
**	For printing, it would be nice to have a list that pointed to the
**	right DBALTINFO structures like this:
**		sum(col1)-->sum(col2)
**		  |
**		 \|/
**		avg(col1)-->avg(col2)-->avg(col3)
**	It is used by the praltrow function that dbprrow uses but the
**	information could be used by any DBLIB client.
*/
struct	dbprlist
{
	DBROWDATA	*prdata;	/* actual data for the compute */
	struct dbaltinfo	*prtarget;	/* related ALTINFO struct */
	struct dbprlist		*prright;	/* next aop in compute */
	struct dbprlist		*prdown;	/* next compute in query */
};
typedef struct dbprlist	DBPRLIST;

/*
**  DBALTINFO - This structure contains the format information about
**	alternate rows.  Compute clauses produce alternate rows of data,
**	interspersed with the regular data rows returned by the dataserver.
**	There is a linked list of DBALTHEAD structures in the DBPROCESS
**	structure.  There is one DBALTHEAD structure for each possible
**	type of alternate row of the current command.  Format information for
**	regular data rows is kept in the DBCOLINFO structure.
*/
struct dbaltinfo
{
	char	*altname;	/* null terminated string to alt header */
	BYTE	alttoken;	/* type of alternate information */
	BYTE	altcolid;	/* which target list member referenced */
	BYTE	alttype;	/* column type */
	DBINT	altudtype;	/* user-defined type */
	DBINT	altlen;		/* max length of column */
	DBINT	altprlen;	/* printing length of data */
	char	*altcontrol;		/* control format, if any */
	struct dbprlist	*altprlist;	/* ptr to ordered printing list */
	struct bindrec	altbind;	/* binding info, if any */
	struct dbaltinfo	*altnext;	/* next column */
};
typedef	struct dbaltinfo	DBALTINFO;

/*
**  DBROW - This structure is used to store the actual row and alternate row
**	data returned by the dataserver.  The member of the DBPROCESS structure 
**	called dbfirstdata stores the doubly-linked list of rows.  If buffering
**	is off, only one row is stored.  The rows are stored in the order that
**	they are received from the server.
*/
struct dbrow
{
	DBINT		rowid;		/* this is the returned row number */
	DBUSMALLINT	rowaltid;	/* for ALT rows, this is
					 * DBALTINFO.altid
					 */
	DBROWDATA	*rowdata;	/* actual data */
	DBBOOL				rowhasnull;	/* are there any NULLS in this row of
					 * data?
					 */
	struct dbrow	*rowprev;	/* previous row if buffering on */
	struct dbrow	*rownext;	/* next row if buffering on */
	SECLAB 		dbseclab;	/* security label */
	unsigned long	dbcrc;		/* row crc (security only) */
};
typedef struct dbrow	DBROW;
	
/*
**  DBINFO - This structure is used to store information and error messages
**	returned by the dataserver.
**
**	NOTE - This structure is used by APT.
**		Adding or deleting structure members should be done with
**		care.
*/
struct dbinfo
{
	DBINT		infonum;	/* error or info number */
	DBTINYINT	infostate;	/* error state number */
	DBTINYINT	infoclass;	/* info class or error severity */
	char		*infotext;	/* null terminated message */
	char		*infoservname;	/* null terminated Server-name */
	char		*infoprocname;	/* null terminated procedure-name */
	DBUSMALLINT	infolinenum;	/* stored-procedure line-number */
	struct dbinfo	*infonext;
};
typedef struct dbinfo	DBINFO;

/*
**  Options - both for the dataserver and DBLIB
**	As additional options are added, they should be added here and in
**	the Dboptdict array.
*/

/*
** dataserver options are defined in pss.h
** dataserver options and their index into the Dboptdict array
** Dboptdict is defined in options.c
*/
#define DBPARSEONLY	0
#define DBESTIMATE	1	
#define DBSHOWPLAN	2
#define DBNOEXEC	3
#define DBARITHIGNORE	4
#define DBNOCOUNT	5
#define DBARITHABORT	6
#define DBTEXTLIMIT	7
#define DBBROWSE	8
#define DBOFFSET	9
#define DBSTAT		10
#define DBERRLVL	11
#define DBCONFIRM	12
#define DBSTORPROCID	13
#define DBBUFFER	14
#define DBNOAUTOFREE	15
#define DBROWCOUNT	16
#define DBTEXTSIZE	17

#define	OFF		0
#define	ON		1

/* RETCODES for option routines */
#define	NOSUCHOPTION	2

/*
**  DBOPTION - This structure is used to store the current dataserver and
**	dblib options.
*/
struct dboption
{
	char	*opttext;
	DBSTRING	*optparam;	/* param to the option */
	DBUSMALLINT	optstatus;	/* status of option */
	DBBOOL			optactive;	/* is this structure active (being used?) */
	struct dboption	*optnext;	/* for different versions of an option */
};
typedef struct dboption	DBOPTION;


/*
** These are the offset types recognized by the SQL Server
** They are contained in the SQL Server header pss.h.  The _defines
** come from y.tab.h.
*/
#define OFF_SELECT	(DBUSMALLINT) _SELECT
#define OFF_EXEC	(DBUSMALLINT) _EXECUTE
#define OFF_FROM	(DBUSMALLINT) _FROM
#define OFF_ORDER	(DBUSMALLINT) _ORDER
#define OFF_COMPUTE	(DBUSMALLINT) _COMPUTE
#define OFF_TABLE	(DBUSMALLINT) _TABLE
#define OFF_PROCEDURE	(DBUSMALLINT) _PROCEDURE
#define OFF_STATEMENT	(DBUSMALLINT) _STATEMENT
#define OFF_PARAM	(DBUSMALLINT) _PARAM

/*
**  DBOFF - This structure is used to store text offset information.
**	This information is used to send back to the dataserver new
**	control formats.  
*/
struct dboff
{
	DBUSMALLINT	offtype;	/* type of offset */
	DBUSMALLINT	offset;		/* actual offset */
	struct dboff	*offnext;
};
typedef struct dboff	DBOFF;

/*
**  DBDONE - This structure is just the dataserver done packet.
**	It has information about the completion of a command.
*/
struct dbdone
{
	DBUSMALLINT	donestatus;	/* done status bits */
	DBUSMALLINT	doneinfo;	/* command specific info */
	DBINT		donecount;	/* done count -- rows for example */
};
typedef struct dbdone	DBDONE;

/* Status bits for DBPROCESS dbstatus */
#define	READROW		(DBUSMALLINT) 0x2
#define	INSPROC		(DBUSMALLINT) 0x4
#define	EXECDONE	(DBUSMALLINT) 0x8
#define	NEWDB		(DBUSMALLINT) 0x10

/* Possible flags for dbback_compatible(). Currently the only
** one is DBEXTRARESULTS.
*/
#define DBEXTRARESULTS  (DBUSMALLINT) 0x1


/* Bulk-copy information -- */

#define	PERIOD	'.'	/* the separator... */

#define	STATNULL	(BYTE) 0x08
#define IN		(BYTE) 1 /* TEMPORARY - for backward compatibility. */
#define	OUT		(BYTE) 2 /* TEMPORARY - for backward compatibility. */
#define DB_IN		(BYTE) 1
#define	DB_OUT		(BYTE) 2
#define BCPNAMELEN	255
#define DEFABORT	10		/* # of errors before we give up */
#define	ERRFILE		"bcp.error"	/* default error file name */

/* BCP macros: */
#define BCP_SETL(a,b)		dbsetlbool((a), (b), DBSETBCP)

/* The fields for calls to bcpcontrol. */
#define	BCPMAXERRS	1
#define	BCPFIRST	2
#define	BCPLAST		3
#define	BCPBATCH	4
#define	BCPERRFILE	5	/* TEMPORARY - for backward compatibility. */

/* This macro is used by the Non-C interfaces to BCP-Library: */
#define BCP_HOSTTYPE(a, b)	(((a)->db_bcpdesc->bd_hostdesc + (b - 1))->htype)

typedef	struct	bcpparsetable
{
	char	dbname[MAXNAME+1];
	char	ownername[MAXNAME+1];
	char	tabname[MAXNAME+1];
} BCPPARSETABLE;

/*
**  BCPCOLDESC
**	This is the basic unit of information used for bulkcopy.
**	All the bulkcopy routines that talk with the SQL Server
**	routines pass an array of these.
*/
typedef struct	bcpcoldesc
{
	BYTE	*cd_dvalue;		/* current value to be inserted */
	BYTE	*cd_defvalue;		/* default value to be inserted */
	DBINT	cd_dlen;		/* current length to be inserted */
	DBINT	cd_deflen;		/* length of default to be inserted */
	DBINT	cd_colen;		/* max length allowed in column */
	short	cd_coloff;		/* column offset in row */
	BYTE	cd_colid;		/* id of column */
	BYTE	cd_type;		/* storage type of column */
	BYTE	cd_status;		/* status bits */
	DBBOOL			cd_nullok;		/* is a NULL ok here? */
	char	cd_name[MAXNAME+1];	/* column name */
	DBBOOL			cd_moretext;		/* Is this text to be sent via bcp__moretext? */
	long	cd_textpos;		/* file-position of a long TEXT or IMAGE */
} BCPCOLDESC;

/*
**  BCPROWDESC
**	This is the basic unit of information used for bulkcopy.
**	All the bulkcopy routines that talk with the SQL Server
**	routines pass it.
*/
typedef struct bcprowdesc
{
	BCPCOLDESC	*rd_coldesc;	/* ptr to base address of COLDESC
					 * array
					 */
	short		rd_colcount;	/* number of columns in COLDESC */
	short		rd_minlen;	/* minimum length of a row */
	short		rd_maxlen;	/* maximum length of a row */
} BCPROWDESC;

/*
** BCPHOSTDESC
**	This is the structure that has information about the type and
**	format of the input or output data.  An array of these is used
**	to read/write data to or from the host.
*/
typedef struct	bcphostdesc
{
	BCPCOLDESC	*h_tabcol; /* which table column we are referring to */
	int	h_tabcolnum;	/* which table column we are referring to */
	DBINT	(*hconvert)();	/* conversion function, if applicable */
	BYTE	htype;		/* host data type for this column */
	DBINT	hcollen;	/* max length of hostfile column */
	BYTE	*hdata;		/* host-format data for this column */
	DBINT	hdatlen;	/* length of actual hostfile data */
	int	hprefixlen;	/* length of length-prefix for this column */
	BYTE	*hterm;		/* terminator for this column, if applicable */
	int	htermlen;	/* length of terminator for this column */
	DBBOOL			hmoretext;	/* Is this text to be sent via bcp__moretext? */
	long	htextpos;	/* file-position of a long TEXT or IMAGE */
} BCPHOSTDESC;

/* This structure contains information about any partially-sent TEXT or IMAGE
 * values, which are still to be sent by bcp_moretext().
 */
typedef struct bcptextrec
{
	DBINT		len;
	BYTE		*val;
	BYTE		type;
	DBSMALLINT	rowoffset;
	BYTE		coloffset;
} BCPTEXTREC;

/*
**  BCPDESC
**	This structure is used to pass the information contained in the
**	Bulk Copy property sheet around (if in the form version), or 
**	information typed in by the user (in dblib/stand alone version).
**	In the form version, this information comes from the main form, while
**	in the stand alone version this comes from the command line.
*/
typedef struct	bcpdesc
{
	BCPROWDESC	*bd_rowdesc;		/* the associated rowdesc */
	BCPHOSTDESC	*bd_hostdesc;		/* ptr to base address of
						** BCPHOSTDESC array */
	int		bd_hcolcount;		/* number of (cols) BCPHOSTDESC 
						** structs */
	BCPPARSETABLE	*bd_ptable;		/* ptr to tbl name components */
	char		bd_table[(3 * MAXNAME) + 3]; /* full table name */
	char		bd_filename[BCPNAMELEN+1];/* host filename */
	BYTE		bd_direction;		/* in/out */
	char		*bd_errfilename;	/* host err file name */
	BYTE		*bd_errfile;		/* host err file pointer */
	DBINT		bd_abort;		/* # of errors allowable */
	DBINT		bd_firstrow;		/* begin copy at this row */
	DBINT		bd_lastrow;		/* end copy at this row */
	DBINT		bd_batch;		/* # of rows per batch */
	int		bd_textcount;		/* # of text-columns in the
						 * current row.
						 */
	int		bd_textcol;		/* # of the text-column now
						 * being sent by bcp_moretext().
						 * Starts at zero.
						 */
	DBINT		bd_textbytes;		/* # of bytes already sent of
						 * the current bcp_moretext()
						 * column.
						 */
	BCPTEXTREC	*bd_textarray;
} BCPDESC;


/*
**  DBPROCESS - This is the basic DBLIB structure. It contains the command
**	sent to the dataserver as well as the results of the command.
**	It also includes any error or information messages, including the
**	done packet, returned by the dataserver.  If buffering is turned on,
**	this structure also stores the data rows.
*/
struct	dbprocess
{
	struct servbuf	*dbfile;	/* dataserver connection */
	DBUSMALLINT	dbstatus;	/* status field for dbprocess */
	BYTE		dbtoken;	/* current dataserver token */
	DBSTRING	*dbcmdbuf;	/* command buffer */
	int		dbcurcmd;	/* number of the current cmd results */
	DBINT		dbprocid;	/* procid, if any, of the current cmd */
	DBCOLINFO	*dbcols;	/* linked list of column information */
	DBALTHEAD	*dbalts;	/* linked list of alt column info */
	DBROW		*dbfirstdata;	/* doubly linked list of returned row
					 * data
					 */
	DBROW		*dbcurdata;	/* current row in dbfirstdata */
	DBROW		*dblastdata;	/* last row in dbfirstdata, usually
					 * dbcurdata
					 */
	DBOFF		*dboffsets;	/* list of offsets and controls in
					 * dbcmdbuf
					 */
	int		dboffadjust;	/* adjustment factor for offsets */
	DBSMALLINT	dbcuroffset;	/* active offset for results */
	DBOPTION	*dbopts;
	DBSTRING	*dboptcmd;	/* option string to send to server */
	DBINFO		*dbmsgs;	/* linked list of info and error
					 * messages
					 */
	DBINFO		*dbcurmsg;	/* last message read by dbgetmsg() */
	DBDONE		dbdone;		/* done information */
	char		dbcurdb[MAXNAME+1];	/* the name of the current
						 * database
						 */
	int		(*(*dbbusy)())(); /* function to call when waiting on
					   * dataserver
					   */
	void		(*dbidle)();	/* function to call when waiting on
					 * dataserver
					 */
	int		(*dbchkintr)();	/* user's function to call to check for
					 * queued interrupts
					 */
	int		(*dbhndlintr)();/* user's interrupt handler */
	int		dbbufsize;	/* the size of the row buffer, if
					 * enabled
					 */
	NULLBIND	dbnullbind;	/* what to bind for nulls */
	int		dbsticky;	/* sticky flags like attn */
	int		dbnumorders;	/* number of columns in the query's
					 * "order by" clause.
					 */
	int		*dbordercols;	/* array of the column numbers found in
					 * the query's "order by" clause.
					 */
	DBBOOL				dbavail;	/* is this dbproc available for general
					 * use?
					 */
	int		dbftosnum;	/* this id is used when recording the
					 * frontend-to-Server SQL traffic of
					 * this DBPROCESS.
					 */
	DBBOOL				dbdead;		/* TRUE if this DBPROCESS has become
					 * useless, usually due to a fatal
					 * Server error, or a communications
					 * failure.
					 */
	DBBOOL				dbenabled;	/* TRUE if this DBPROCESS is allowed to
					 * be used in DB-LIBRARY functions. The
					 * user may set this flag FALSE,
					 * possibly within an error handler, if
					 * execution of further commands would
					 * just cause further errors.
					 * DB-LIBRARY initially sets this flag
					 * TRUE. The user may set and re-set
					 * this flag at will.
					 */
	DBBOOL				dbsqlsent;	/* TRUE if the SQL in the command
					 * buffer has already been sent to
					 * the SQL Server.
					 */
	DBTABNAME	*dbtabnames;	/* linked-list of table-name
					 * information used by "browse mode".
					 */
	DBINT		dbspid;		/* The Server process-id of this
					 * DBPROCESS. It's returned in the
					 * row-count field of the done-packet
					 * which signifies a successful login.
					 */
	DBRETVAL	*dbretvals;	/* linked-list of function
					 * return-values.
					 */
	BCPDESC		*db_bcpdesc;	/* A structure containing bulk-copy
					 * information.
					 */
	DBBOOL				dbtransbegun;	/* Indicates that a text data transfer
					 * is under way.
					 */
	DBINT		dbbytesleft;	/* This is a countdown variable, used
					 * to track the number of bytes which
					 * are still to be sent as part of
					 * a dbwritetext() command.
					 */
	DBINT		dbretstat;	/* This is the return-status from
					 * a stored procedure.
					 */
	DBBOOL				dbhasretstat;	/* Is the return-status valid? */
	DBINT		dbtextlimit;	/* This is the longest text-column
					 * that this dbproc will accept
					 * from the Server. Any additional
					 * bytes will be discarded.
					 * If 0, then there's no limit.
					 */
	BYTE		*dbuserdata;	/* A pointer to any data that the
					 * the user wishes to associate with
					 * this DBPROCESS.
					 */
	DBINT		dbloginfailed;	/* The number of the Server message
					 * which describes the reason for
					 * this failed login.
					 */
	char		dblogin_node[MAXNAME + 1];
					/* The node that the Companion
					 * Server's redirector has
					 * recommended to us.
					 */
	int		dbcolcount;	/* The number of regular columns
					 * in the current set of results.
					 */

	DBBOOL		db_oldtds;	/* TRUE if the TDS version is older
					 * than 4.0.
					 */
	int		db_tdsversion;	/* tds version for this dbproc. */
#if VMS
	int		db_event_mask;	/* a mask used to determine what
					** event has happened in the front-
					** end i/o routines.
					*/
	long		db_event_flag;	/* the number of the event flag used
					** to check for timeout, interrupt 
					** (control_c) or i/o completion.
					*/
	short		db_io_channel;	/* channel assigned to sys$command
					** of the controlling process.
					*/
	short		r_iosb[4];	/* I/O status for read */
	short		w_iosb[4];	/* I/O status for write */				
#endif /* VMS */

	struct dbprocess	*dbnext;/* DBPROCESSes are kept track of
					 * in a big linked-list.
					 */
};
typedef struct dbprocess	DBPROCESS;

#define	DBTDS_2_0		1
#define	DBTDS_3_4		2
#define	DBTDS_4_0		3


/*
**  Various macros used to extract information from the DBPROCESS structure
*/
#define	DBTDS(a)	((a)->db_tdsversion)
#define	DBCURCMD(a)	((a)->dbcurcmd)
#define	DBCURROW(a)	((a)->dbcurdata == (DBROW *) NULL ? ((DBINT)0): (a)->dbcurdata->rowid)
#define	DBFIRSTROW(a)	((a)->dbfirstdata == (DBROW *) NULL ? ((DBINT)0): (a)->dbfirstdata->rowid)
#define	DBLASTROW(a)	((a)->dblastdata == (DBROW *) NULL ? ((DBINT)0): (a)->dblastdata->rowid)
#define	DBROWTYPE(a)	((a)->dbcurdata == (DBROW *) NULL ? (DBINT)NO_MORE_ROWS: \
	((a)->dbcurdata->rowaltid == 0 ? (DBINT)REG_ROW: (a)->dbcurdata->rowaltid))
#define	DBMORECMDS(a)	((a)->dbdone.donestatus & DONE_CONT ? SUCCEED: FAIL)
#define	DONECONTINUE(a)	((a)->dbdone.donestatus & DONE_CONT ? SUCCEED: FAIL)
#define	DBCOUNT(a)	((a)->dbdone.donestatus & DONE_COUNT ? (a)->dbdone.donecount : ((DBINT)(-1)))
#define	DBCMDROW(x)	((x)->dbcols == NULL ? FAIL: SUCCEED)
#define	DBROWS(x)	(((x)->dbstatus & READROW) ? SUCCEED: FAIL)
#define DBNUMORDERS(a)	((a)->dbnumorders)
#define DBBUFFULL(a)	(DBLASTROW(a) - DBFIRSTROW(a) + 1 >= (a)->dbbufsize ? \
	TRUE : FALSE)
#define DBMOREROWS(a)	(((a)->dbtoken == SYBROW) || ((a)->dbtoken == SYBALTROW) ? \
	TRUE : FALSE)
#define DBISAVAIL(a)	(((a)->dbavail) ? TRUE : FALSE)
#define DBGETTIMEOUT(a)	(DbTimeout)
#define DBGETTIME()	(DbTimeout)
#define DBDEAD(a)	((a)->dbdead)
#define DBIORDESC(a)	((a)->dbfile->serv_rnum)
#define DBIOWDESC(a)	((a)->dbfile->serv_snum)
#define DBRBUF(a)	(((a)->dbfile->serv_rleft || (!((a)->dbsticky & (DBUSMALLINT) 0x1))) ? ((DBBOOL)TRUE) : ((DBBOOL)FALSE))

#if (VMS)
#define DBZEROSPACE(dest, bytes)		db__bzero(dest, bytes)
#else
#define DBZEROSPACE(dest, bytes)		MEMZERO(dest, bytes)
#endif /* (VMS) */

/* These constants are used for RPC options. The first group are flags
 * in a 2-byte bitmask, so they'll be different on Suns and Vaxes. The second
 * group are flags in a 1-byte bitmask, so they should be machine-independent.
 */
#define DBRPCRECOMPILE	((DBSMALLINT)1)

#define DBRPCRETURN	((BYTE)1)

#if VMS
/* These constants are used for VMS network manipulation. */
#define	DB_IO_EVENT	1
#define	DB_INTERRUPT_EVENT 2
#define	DB_TIMER_EVENT	4
#endif /* VMS */

/*
** Macros to set values in the LOGINREC structure.
*/
#define	DBSETHOST	1
#define	DBSETUSER	2
#define	DBSETPWD	3
#define	DBSETHID	4
#define	DBSETAPP	5
#define	DBSETBCP	6
#define	DBSETLHOST(a,b)		dbsetlname((a), (b), DBSETHOST)
#define	DBSETLUSER(a,b)		dbsetlname((a), (b), DBSETUSER)
#define	DBSETLPWD(a,b)		dbsetlname((a), (b), DBSETPWD)
#define	DBSETLHID(a,b)		dbsetlname((a), (b), DBSETHID)
#define	DBSETLAPP(a,b)		dbsetlname((a), (b), DBSETAPP)
#define	DBSETLHIER(a,b)		((a)->lseclab.slhier = ((b) << 8) | ((b) >> 8) )
#define	DBGETLHIER(a)  (((a)->lseclab.slhier << 8) | ((a)->lseclab.slhier >> 8))
#define	DBSETLROLE(a,b)		((a)->lrole = b)
#define	DBGETLROLE(a)		( (a)->lrole )
#define	DBSETLCOMP(a,b)		dbbmove((BYTE*)(b), \
					(BYTE *) ((a)->lseclab.slcomp),\
					(DBINT) 8)
#define	DBSETONECOMP(a,b)	(a)[ ((b)-1)/8 ] |= ( 0x80 >> (( (b)-1 ) % 8) )
#define	DBUNSETONECOMP(a,b)	(a)[ ((b)-1)/8 ] &= ~( 0x80 >> (( (b)-1 ) % 8) )
#define	DBGETONECOMP(a,b)	(a)[ ((b)-1)/8 ] & ( 0x80 >> (( (b)-1 ) % 8) )

extern DBBOOL			DbDebug;
extern int	DbTime;
extern DBBOOL			DbIntrFlag;	/* True if an interrupt was typed. */
extern char	DbSeparator;
extern int	DbHeader;
extern int	DbTimeout;	/* default timeout value for DBPROCESSes. */
extern DBUSMALLINT	Compatibility_Mask;

/* bcp functions */
extern BCPDESC	*bcpinit();
extern RETCODE	bcpcontrol();
extern RETCODE	bcpcolumn();
extern RETCODE	bcpformat();
extern RETCODE	bcpexec();
extern RETCODE	bcpbind();
extern RETCODE	bcpsendrow();
extern RETCODE	bcpabort();
extern RETCODE	bcpcollen();
extern DBINT	bcpdone();

/* DB-LIBRARY minor error numbers */
#define SYBESYNC	20001	/* Read attempted while out of synchronization
				 * with SQL Server.
				 */
#define SYBEFCON	20002	/* SQL Server connection failed. */
#define SYBETIME	20003	/* SQL Server connection timed out. */
#define SYBEREAD	20004	/* Read from SQL Server failed. */
#define SYBEBUFL	20005	/* DB-LIBRARY internal error - send buffer
				 * length corrupted.
				 */
#define SYBEWRIT	20006	/* Write to SQL Server failed. */
#define SYBEVMS		20007	/* Sendflush: VMS I/O error. */
#define SYBESOCK	20008	/* Unable to open socket */
#define SYBECONN	20009	/* Unable to connect socket -- SQL Server is
				 * unavailable or does not exist.
				 */
#define SYBEMEM		20010	/* Unable to allocate sufficient memory */
#define SYBEDBPS	20011	/* Maximum number of DBPROCESSes
				 * already allocated.
				 */
#define SYBEINTF	20012	/* Server name not found in interface file */
#define SYBEUHST	20013	/* Unknown host machine name */
#define SYBEPWD		20014	/* Incorrect password. */
#define	SYBEOPIN	20015	/* Could not open interface file. */
#define SYBEINLN	20016	/* Interface file: unexpected end-of-line. */
#define SYBESEOF	20017	/* Unexpected EOF from SQL Server. */
#define SYBESMSG	20018	/* General SQL Server error: Check messages
				 * from the SQL Server.
				 */
#define SYBERPND	20019	/* Attempt to initiate a new SQL Server
				 * operation with results pending.
				 */
#define SYBEBTOK	20020	/* Bad token from SQL Server: Data-stream
				 * processing out of sync.
				 */
#define SYBEITIM	20021	/* Illegal timeout value specified. */
#define SYBEOOB		20022	/* Error in sending out-of-band data to
				 * SQL Server.
				 */
#define SYBEBTYP	20023	/* Unknown bind type passed to DB-LIBRARY
				 * function.
				 */
#define	SYBEBNCR	20024	/* Attempt to bind user variable to a
				 * non-existent compute row.
				 */
#define SYBEIICL	20025	/* Illegal integer column length returned by
				 * SQL Server. Legal integer lengths are 1, 2,
				 * and 4 bytes.
				 */
#define SYBECNOR 	20026	/* Column number out of range. */
#define SYBENPRM	20027	/* NULL parameter not allowed for this
				 * dboption.
				 */
#define SYBEUVDT 	20028	/* Unknown variable-length datatype encountered.
				 */
#define SYBEUFDT 	20029	/* Unknown fixed-length datatype encountered. */
#define SYBEWAID	20030	/* DB-LIBRARY internal error: ALTFMT following
				 * ALTNAME has wrong id.
				 */
#define SYBECDNS	20031	/* Datastream indicates that a compute column is
				 * derived from a non-existent select-list
				 * member.
				 */
#define SYBEABNC	20032	/* Attempt to bind to a non-existent column. */
#define SYBEABMT	20033	/* User attempted a dbbind() with mismatched
				 * column and variable types.
				 */
#define SYBEABNP	20034	/* Attempt to bind using NULL pointers. */
#define SYBEAAMT	20035	/* User attempted a dbaltbind() with mismatched
				 * column and variable types.
				 */
#define SYBENXID	20036	/* The Server did not grant us a
				 * distributed-transaction ID.
				 */
#define SYBERXID	20037	/* The Server did not recognize our
				 * distributed-transaction ID.
				 */
#define SYBEICN		20038	/* Invalid computeid or compute column number.
				 */
#define SYBENMOB	20039	/* No such member of 'order by' clause. */
#define SYBEAPUT	20040	/* Attempt to print unknown token. */
#define SYBEASNL	20041	/* Attempt to set fields in a null loginrec. */
#define SYBENTLL	20042	/* Name too long for loginrec field. */
#define SYBEASUL	20043	/* Attempt to set unknown loginrec field. */
#define SYBERDNR	20044	/* Attempt to retrieve data from a non-existent
				 * row.
				 */
#define SYBENSIP	20045	/* Negative starting index passed to dbstrcpy().
				 */
#define SYBEABNV	20046	/* Attempt to bind to a NULL program variable.
				 */
#define SYBEDDNE	20047	/* DBPROCESS is dead or not enabled. */
#define SYBECUFL	20048	/* Data-conversion resulted in underflow. */
#define SYBECOFL	20049	/* Data-conversion resulted in overflow. */
#define SYBECSYN	20050	/* Attempt to convert data stopped by syntax
				 * error in source field.
				 */
#define SYBECLPR	20051	/* Data-conversion resulted in loss of
				 * precision.
				 */
#define SYBECNOV	20052	/* Attempt to set variable to NULL resulted
				 * in overflow.
				 */
#define SYBERDCN	20053	/* Requested data-conversion does not exist. */
#define SYBESFOV	20054	/* dbsafestr() overflowed its destination
				 * buffer.
				 */
#define SYBEUNT		20055	/* Unknown network type found in
				 * interface file.
				 */
#define SYBECLOS	20056	/* Error in closing network connection. */
#define SYBEUAVE	20057	/* Unable to allocate VMS event flag. */
#define SYBEUSCT	20058	/* Unable to set communications timer. */
#define SYBEEQVA	20059	/* Error in queueing VMS AST routine. */
#define SYBEUDTY	20060	/* Unknown datatype encountered. */
#define SYBETSIT	20061	/* Attempt to call dbtsput() with an
				 * invalid timestamp.
				 */
#define SYBEAUTN	20062	/* Attempt to update the timestamp of a table
				 * which has no timestamp column.
				 */
#define SYBEBDIO	20063	/* Bad bulk-copy direction.  Must be either
				 * IN or OUT.
				 */
#define SYBEBCNT	20064	/* Attempt to use Bulk Copy with a non-existent
				 * Server table.
				 */
#define SYBEIFNB	20065	/* Illegal field number passed to bcp_control().
				 */
#define SYBETTS		20066	/* The table which bulk-copy is attempting to
				 * copy to a host-file is shorter than the
				 * number of rows which bulk-copy was instructed
				 * to skip.
				 */
#define SYBEKBCO	20067	/* 1000 rows successfully bulk-copied to
				 * host-file.
				 */
#define SYBEBBCI	20068	/* Batch successfully bulk-copied to SQL Server.
				 */
#define SYBEKBCI	20069	/* Bcp: 1000 rows sent to SQL Server. */
#define SYBEBCRE	20070	/* I/O error while reading bcp data-file. */
#define SYBETPTN	20071	/* Syntax error: only two periods are permitted
				 * in table names.
				 */
#define SYBEBCWE	20072	/* I/O error while writing bcp data-file. */
#define SYBEBCNN	20073	/* Attempt to bulk-copy a NULL value into
				 * Server column %d,  which does not accept
				 * NULL values.
				 */
#define SYBEBCOR	20074	/* Attempt to bulk-copy an oversized row to the
				 * SQL Server.
				 */
#define SYBEBCIS	20075	/* Attempt to bulk-copy an illegally-sized
				 * column value to the SQL Server.
				 */
#define SYBEBCPI	20076	/* bcp_init() must be called before any other
				 * bcp routines.
				 */
#define SYBEBCPN	20077	/* bcp_bind(), bcp_collen() and bcp_colptr()
				 * may be used only after bcp_init() has been
				 * called with the copy direction set to DB_IN.
				 */
#define SYBEBCPB	20078	/* bcp_bind() may NOT be used after bcp_init()
				 * has been passed a non-NULL input file name.
				 */
#define SYBEVDPT	20079	/* For bulk copy, all variable-length data
				 * must have either a length-prefix or a
				 * terminator specified.
				 */
#define SYBEBIVI	20080	/* bcp_columns() and bcp_colfmt() may be used
				 * only after bcp_init() has been passed a
				 * valid input file.
				 */
#define SYBEBCBC	20081	/* bcp_columns() must be called before
				 * bcp_colfmt().
				 */
#define SYBEBCFO	20082	/* Bcp host-files must contain at least one
				 * column.
				 */
#define SYBEBCVH	20083	/* bcp_exec() may be called only after
				 * bcp_init() has been passed a valid host file.
				 */
#define SYBEBCUO	20084	/* Bcp: Unable to open host data-file. */
#define SYBEBCUC	20085	/* Bcp: Unable to close host data-file. */
#define SYBEBUOE	20086	/* Bcp: Unable to open error-file. */
#define SYBEBUCE	20087	/* Bcp: Unable to close error-file. */
#define SYBEBWEF	20088	/* I/O error while writing bcp error-file. */
#define SYBEASTF	20089	/* VMS: Unable to setmode for control_c ast. */
#define	SYBEUACS	20090	/* VMS: Unable to assign channel to sys$command.
				 */
#define SYBEASEC	20091	/* Attempt to send an empty command buffer to
				 * the SQL Server.
				 */
#define SYBETMTD	20092	/* Attempt to send too much TEXT data via the
				 * dbmoretext() call.
				 */
#define SYBENTTN	20093	/* Attempt to use dbtxtsput() to put a new
				 * text-timestamp into a non-existent data row.
				 */
#define SYBEDNTI	20094	/* Attempt to use dbtxtsput() to put a new
				 * text-timestamp into a column whose datatype
				 * is neither SYBTEXT nor SYBIMAGE.
				 */
#define SYBEBTMT	20095	/* Attempt to send too much TEXT data via the
				 * bcp_moretext() call.
				 */
#define SYBEORPF	20096	/* Attempt to set remote password would
				 * overflow the login-record's remote-password
				 * field.
				 */
#define SYBEUVBF	20097	/* Attempt to read an unknown version of BCP
				 * format-file.
				 */
#define SYBEBUOF	20098	/* Bcp: Unable to open format-file. */
#define SYBEBUCF	20099	/* Bcp: Unable to close format-file. */
#define SYBEBRFF	20100	/* I/O error while reading bcp format-file. */
#define SYBEBWFF	20101	/* I/O error while writing bcp format-file. */
#define SYBEBUDF	20102	/* Bcp: Unrecognized datatype found in
				 * format-file.
				 */
#define SYBEBIHC	20103	/* Incorrect host-column number found in bcp
				 * format-file.
				 */
#define SYBEBEOF	20104	/* Unexpected EOF encountered in BCP data-file.
				 */
#define SYBEBCNL	20105	/* Negative length-prefix found in BCP
				 * data-file.
				 */
#define SYBEBCSI	20106	/* Host-file columns may be skipped only when
				 * copying INto the Server.
				 */
#define SYBEBCIT	20107	/* It's illegal to use BCP terminators with
				 * program variables other than
				 * SYBCHAR, SYBBINARY, SYBTEXT, or SYBIMAGE.
				 */
#define SYBEBCSA	20108	/* The BCP hostfile '%s' contains only %ld
				 * rows. Skipping all of these rows is not
				 * allowed.
				 */
#define SYBENULL	20109	/* NULL DBPROCESS pointer passed to DB-Library.
				 */
#define SYBEUNAM	20110	/* Unable to get current username from
				 * operating system.
				 */
#define SYBEBCRO	20111	/* The BCP hostfile '%s' contains only %ld
				 * rows. It was impossible to read the
				 * requested %ld rows.
				 */
#define SYBEMPLL	20112	/* Attempt to set maximum number of DBPROCESSes
				 * lower than 1.
				 */
#define SYBERPIL	20113	/* It is illegal to pass -1 to dbrpcparam()
				 * for the datalen of parameters which are of
				 * type SYBCHAR, SYBVARCHAR, SYBBINARY, or
				 * SYBVARBINARY.
				 */
#define SYBERPUL	20114	/* When passing a SYBINTN parameter via
				 * rpcparam(), it's necessary to specify the
				 * parameter's maximum or actual length, so
				 * that DB-Library can recognize it as a
				 * SYBINT1, SYBINT2, or SYBINT4.
				 */
#define SYBEUNOP	20115	/* Unknown option passed to dbsetopt(). */
#define SYBECRNC	20116	/* The current row is not a result of compute
				 * clause %d, so it is illegal to attempt to
				 * extract that data from this row.
				 */
#define	SYBERTCC	20117	/* dbreadtext() may not be used to receive
				 * the results of a query which contains a
				 * COMPUTE clause.
				 */
#define SYBERTSC	20118	/* dbreadtext() may only be used to receive
				 * the results of a query which contains a
				 * single result column.
				 */
#define SYBEUCRR	20119	/* Internal software error: Unknown
				 * connection result reported by						 * dbpasswd().
				 */
#define SYBERPNA	20120	/* The RPC facility is available only when
				 * using a SQL Server whose version number
				 * is 4.0 or greater.
				 */
#define SYBEOPNA	20121	/* The text/image facility is available only
				 * when using a SQL Server whose version number
				 * is 4.0 or greater.
				 */
#define SYBEFGTL	20122   /* Bcp: Row number for the first row to be 
				** copied cannot be greater than the row 
				** number for the last row to be copied.
				*/
#define SYBEACNV	20123	/* Attempt to do conversion with NULL 
				** destination variable.
				*/
#define SYBENTST        20124   /* The file being opened must be a stream_lf.
				*/

/* Forward declarations of DB-LIBRARY routines */

RETCODE		abort_xact();
void		close_commit();
RETCODE		commit_xact();

DBINT		bcp_batch();
RETCODE		bcp_bind();
RETCODE		bcp_colfmt();
RETCODE		bcp_collen();
RETCODE		bcp_colptr();
RETCODE		bcp_columns();
RETCODE		bcp_control();
DBINT		bcp_done();
RETCODE		bcp_exec();
RETCODE		bcp_init();
RETCODE		bcp_moretext();
RETCODE		bcp_sendrow();

int		datetochar();
BYTE		*dbadata();
DBINT		dbadlen();
int		dballcols();
RETCODE		dbaltbind();
int		dbaltcolid();
DBINT		dbaltlen();
char		*dbaltname();
int		dbaltop();
int		dbalttype();
RETCODE		dbbind();
BYTE		*dbbylist();
void		db__bzero();
RETCODE		dbcancel();
RETCODE		dbcanquery();
char		*dbchange();
void		dbclose();
void		dbclrbuf();
RETCODE		dbclropt();
RETCODE		dbcmd();
DBBOOL				dbcolbrowse();
DBINT		dbcollen();
char		*dbcolname();
char		*dbcolsource();
int		dbcoltype();
char		*dbcolufmt();
char		*dbcontrolcmd();
DBINT		dbconvert();
DBINT		(*dbcvtproc())();
BYTE		*dbdata();
DBINT		dbdatlen();
int		(*dberrhandle())();
int		dberrno();
char		*dberrstr();
void		dbexit();
RETCODE		dbfcmd();
void		dbfprhead();
void		dbfreebuf();
void		dbfreequal();
char		*dbgetchar();
int			dbgetmaxprocs();
char		*dbgetmsg();
int		dbgetoff();
STATUS		dbgetrow();
BYTE		*dbgetuserdata();
DBBOOL				dbhasretstat();
RETCODE		dbinit();
DBBOOL				dbisopt();
BYTE		*dbkeydata();
DBINT		dbkeydlen();
LOGINREC	*dblogin();
void		dbloginfree();
int		(*dbmsghandle())();
RETCODE		dbmoretext();
char		*dbname();
STATUS		dbnextrow();
int		dbnumalts();
int		dbnumcols();
int		dbnumcompute();
int		dbnumkeys();
int		dbnummsg();
int		dbnumrets();
DBPROCESS	*dbopen();
int		dbordercol();
char		*dboserrstr();
void		dbperror();
void		dbprhead();
RETCODE		dbprrow();
char		*dbprtype();
char		*dbqual();
DBINT		dbreadpage();
void		dbrecftos();
RETCODE		dbresults();
BYTE		*dbretdata();
DBINT		dbretlen();
char		*dbretname();
DBINT		dbretstatus();
int		dbrettype();
RETCODE		dbrpcinit();
RETCODE		dbrpcparam();
RETCODE		dbrpcsend();
void		dbrpwclr();
RETCODE		dbrpwset();
RETCODE		dbsafestr();
char		*dbservermsg();
void		dbsetavail();
void		dbsetbusy();
RETCODE		dbsetconnect();
void		dbsetidle();
void		dbsetifile();
void		dbsetinterrupt();
RETCODE		dbsetlbool();
RETCODE		dbsetlname();
RETCODE		dbsetlogintime();
RETCODE		dbsetmaxprocs();
DBBOOL				dbsetmsg();
RETCODE		dbsetnull();
RETCODE		dbsetopt();
RETCODE		dbsettime();
RETCODE		dbsettimeout();
RETCODE		dbsetufmt();
void		dbsetuserdata();
RETCODE		dbsqlexec();
RETCODE		dbsqlok();
RETCODE		dbsqlsend();
RETCODE		dbstrcpy();
int		dbstrlen();
DBBOOL				dbtabbrowse();
int		dbtabcount();
char		*dbtabname();
char		*dbtabsource();
DBBINARY	*dbtimestamp();
int		dbtslen();
char		*dbtsname();
int		dbtsnewlen();
DBBINARY	*dbtsnewval();
RETCODE		dbtsput();
RETCODE		dbtxplen();
DBBINARY	*dbtxptr();
DBBINARY	*dbtxtimestamp();
DBBINARY	*dbtxtsnewval();
RETCODE		dbtxtsput();
RETCODE		dbuse();
DBBOOL		dbvarylen();
DBBOOL				dbwillconvert();
RETCODE		dbwritepage();
RETCODE		dbwritetext();
char		*mnytochar();
DBPROCESS	*open_commit();
DBINT		start_xact();

/* VMS programs can use the AST facility to write asynchronous DB-LIBRARY
 * programs.
 */

#if VMS
extern RETCODE	dbcancel_a();
extern RETCODE	dbcanquery_a();
extern RETCODE	dbnextrow_a();
extern RETCODE	dbopen_a();
extern RETCODE	dbresults_a();
extern RETCODE	dbsqlexec_a();
extern RETCODE	dbsqlok_a();
#endif /* VMS */
