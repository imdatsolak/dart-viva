#import <stdio.h>

#import <appkit/NXCursor.h>
#import <appkit/TextField.h>
#import <appkit/Button.h>
#import <appkit/View.h>
#import <appkit/Window.h>

#import "dart/fieldvaluekit.h"

#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "MasterDocument.h"
#import "AddressItem.h"
#import "KundeItem.h"

#import "KundenPrefs.h"

#pragma .h #import "MasterPrefs.h"

@implementation KundenPrefs:MasterPrefs
{
	id	item;
	id	zahlungszielField;
	id	kreditlimitField;
	id	mahnzeit1Field;
	id	mahnzeit2Field;
	id	mahnzeit3Field;
	id	skontotageField;
	id	skontoprozentField;
	id	liefersperreSwitch;
	id	mwstberechnenSwitch;
	id	einstufungPopup;
	id	kategoriePopup;
	id	groessePopup;
	id	sammelrechnungPopup;
	id	adrLandPopup;
}

- init
{
	[super init];
	item = [[KundeItem alloc] initNew];
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
	id	address = [[item adressen] objectAt:0];
	WRITEINTOCELL(item,zahlungsziel,zahlungszielField);
	WRITEINTOCELL(item,kreditlimit,kreditlimitField);
	WRITEINTOCELL(item,mahnzeit1,mahnzeit1Field);
	WRITEINTOCELL(item,mahnzeit2,mahnzeit2Field);
	WRITEINTOCELL(item,mahnzeit3,mahnzeit3Field);
	WRITEINTOCELL(item,skontotage,skontotageField);
	WRITEINTOCELL(item,skontoprozent,skontoprozentField);
	WRITEINTOSWITCH(item,liefersperre,liefersperreSwitch);
	WRITEINTOSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	WRITEINTOCELL(item,einstufung,einstufungPopup);
	WRITEINTOCELL(item,kategorie,kategoriePopup);
	WRITEINTOCELL(item,groesse,groessePopup);
	WRITEINTOCELL(item,sammelrechnung,sammelrechnungPopup);
	WRITEINTOCELL(address,landnr,adrLandPopup);
	return self;
}

- reloadPrefs:sender
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeEinstufung"] copy]) != nil) 
		[item setEinstufung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeKategorie"] copy]) != nil) 
		[item setKategorie:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeGroesse"] copy]) != nil) 
		[item setGroesse:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeLiefersperre"] copy]) != nil) 
		[item setLiefersperre:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeZahlungsziel"] copy]) != nil) 
		[item setZahlungsziel:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeKreditlimit"] copy]) != nil) 
		[item setKreditlimit:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSammelrechnung"] copy]) != nil) 
		[item setSammelrechnung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit1"] copy]) != nil) 
		[item setMahnzeit1:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit2"] copy]) != nil) 
		[item setMahnzeit2:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit3"] copy]) != nil) 
		[item setMahnzeit3:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSkontotage"] copy]) != nil) 
		[item setSkontotage:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSkontoprozent"] copy]) != nil) 
		[item setSkontoprozent:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMwstberechnen"] copy]) != nil) 
		[item setMwstberechnen:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeAdrLand"] copy]) != nil) 
		[[[item adressen] objectAt:0] setLandnr:value];
	return self;
}

- savePrefs:sender
{
	if (needsSaving) {
		id	address = [[item adressen] objectAt:0];
		READFROMCELL(item,zahlungsziel,zahlungszielField);
		READFROMCELL(item,kreditlimit,kreditlimitField);
		READFROMCELL(item,mahnzeit1,mahnzeit1Field);
		READFROMCELL(item,mahnzeit2,mahnzeit2Field);
		READFROMCELL(item,mahnzeit3,mahnzeit3Field);
		READFROMCELL(item,skontotage,skontotageField);
		READFROMCELL(item,skontoprozent,skontoprozentField);
		READFROMSWITCH(item,liefersperre,liefersperreSwitch);
		READFROMSWITCH(item,mwstberechnen,mwstberechnenSwitch);
		READFROMCELL(item,einstufung,einstufungPopup);
		READFROMCELL(item,kategorie,kategoriePopup);
		READFROMCELL(item,groesse,groessePopup);
		READFROMCELL(item,sammelrechnung,sammelrechnungPopup);
		READFROMCELL(address,landnr,adrLandPopup);
	
		[[NXApp defaultsDB] setValue:[item einstufung] forKey:"kundeEinstufung"];
		[[NXApp defaultsDB] setValue:[item kategorie] forKey:"kundeKategorie"];
		[[NXApp defaultsDB] setValue:[item groesse] forKey:"kundeGroesse"];
		[[NXApp defaultsDB] setValue:[item liefersperre] forKey:"kundeLiefersperre"];
		[[NXApp defaultsDB] setValue:[item zahlungsziel] forKey:"kundeZahlungsziel"];
		[[NXApp defaultsDB] setValue:[item kreditlimit] forKey:"kundeKreditlimit"];
		[[NXApp defaultsDB] setValue:[item sammelrechnung] forKey:"kundeSammelrechnung"];
		[[NXApp defaultsDB] setValue:[item mahnzeit1] forKey:"kundeMahnzeit1"];
		[[NXApp defaultsDB] setValue:[item mahnzeit2] forKey:"kundeMahnzeit2"];
		[[NXApp defaultsDB] setValue:[item mahnzeit3] forKey:"kundeMahnzeit3"];
		[[NXApp defaultsDB] setValue:[item skontotage] forKey:"kundeSkontotage"];
		[[NXApp defaultsDB] setValue:[item skontoprozent] forKey:"kundeSkontoprozent"];
		[[NXApp defaultsDB] setValue:[item mwstberechnen] forKey:"kundeMwstberechnen"];
		[[NXApp defaultsDB] setValue:[address landnr] forKey:"kundeAdrLand"];
		[super savePrefs:sender];
	}
	return self;
}

@end
