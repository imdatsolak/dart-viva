#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "ImageManager.h"

#import "AttachmentItem.h"

#pragma .h #import <objc/Object.h>

@implementation AttachmentItem:Object
{
	id		position;
	id		identity;
	id		description;
	id		supplDescription;
	id		bulkdataid;
	id		imageObject;
	BOOL	edited;
}

- initPosition:aPosition identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid
{
	[self init];
	position			= [aPosition copy];
	identity			= [anIdentity copy];
	description			= [aDescription copy];
	supplDescription	= [aSupplDescription copy];
	bulkdataid			= [aBulkdataid copy];
	edited				= NO;
	imageObject			= nil;
	return self;
}

- initIdentity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid
{
	id	zero = [Integer int:0];
	[self initPosition:zero identity:anIdentity description:aDescription supplDescription:aSupplDescription bulkdataid:aBulkdataid];
	[zero free];
	return self;
}

- copy
{
	id	theCopy 	= [super copy];
	position		= [position copy];
	identity		= [identity copy];
	description		= [description copy];
	supplDescription= [supplDescription copy];
	bulkdataid		= [bulkdataid copy];
	return theCopy;
}

- free
{
	[position free];
	[identity free];
	[description free];
	[supplDescription free];
	[bulkdataid free];
	return [super free];
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteObject(stream, position);
	NXWriteObject(stream, identity);
	NXWriteObject(stream, description);
	NXWriteObject(stream, supplDescription);
	NXWriteObject(stream, bulkdataid);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	position = NXReadObject(position);
	identity = NXReadObject(identity);
	description = NXReadObject(description);
	supplDescription = NXReadObject(supplDescription);
	bulkdataid = NXReadObject(bulkdataid);
	return self;
}

- appendFieldsToQueryString:queryString
{
	[queryString concatFieldComma:position];
	[queryString concatSTR:"\""];
	[queryString concatSTR:[[self class] name]];
	[queryString concatSTR:"\", "];
	[queryString concatFieldComma:identity];
	[queryString concatFieldComma:description];
	[queryString concatFieldComma:supplDescription];
	[queryString concatField:bulkdataid];
	return self;
}

- (BOOL)isSaveable
{
	return YES;
}

- (BOOL)saveYourBulkdataIfNecessary
{
	return YES;
}

- open:sender
{
	return self;
}

- (int)compare:anotherObject
{
	return [position compare:[anotherObject position]];
}

- (const char *)miniIcon 
{
	return [[[NXApp imageMgr] iconFor:"MiniTXT"] name];
}

- (BOOL)isEdited { return edited; }
- setEdited:(BOOL)flag { edited = flag; return self; }

- imageObject { return imageObject; }
- setImageObject:anIcon { imageObject = anIcon; return self; }

- position { return position; }
- setPosition:anObject { [position free]; position = [anObject copy]; return self; }
- identity { return identity; }
- setIdentity:anObject { [identity free]; identity = [anObject copy]; return self; }
- bulkdataid { return bulkdataid; }
- setBulkdataid:anObject { [bulkdataid free]; bulkdataid = [anObject copy]; return self; }
- description { return description; }
- setDescription:anObject { [description free]; description = [anObject copy]; return self; }
- supplDescription { return supplDescription; }
- setSupplDescription:anObject { [supplDescription free]; supplDescription = [anObject copy]; return self; }

@end

