/*
 *	sybfront.h	62.3	26/6/90
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

/*
**	Languages
*/

#define	SYB_C		0
#define	SYB_FORTRAN	1
#define	SYB_COBOL	2
#define SYB_ADA		3
#define	SYB_VERDIX_ADA	4

/*
**	Return types
*/


typedef int		RETCODE;	/* SUCCEED or FAIL */
typedef	int		STATUS;		/* OK or condition code */

#ifndef NULL
#define NULL		0
#endif	/*  NULL  */

#ifndef FALSE
#define FALSE		0
#endif	/*  FALSE  */

#ifndef TRUE
#define TRUE		1
#endif	/*  TRUE  */

#define	SUCCEED		1
#define	FAIL		0

/*
**	Defines for exit
*/

#ifndef STDEXIT
#define	STDEXIT		0
#endif  /*  ifndef STDEXIT  */

#ifndef ERREXIT
#define	ERREXIT		-1
#endif  /*  ifndef ERREXIT  */

/*
** 	Defines for the "answer" in interrupt pop-ups 
*/

#define INT_EXIT	0
#define INT_CONTINUE	1
#define INT_CANCEL	2


/* DataServer variable typedefs */
typedef	unsigned char	DBTINYINT;	/* DataServer 1 byte integer */
typedef	short		DBSMALLINT;	/* DataServer 2 byte integer */
typedef	long		DBINT;		/* DataServer 4 byte integer */
typedef	char		DBCHAR;		/* DataServer char type */
typedef	unsigned char	DBBINARY;	/* DataServer binary type */
typedef	unsigned char	DBBIT;		/* DataServer bit type */
typedef struct datetime			/* DataServer datetime type */
{
	long	dtdays;			/* number of days since 1/1/1900 */
	long	dttime;			/* number 300th second since mid */
} DBDATETIME;
typedef struct money			/* DataServer money type */
{
	long		mnyhigh;
	unsigned long	mnylow;
} DBMONEY;
typedef	double		DBFLT8;		/* DataServer float type */

/*	
**	Typedefs
*/

typedef unsigned char	BYTE;
typedef unsigned char	DBBOOL;	/* Less likely to collide than "BOOL". */
typedef BYTE		*POINTER;

/*
**	Pointers to functions returning ...
*/

typedef	int		(*INTFUNCPTR)();
typedef	DBBOOL		(*BOOLFUNCPTR)();


/*
**	REGION - Rectangular Area.
*/

typedef	struct	region
{
	short		rgx;		/* Starting (upper left) coordinates */
	short		rgy;
	short		rgwidth;	/* Width (horizontal extent) */
	short		rgheight;	/* Height (vertical extent) */
} REGION;
