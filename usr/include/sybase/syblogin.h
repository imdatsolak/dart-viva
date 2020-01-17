/*
 *	syblogin.h	62.1	4/10/90
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

#define DBPROGNLEN	10

typedef struct seclab
{
	short	slhier;
	BYTE	slcomp[8];
	short	slspare;
} SECLAB;

typedef struct loginrec
{
	BYTE	lhostname[MAXNAME];	/* name of host or generic */
	BYTE	lhostnlen;		/* length of lhostname */
	BYTE	lusername[MAXNAME];	/* name of user */
	BYTE	lusernlen;		/* length of lusername */
	BYTE	lpw[MAXNAME];		/* password (plaintext) */
	BYTE	lpwnlen;		/* length of lpw */
	BYTE	lhostproc[MAXNAME];	/* host process identification*/
	BYTE	lhplen;			/* length of host process id */
	BYTE	lint2;			/* type of int2 on this host */
	BYTE	lint4;			/* type of int4 on this host */
	BYTE	lchar;			/* type of char */
	BYTE	lflt;			/* type of float */
	BYTE	ldate;			/* type of datetime */
	BYTE	lusedb;			/* notify on exec of use db cmd */
	BYTE	ldmpld;			/* disallow use of dump/load and
					** bulk insert */
	BYTE	linterface;		/* SQL interface type */
	BYTE	ltype;			/* type of network connection */
	BYTE	spare[7];		/* spare fields */
	BYTE	lappname[MAXNAME];	/* application name */
	BYTE	lappnlen;		/* length of appl name */
	BYTE	lservname[MAXNAME];	/* name of server */
	BYTE	lservnlen;		/* length of lservname */
	BYTE	lrempw[0xff];		/* passwords for remote servers */
	BYTE	lrempwlen;		/* length of lrempw */
	BYTE	ltds[4];		/* tds version */
	BYTE	lprogname[DBPROGNLEN];	/* client program name */
	BYTE	lprognlen;		/* length of client program name */
	BYTE	lprogvers[4];		/* client program version */
	BYTE	ldummy[2];		/* pad length to longword */
	BYTE	spare1;			/* structure alignment */
	SECLAB	lseclab;		/* login security level */
	BYTE	lrole;			/* login role(sa = 1,user = 0 */
	BYTE	spare2[3];		/* pad length to longword */
} LOGINREC;

/* possible storage types */
# define INT4_LSB_HI	0	/* lsb is hi byte (eg 68000) */
# define INT4_LSB_LO	1	/* lsb is low byte (eg VAX & 80x86) */
# define INT2_LSB_HI	2	/* lsb is hi byte (eg 68000) */
# define INT2_LSB_LO	3	/* lsb is low byte (eg VAX & 80x86) */
# define FLT_IEEE_HI	4	/* IEEE 754 float, lsb in high byte (eg Sun) */
# define FLT_IEEE_LO	10	/* IEEE 754 float, lsb in low byte (eg 80x86) */
# define FLT_VAXD	5	/* VAX 'D' floating point format */
# define CHAR_ASCII	6	/* ASCII character set */
# define CHAR_EBCDIC	7	/* EBCDIC character set */
# define TWO_I4_LSB_HI	8	/* lsb is hi byte (eg 68000) */
# define TWO_I4_LSB_LO	9	/* lsb is low byte (eg VAX & 80x86) */

/* values for Sun DB-Library 
**	lint2 = INT2_LSB_HI
**	lint4 = INT4_LSB_HI
**	lchar = CHAR_ASCII
**	lflt = FLT_IEEE_HI
**	ldate = TWO_I4_LSB_HI 
*/

/* values for VAX DB-Library 
**	lint2 = INT2_LSB_LO
**	lint4 = INT4_LSB_LO
**	lchar = CHAR_ASCII
**	lflt = FLT_VAXD
**	ldate = TWO_I4_LSB_LO 
*/

/* values for I86 (Intel 80x86) DB-Library 
**	lint2 = INT2_LSB_LO
**	lint4 = INT4_LSB_LO
**	lchar = CHAR_ASCII
**	lflt = FLT_IEEE_LO
**	ldate = TWO_I4_LSB_LO 
*/

/* Values for linterface field. */
#define	LDEFSQL		0		/* server's default SQL will be sent */
#define	LXSQL		1		/* TRANSACT-SQL will be sent */
#define	LSQL		2		/* ANSI SQL, version 1 */
#define	LSQL2_1		3		/* ANSI SQL, version 2, level 1 */
#define	LSQL2_2		4		/* ANSI SQL, version 2, level 2 */

/* Values for ltype field. */
#define	LSERVER		0x1		/* not a user connecting directly */
#define	LREMUSER	0x2		/* user login through another server */
