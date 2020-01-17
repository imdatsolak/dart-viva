#import <stdio.h>

#import <appkit/TextField.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"

#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "MasterDocument.h"
#import "ArtikelItem.h"

#import "ArtikelPrefs.h"

#pragma .h #import "MasterPrefs.h"

@implementation ArtikelPrefs:MasterPrefs
{
	id		item;
	id		mindestbestandField;
	id		kategoriePopup;
	id		mengeneinheitPopup;
	id		mwstsatzPopup;
	id		lagerhaltungSwitch;
	id		lieferbarSwitch;
	id		stuecklisteSwitch;
}

- init
{
	[super init];
	item = [[ArtikelItem alloc] initNew];
	[self reloadPrefs:self];
	return self;
}
	
- free
{
	[item free];
	return [super free];
}

- redisplay:sender
{
	WRITEINTOCELL(item,mindestbestand,mindestbestandField);
	WRITEINTOCELL(item,kategorie,kategoriePopup);
	WRITEINTOCELL(item,mengeneinheit,mengeneinheitPopup);
	WRITEINTOCELL(item,mwstsatz,mwstsatzPopup);
	WRITEINTOSWITCH(item,lagerhaltung,lagerhaltungSwitch);
	WRITEINTOSWITCH(item,lieferbar,lieferbarSwitch);
	WRITEINTOSWITCH(item,stueckliste,stuecklisteSwitch);
	return self;
}

- reloadPrefs:sender
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelMindestbestand"] copy]) != nil) 
		[item setMindestbestand:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelKategorie"] copy]) != nil) 
		[item setKategorie:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelME"] copy]) != nil) 
		[item setMengeneinheit:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelMwst"] copy]) != nil) 
		[item setMwstsatz:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelLagerhaltung"] copy]) != nil) 
		[item setLagerhaltung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelLieferbar"] copy]) != nil) 
		[item setLieferbar:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelStueckliste"] copy]) != nil) 
		[item setStueckliste:value];
	return self;
}

- savePrefs:sender
{
	if (needsSaving) {
		READFROMCELL(item,mindestbestand,mindestbestandField);
		READFROMCELL(item,kategorie,kategoriePopup);
		READFROMCELL(item,mengeneinheit,mengeneinheitPopup);
		READFROMCELL(item,mwstsatz,mwstsatzPopup);
		READFROMSWITCH(item,lagerhaltung,lagerhaltungSwitch);
		READFROMSWITCH(item,lieferbar,lieferbarSwitch);
		READFROMSWITCH(item,stueckliste,stuecklisteSwitch);
	
		[[NXApp defaultsDB] setValue:[item mindestbestand] forKey:"artikelMindestbestand"];
		[[NXApp defaultsDB] setValue:[item kategorie] forKey:"artikelKategorie"];
		[[NXApp defaultsDB] setValue:[item mengeneinheit] forKey:"artikelME"];
		[[NXApp defaultsDB] setValue:[item mwstsatz] forKey:"artikelMwst"];
		[[NXApp defaultsDB] setValue:[item lagerhaltung] forKey:"artikelLagerhaltung"];
		[[NXApp defaultsDB] setValue:[item lieferbar] forKey:"artikelLieferbar"];
		[[NXApp defaultsDB] setValue:[item stueckliste] forKey:"artikelStueckliste"];
		[super savePrefs:sender];
	}
	return self;
}

@end
