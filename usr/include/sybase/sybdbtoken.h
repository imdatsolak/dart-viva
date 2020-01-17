/*
 *	sybdbtoken.h	62.1	4/10/90
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

# define SYBTLEND		0x01
# define SYBQLEND		0x02
# define SYBDBAID		0x05
# define SYBSITE		0x08
# define SYBHST			0x0a
# define SYBDBCLOSE		0x13
# define SYBVARCHNE		0x1e
# define SYBVOID		0x1f
# define SYBVARBINNE		0x20
# define SYBVARCHEQ		0x21
# define SYBVARBINEQ		0x22
# define SYBTEXT		0x23
# define SYBARRAY		0x24
# define SYBVARBINARY		0x25
# define SYBINTN		0x26
# define SYBVARCHAR		0x27
# define SYBVAR			0x28
# define SYBOPTIONS		0x29
# define SYBCOLFMT		0xa1
# define SYBPARAM		0x2b
# define SYBPCHAR		0x2c
# define SYBBINARY		0x2d
# define SYBIMAGE		0x22
# define SYBCHAR		0x2f
# define SYBINT1		0x30
# define SYBBIT			0x32
# define SYBINT2		0x34
# define SYBINT4		0x38
# define SYBROWCRC		0x39
# define SYBMONEY		0x3c
# define SYBDATETIME		0x3d
# define SYBFLT8		0x3e
# define SYBABS			0x40
# define SYBMINUS		0x41
# define SYBNOT			0x42
# define SYBCNVTI1		0x43
# define SYBCNVTI2		0x44
# define SYBCNVTI4		0x45
# define SYBBUILTIN		0x46
# define SYBCNVTF8		0x47
# define SYBCNVTVBINARY		0x48
# define SYBCNVTBINARY		0x49
# define SYBAOPONCEU		0x4a
# define SYBAOPCNT		0x4b
# define SYBAOPCNTU		0x4c
# define SYBAOPSUM		0x4d
# define SYBAOPSUMU		0x4e
# define SYBAOPAVG		0x4f
# define SYBAOPAVGU		0x50
# define SYBAOPMIN		0x51
# define SYBAOPMAX		0x52
# define SYBAOPANY		0x53
# define SYBAOPONCE		0x54
# define SYBAOPASSIGN		0x55
# define SYBAOPNOOP		0x56
# define SYBCNVTBIT		0x59
# define SYBBOOLNOT		0x5a
# define SYBTOKENAME		0x5c
# define SYBSIN			0x5d
# define SYBCOS			0x5e
# define SYBTAN			0x5f
# define SYBDEBUG_CMD		0x60
# define SYBGETDEFAULT		0x67
# define SYBCNVTDATTIM		0x68
# define SYBCNVTMONEY		0x69
# define SYBFLTN		0x6d
# define SYBMONEYN		0x6e
# define SYBDATETIMN		0x6f
# define SYBORDERA		0x70
# define SYBCNVTVCHAR		0x71
# define SYBORDERD		0x72
# define SYBCNVTCHAR		0x73
# define SYBTPE			0x75
# define SYBCOMPHD		0x76
# define SYBSETUSER		0x77
# define SYBOFFSET		0x78
# define SYBRETURNSTATUS	0x79
# define SYBPROCID		0x7c
# define SYBRESDOM		0x80
# define SYBEQ			0x81
# define SYBLT			0x82
# define SYBLE			0x83
# define SYBGT			0x84
# define SYBGE			0x85
# define SYBNE			0x86
# define SYBAND			0x88
# define SYBOR			0x89
# define SYBADD			0x8a
# define SYBSUB			0x8b
# define SYBMUL			0x8c
# define SYBDIV			0x8d
# define SYBBYHEAD		0x8e
# define SYBAGHEAD		0x8f
# define SYBCONCAT		0x90
# define SYBMOD			0x91
# define SYBALL			0x92
# define SYBORDERDOM		0x93
# define SYBDOMAIN		0x98
# define SYBGETNULL		0x99
# define SYBSEQUENCE		0x9a
# define SYBBOOLAND		0x9c
# define SYBBOOLOR		0x9d
# define SYBGETBIT		0x9e
# define SYBBOOLXOR		0x9f
# define SYBCOLNAME		0xa0
# define SYBSTOPEQ		0xa1
# define SYBSTOPLT		0xa2
# define SYBSTOPLE		0xa3
# define SYBTABNAME		0xa4
# define SYBCOLINFO		0xa5
# define SYBMULTARG		0xa6
# define SYBALTNAME		0xa7
# define SYBALTFMT		0xa8
# define SYBORDER		0xa9
# define SYBERROR		0xaa
# define SYBINFO		0xab
# define SYBRETURNVALUE		0xac
# define SYBLOGINACK		0xad
# define SYBCONTROL		0xae
# define SYBALTCONTROL		0xaf
# define SYBWITH		0xb0
# define SYBMEASURE		0xb3
# define SYBROOT		0xb4
# define SYBSEQ			0xb5
# define SYBCMD			0xb6
# define SYBSETON		0xb9
# define SYBSETOFF		0xba
# define SYBSETSTATON		0xbb
# define SYBSETSTATOFF		0xbc
# define SYBSETRCON		0xbd
# define SYBCOND		0xc0
# define SYBSELECT		0xc1
# define SYBSELECT_INTO		0xc2
# define SYBINSERT		0xc3
# define SYBDELETE		0xc4
# define SYBUPDATE		0xc5
# define SYBTABCREATE		0xc6
# define SYBTABDESTROY		0xc7
# define SYBINDCREATE		0xc8
# define SYBINDDESTROY		0xc9
# define SYBGOTO		0xca
# define SYBDBCREATE		0xcb
# define SYBDBDESTROY		0xcc
# define SYBGRANT		0xcd
# define SYBREVOKE		0xce
# define SYBVIEWCREATE		0xcf
# define SYBVIEWDESTROY		0xd0
# define SYBROW			0xd1
# define SYBABORT		0xd2
# define SYBALTROW		0xd3
# define SYBBEGINXACT		0xd4
# define SYBENDXACT		0xd5
# define SYBSAVEXACT		0xd6
# define SYBDBEXTEND		0xd7
# define SYBALTERTAB		0xd8
# define SYBAUDIT		0xd9
# define SYBAUDIT_INTO		0xda
# define SYBRETURN		0xdb
# define SYBCONFIG		0xdc
# define SYBTRIGCREATE		0xdd
# define SYBPROCCREATE		0xde
# define SYBPROCDESTROY		0xdf
# define SYBEXECUTE		0xe0
# define SYBTRIGDESTROY		0xe1
# define SYBDBOPEN		0xe2
# define SYBRANGE		0xe3
# define SYBDUMPDB		0xe4
# define SYBLOADDB		0xe5
# define SYBDBCC_CMD		0xe6
# define SYBCHECKPOINT		0xe7
# define SYBDECLARE		0xe8
# define SYBDEFAULTCREATE	0xe9
# define SYBTRUNCATETABLE	0xea
# define SYBDUMPXACT		0xeb
# define SYBRULECREATE		0xec
# define SYBRULEDESTROY		0xed
# define SYBSECLEVEL		0xed	/* same as SYBRULEDESTROY */
# define SYBDEFAULTDESTROY	0xee
# define SYBLOADXACT		0xef
# define SYBBULKINSERT		0xf0
# define SYBUPDATESTATS		0xf1
# define SYBDISKBUILD		0xf2
# define SYBWAITFOR		0xf3
# define SYBPREPARE		0xf4
# define SYBKILL		0xf5
# define SYBRAISERROR		0xf6
# define SYBPRINT		0xf7
# define SYBEXECP		0xf8
# define SYBSETDATE		0xf9
# define SYBSETTIME		0xfa
# define SYBDONE		0xfd
# define SYBDONEPROC		0xfe
# define SYBDONEINPROC		0xff

/* Builtin-function tokens--these must not change between releases */
# define SYBGETDATE		0
# define SYBIFUPDATE		1
# define SYBCNVTONAME		2
# define SYBCNVTOID		3
# define SYBUSERNAME		4
# define SYBUSERID		5
# define SYBSUSERID		6
# define SYBSUSERNAME		7
# define SYBDATABID		8
# define SYBDATABNAME		9
# define SYBHOSTID		10
# define SYBHOSTNAME		11
# define SYBSUBSTR		12
# define SYBDATEPART		13
# define SYBCNVTCNAME		14
# define SYBLIKE		15
# define SYBDATEDIFF		16
# define SYBDATEADD		17
# define SYBCHARINDEX		18
# define SYBCOLLENGTH		19
# define SYBISNULL		20
# define SYBINDKEY		21
# define SYBDATENAME		22
# define SYBCONVERT		23
