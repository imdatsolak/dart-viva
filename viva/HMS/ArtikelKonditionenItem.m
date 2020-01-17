#import "ArtikelKonditionenItem.h"


@implementation ArtikelKonditionenItem



- initAndLoadForArticle:articleNo
{
	id	queryString;
	
	queryString = [QueryString str:"select kd_kategorie, rab_menge, rab_proauftrag, rab_rabatt, rab_istsonderpreis from artikelkonditionen where art_nr="];
	[queryString concatField:articleNo];
	[super initFromQuery:queryString];
	[queryString free];
	
	return self;
}

	
- setTagsOfItem:theItem
{
	[[theItem objectAt:0] setTag:kd_kategorie];
	[[theItem objectAt:1] setTag:rab_menge];
	[[theItem objectAt:2] setTag:rab_proauftrag];
	[[theItem objectAt:3] setTag:rab_rabatt];
	[[theItem objectAt:4] setTag:rab_istsonderpreis];
	return self;
}


- concatFieldsForSavingOfItem:theItem to:itemSaveString
{
	[itemSaveString concatFieldComma:[theItem objectWithTag:kd_kategorie]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:rab_menge]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:rab_proauftrag]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:rab_rabatt]];
	[itemSaveString concatField:[theItem objectWithTag:rab_istsonderpreis]];
	return self;
}


- saveForArticle:articleNo
{
	id	saveString, deleteString;

	DEBUG10("ArtikelKonditionenItem:saveForAuftrag:andRechnung\n");
	
	deleteString = [QueryString str:"delete from artikelkonditionen where art_nr="];
	[deleteString concatField:articleNo];

	saveString = [QueryString str:"insert into artikelkonditionen values("];
	[saveString concatFieldComma:articleNo];
	
	[self saveWithSaveString:saveString andDeleteString:deleteString];
	
	[saveString free];
	[deleteString free];
	
	return self;
}


- insertOrUpdateKategorie:(int)kategorie menge:(int)menge proAuftrag:(int)proAuftrag istSonderPreis:(int)istSonderPreis rabatt:(double)rabatt
{
	int	i, count;
	
	DEBUG10("ArtikelKonditionenItem:insertOrUpdateKategorie:%d menge%d\n",kategorie,menge);
	
	if(!myQueryResult) myQueryResult = [[QueryResult alloc] initCount:0];
	
	count = [self itemCount];

	i = [self indexOfKondForKategorie:(int)kategorie menge:(int)menge];
	
	if(i != -1) {
		[[[self itemAt:i] objectWithTag:rab_proauftrag] charAt:0 put:proAuftrag];
		[[[self itemAt:i] objectWithTag:rab_istsonderpreis] charAt:0 put:istSonderPreis];
		[[[self itemAt:i] objectWithTag:rab_rabatt] setDouble:rabatt];
		DEBUG10("ArtikelKonditionenItem:update\n");
	} else {
		char	s[] = " ";
		id		theNewItem = [[GenericItem alloc] initCount:5];
		[theNewItem addObject:[[Integer int:kategorie] setTag:kd_kategorie]];
		[theNewItem addObject:[[Integer int:menge] setTag:rab_menge]];
		s[0] = (char)proAuftrag;
		[theNewItem addObject:[[String str:s] setTag:rab_proauftrag]];
		[theNewItem addObject:[[Double double:rabatt] setTag:rab_rabatt]];
		s[0] = (char)istSonderPreis;
		[theNewItem addObject:[[String str:s] setTag:rab_istsonderpreis]];
		[self addItem:theNewItem];
		DEBUG10("ArtikelKonditionenItem:update\n");
	}
	
	return self;
}


- (int)indexOfKondForKategorie:(int)kategorie menge:(int)menge
{
	int	i;
	id	key1 = [Integer int:kategorie];
	id	key2 = [Integer int:menge];
	
	i = [self indexOfItemWithKey1:key1 atTag1:kd_kategorie andKey2:key2 atTag2:rab_menge];
	
	[key1 free];
	[key2 free];
		
	return i;
}


- (int)indexOfBestFittingKondForKategorie:(int)kategorie menge:(int)menge
{
	id	item;
	int	bestIndex = -1,
		bestMenge = 0,
		i, count = [self itemCount];
	
	for(i=0; i<count; i++) {
		item = [self itemAt:i];
		if(0==[[item objectWithTag:kd_kategorie] compareInt:kategorie]) {
			if(0 >= [[item objectWithTag:rab_menge] compareInt:menge]) {
				if(0 < [[item objectWithTag:rab_menge] compareInt:bestMenge]) {
					bestMenge = [[item objectWithTag:rab_menge] int];
					bestIndex = i;
				}
			}
		}
	}
	
	return bestIndex;
}


@end
