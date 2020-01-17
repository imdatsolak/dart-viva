#import "AngebotPrefs.h"

#pragma .h #import "MasterDocumentPrefs.h"

@implementation AngebotPrefs:MasterDocumentPrefs
{
}

- (const char *)myLayoutKey
{
	return "LayoutForAN";
}

- (const char *)bezeichnungBeschreibungKey
{
	return "AngebotBezBeschr";
}

- (const char *)nurGesamtpreisKey
{
	return "AngebotNurGesamtpreis";
}


- (const char *)nrBreiteKey { return "AngebotItemNrBreite"; }
- (const char *)nrBeginKey { return "AngebotItemNrBegin"; }
- (const char *)prePostfixSelectKey { return "AngebotItemNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "AngebotItemNrPrefixKind"; }
- (const char *)withDashKey { return "AngebotItemNrWithDash"; }
- (const char *)maxNrTableName { return "maxangebot"; }

@end
