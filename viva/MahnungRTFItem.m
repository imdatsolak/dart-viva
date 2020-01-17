#import "dart/fieldvaluekit.h"

#import "AttachmentList.h"
#import "ImageManager.h"
#import "LayoutManager.h"
#import "RechnungItem.h"
#import "TextParser.h"
#import "TheApp.h"

#import "MahnungRTFItem.h"

#pragma .h #import "PrintRTFItem.h"

@implementation MahnungRTFItem:PrintRTFItem
{
}

+ neueMahnungForRechnung:rechnung
{
	id	mahnung, layout, parser;
	id	str1, str2, str3;
	id	today = [Date today];
	
	str1 = [String str:"RechnungItem:"];
	[str1 concat:[rechnung nr]];
	[str1 concatSTR:":Mahnung:"];
	[str1 concatINT:[[rechnung mahnstufe] int]];
	[str1 concatSTR:":"];
	[str1 concatINT:[[rechnung attachmentList] count]];
	
	str2 = [today copyAsString];
	
	str3 = [String str:""];
	[str3 concatINT:[[rechnung mahnstufe] int]];
	[str3 concatSTR:". Mahnung - Rechnung Nr "];
	[str3 concat:[rechnung nr]];
	
	layout = [[[NXApp layoutMgr] defaultLayoutForMahnung:[[rechnung mahnstufe] int]] copy];
	parser = [[TextParser alloc] init];
	[parser parseString:layout withItem:rechnung];

	mahnung = [[self alloc] initIdentity:str1 description:str2 supplDescription:str3 data:layout];
	
	[parser free];
	[layout free];
	[today free];
	[str1 free];
	[str2 free];
	[str3 free];
	
	return mahnung;
}

- (const char *)miniIcon 
{
	return [[[NXApp imageMgr] iconFor:"MiniRTF"] name];
}

- getMyIcon
{
	return [[NXApp imageMgr] iconFor:"vivaRTF"];
}

@end
