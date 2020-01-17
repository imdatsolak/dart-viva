#import "BestellPrefs.h"

#pragma .h #import "MasterDocumentPrefs.h"

@implementation BestellPrefs:MasterDocumentPrefs
{
}
- (const char *)myLayoutKey 				{ return "LayoutForBE"; }
- (const char *)bezeichnungBeschreibungKey 	{ return "BestellBezBeschr"; }
- (const char *)nurGesamtpreisKey 			{ return "BestellNurGesamtpreis"; }
- (const char *)nrBreiteKey { return "BestellungItemNrBreite"; }
- (const char *)nrBeginKey { return "BestellungItemNrBegin"; }
- (const char *)prePostfixSelectKey { return "BestellungItemNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "BestellungItemNrPrefixKind"; }
- (const char *)withDashKey { return "BestellungItemNrWithDash"; }
- (const char *)maxNrTableName { return "maxbestellung"; }
@end
