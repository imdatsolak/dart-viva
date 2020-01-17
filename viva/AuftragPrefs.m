#import "AuftragPrefs.h"

#pragma .h #import "MasterDocumentPrefs.h"

@implementation AuftragPrefs:MasterDocumentPrefs
{
}

- (const char *)myLayoutKey
{
	return "LayoutForAU";
}

- (const char *)bezeichnungBeschreibungKey
{
	return "AuftragBezBeschr";
}

- (const char *)nurGesamtpreisKey
{
	return "AuftragNurGesamtpreis";
}
- (const char *)nrBreiteKey { return "AuftragItemNrBreite"; }
- (const char *)nrBeginKey { return "AuftragItemNrBegin"; }
- (const char *)prePostfixSelectKey { return "AuftragItemNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "AuftragItemNrPrefixKind"; }
- (const char *)withDashKey { return "AuftragItemNrWithDash"; }
- (const char *)maxNrTableName { return "maxauftrag"; }
@end
