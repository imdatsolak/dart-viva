#import "dart/debug.h"
#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "SubkonditionenItem.h"

#pragma .h #import "MasterItem.h"

@implementation SubkonditionenItem:Object
{
	id	kdkategorie;
	id	menge;
	id	summe;
	id	proauftrag;
	id	rabatt;
	id	sonderpreis;
	id	istsonderpreis;
	id	istsumme;
	id	gueltigvon;
	id	gueltigbis;
	
	id	neuerpreis;
}

- initKdkategorie:aKdkategorie menge:aMenge summe:aSumme proauftrag:aProauftrag rabatt:aRabatt sonderpreis:aSonderpreis istsonderpreis:anIstsonderpreis istsumme:anIstsumme gueltigvon:aGueligvon gueltigbis:aGueltigbis
{
	[self init];
	kdkategorie = [aKdkategorie copy];
	menge = [aMenge copy];
	summe = [aSumme copy];
	proauftrag = [aProauftrag copy];
	rabatt = [aRabatt copy];
	sonderpreis = [aSonderpreis copy];
	istsonderpreis = [anIstsonderpreis copy];
	istsumme = [anIstsumme copy];
	gueltigvon = [aGueligvon copy];
	gueltigbis = [aGueltigbis copy];
	return self;
}			

- initNew
{
	[self init];
	
	kdkategorie		= [Integer int:0];
	menge			= [Integer int:0];
	summe			= [Double double:0];
	proauftrag		= [Integer int:1];
	rabatt			= [Double double:0];
	sonderpreis		= [Double double:0];
	istsonderpreis	= [Integer int:0];
	istsumme		= [Integer int:0];
	gueltigvon		= [Date today];
	gueltigbis		= [[[Date alloc] init] setDateLong:20251231];
	
	return self;
}


- free
{
	[kdkategorie free];
	[menge free];
	[summe free];
	[proauftrag free];
	[rabatt free];
	[sonderpreis free];
	[istsonderpreis free];
	[istsumme free];
	[gueltigvon free];
	[gueltigbis free];
	
	[neuerpreis free];
	
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	kdkategorie		= [kdkategorie copy];
	menge			= [menge copy];
	summe			= [summe copy];
	proauftrag		= [proauftrag copy];
	rabatt			= [rabatt copy];
	sonderpreis		= [sonderpreis copy];
	istsonderpreis	= [istsonderpreis copy];
	istsumme		= [istsumme copy];
	gueltigvon		= [gueltigvon copy];
	gueltigbis		= [gueltigbis copy];
	
	neuerpreis		= [neuerpreis copy];
	
	return theCopy;
}

- appendFieldsToQueryString:queryString
{
	[queryString concatFieldComma:kdkategorie];
	[queryString concatFieldComma:menge];
	[queryString concatFieldComma:summe];
	[queryString concatFieldComma:proauftrag];
	[queryString concatFieldComma:rabatt];
	[queryString concatFieldComma:sonderpreis];
	[queryString concatFieldComma:istsonderpreis];
	[queryString concatFieldComma:istsumme];
	[queryString concatFieldComma:gueltigvon];
	[queryString concatField:gueltigbis];
	
	return self;
}

- (int)compare:anotherObject
{
	int	result;
	if(neuerpreis==nil) {
		result = [kdkategorie compare:[anotherObject kdkategorie]];
		if(result==0) {
			result = [istsumme compare:[anotherObject istsumme]];
			if(result==0) {
				if([istsumme isTrue]) {
					result = [summe compare:[anotherObject summe]];
				} else {
					result = [rabatt compare:[anotherObject rabatt]];
				}
			}
		}
	} else {
		result = [neuerpreis compare:[anotherObject neuerpreis]];
	}
	return result;
}

- calcNeuerpreisMitVk:(double)vk
{
	DEBUG4("    calcNeuerpreisMitVk:%lf --> ",vk);
	if(neuerpreis==nil) {
		neuerpreis = [[Double alloc] init];
	}
	if([istsonderpreis isTrue]) {
		[neuerpreis setDouble:[sonderpreis double]];
	} else {
		[neuerpreis setDouble:(1.0-([rabatt double]/100.0))*vk];
	}
	DEBUG4("%lf {%d,%lf,%s,%s}\n",[neuerpreis double],[menge int],[summe double],[proauftrag isTrue]?"YES":"NO",[istsumme isTrue]?"YES":"NO");
	return self;
}

- passeAnVk:theVk rabatt:theRabatt
{
	if([istsonderpreis isTrue]) {
		[theVk setDouble:[sonderpreis double]];
		[theRabatt setDouble:0.0];
	} else {
		[theRabatt setDouble:[rabatt double]];
	}
	DEBUG4("    passeAnVk:-->%lf rabatt:-->%lf\n",[theVk double],[theRabatt double]);
	return self;
}

- (BOOL)passtAnzahl:(int)anzahl umsatz:(double)umsatz gesamtanzahl:(int)gesamtanzahl
{
	BOOL	result;
	DEBUG4("    passtAnzahl:%d umsatz:%lf gesamtanzahl:%d --> ",anzahl,umsatz,gesamtanzahl);
	if([proauftrag isTrue]) {
		result = [menge compareInt:anzahl] <= 0;
	} else {
		if([istsumme isTrue]) {
			result = [summe compareDouble:umsatz] <= 0;
		} else {
			result = [menge compareInt:gesamtanzahl] <= 0;
		}
	}
	DEBUG4("%s\n",result?"YES":"NO");
	return result;
}

- (BOOL)needsUmsatz
{
	return [proauftrag isFalse] && [istsumme isTrue];
}

- (BOOL)needsGesamtanzahl
{
	return [proauftrag isFalse] && [istsumme isFalse];
}

- kdkategorie { return kdkategorie; }
- setKdkategorie:anObject { [kdkategorie free]; kdkategorie = [anObject copy]; return self; }
- menge { return menge; }
- setMenge:anObject { [menge free]; menge = [anObject copy]; return self; }
- summe { return summe; }
- setSumme:anObject { [summe free]; summe = [anObject copy]; return self; }
- proauftrag { return proauftrag; }
- setProauftrag:anObject { [proauftrag free]; proauftrag = [anObject copy]; return self; }
- rabatt { return rabatt; }
- setRabatt:anObject { [rabatt free]; rabatt = [anObject copy]; return self; }
- sonderpreis { return sonderpreis; }
- setSonderpreis:anObject { [sonderpreis free]; sonderpreis = [anObject copy]; return self; }
- istsonderpreis { return istsonderpreis; }
- setIstsonderpreis:anObject { [istsonderpreis free]; istsonderpreis = [anObject copy]; return self; }
- istsumme { return istsumme; }
- setIstsumme:anObject { [istsumme free]; istsumme = [anObject copy]; return self; }
- gueltigvon { return gueltigvon; }
- setGueltigvon:anObject { [gueltigvon free]; gueltigvon = [anObject copy]; return self; }
- gueltigbis { return gueltigbis; }
- setGueltigbis:anObject { [gueltigbis free]; gueltigbis = [anObject copy]; return self; }

- neuerpreis { return neuerpreis; }

@end

