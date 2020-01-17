#import "ArtikelLieferantenItem.h"


@implementation ArtikelLieferantenItem

- initAndLoadForArticle:articleNo
{
	id	queryString;
	
	queryString = [QueryString str:"select lfrnt_nr, alf_ek, alf_landnr, alf_lieferzeit, alf_gewicht, alf_lieferantenartnr, alf_text from artikellieferanten where art_nr="];
	[queryString concatField:articleNo];
	
	[super initFromQuery:queryString];
	
	[queryString free];
	
	return self;
}

	
- setTagsOfItem:theItem
{
	[[theItem objectAt:0] setTag:lfrnt_nr];
	[[theItem objectAt:1] setTag:alf_ek];
	[[theItem objectAt:2] setTag:alf_landnr];
	[[theItem objectAt:3] setTag:alf_lieferzeit];
	[[theItem objectAt:4] setTag:alf_gewicht];
	[[theItem objectAt:5] setTag:alf_lieferantenartnr];
	[[theItem objectAt:6] setTag:alf_text];

	return self;
}


- concatFieldsForSavingOfItem:theItem to:itemSaveString
{
	[itemSaveString concatFieldComma:[theItem objectWithTag:lfrnt_nr]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:alf_ek]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:alf_landnr]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:alf_lieferzeit]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:alf_gewicht]];
	[itemSaveString concatFieldComma:[theItem objectWithTag:alf_lieferantenartnr]];
	[itemSaveString concatField:[theItem objectWithTag:alf_text]];
	return self;
}


- saveForArticle:articleNo
{
	id	saveString, deleteString;
	
	DEBUG10("ArtikelLieferantenItem:saveForArticle:\n");
	
	deleteString = [QueryString str:"delete from artikellieferanten where art_nr="];
	[deleteString concatField:articleNo];

	saveString = [QueryString str:"insert into artikellieferanten values("];
	[saveString concatFieldComma:articleNo];
	
	[self saveWithSaveString:saveString andDeleteString:deleteString];
	
	[saveString free];
	[deleteString free];
	
	return self;
}


@end
