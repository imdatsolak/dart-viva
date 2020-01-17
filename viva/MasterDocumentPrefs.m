#import <stdio.h>
#import <appkit/TextField.h>
#import <appkit/Window.h>
#import <appkit/Button.h>
#import <appkit/Matrix.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "UserManager.h"
#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "LayoutDocument.h"
#import "LayoutItemList.h"
#import "MasterItem.h"

#import "MasterDocumentPrefs.h"

#pragma .h #import "MasterPrefs.h"

@implementation MasterDocumentPrefs:MasterPrefs
{
	id	layoutIcon;
	id	bezeichnungBeschreibungRadio;
	id	nurGesamtpreisSwitch;
	id	nrBreiteField;
	id	nrBeginField;
	id	prePostfixSelectRadio;
	id	prePostfixKindRadio;
	id	withDashSwitch;
	
	id	sampleField;
	
	id	bezeichnungBeschreibung;
	id	nurGesamtpreis;
	id	layout;
	id	nrBreite;
	id	nrBegin;
	id	prePostfixSelect;
	id	prePostfixKind;
	id	withDash;
	id	oldBeginNr;
}

- init
{
	[super init];
	[[[layoutIcon setDoubleTarget:self] setDoubleAction:@selector(openItem:)] setTitled:YES];
	layout = [String str:""];
	bezeichnungBeschreibung = [Integer int:0];
	nurGesamtpreis = [Integer int:0];
	nrBreite = [Integer int:6];
	nrBegin = [Integer int:1];
	prePostfixSelect = [Integer int:0];
	prePostfixKind = [Integer int:0];
	withDash = [Integer int:0];
	oldBeginNr = [Integer int:0];
	[self reloadPrefs:self];
	return self;
}
	
- free
{
	[bezeichnungBeschreibung free];
	[nurGesamtpreis free];
	[layout free];
	[nrBreite free];
	[nrBegin free];
	[prePostfixSelect free];
	[prePostfixKind free];
	[withDash free];
	[oldBeginNr free];
	return [super free];
}

- (const char *)myLayoutKey { return "MasterDocumentLayout"; }
- (const char *)bezeichnungBeschreibungKey { return "MasterDocumentBB"; }
- (const char *)nurGesamtpreisKey { return "MasterDocumentNurGP"; }
- (const char *)nrBreiteKey { return "MasterDocumentNrBreite"; }
- (const char *)nrBeginKey { return "MasterDocumentNrBegin"; }
- (const char *)prePostfixSelectKey { return "MasterDocumentNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "MasterDocumentNrPrefixKind"; }
- (const char *)withDashKey { return "MasterDocumentNrWithDash"; }
- (const char *)maxNrTableName { return "maxangebot"; }

- redisplay:sender
{
	if ([layout length] > 0) {
		id	content = [[[LayoutItemList alloc] initCount:0] addIdentity:layout];
		[layoutIcon setContent:content];
		[content free];
	}
	[bezeichnungBeschreibungRadio selectCellWithTag:([bezeichnungBeschreibung int]?1:0)];
	[nurGesamtpreisSwitch setState:[nurGesamtpreis int]? 1:0];

	[nrBreite writeIntoCell:nrBreiteField];
	[nrBegin writeIntoCell:nrBeginField];
	[prePostfixSelectRadio selectCellWithTag:[prePostfixSelect int]];
	[prePostfixKindRadio selectCellWithTag:[prePostfixKind int]];
	if ([prePostfixSelect int] == 0) {
		[prePostfixKindRadio setEnabled:NO];
	}
	[withDashSwitch setState:[withDash int]];
	if (![[NXApp userMgr] isSuperuser]) {
		[[nrBreiteField setEditable:NO] setBackgroundGray:NX_LTGRAY];
		[[nrBeginField setEditable:NO] setBackgroundGray:NX_LTGRAY];
		[[sampleField setEditable:NO] setBackgroundGray:NX_LTGRAY];
		[prePostfixSelectRadio setEnabled:NO];
		[prePostfixKindRadio setEnabled:NO];
		[withDashSwitch setEnabled:NO];
	}
	[self updateSampleField];
	return self;
}

- reloadPrefs:sender
{
	id	value = [[NXApp defaultsDB] valueForKey:[self bezeichnungBeschreibungKey]];
	if (value) { [bezeichnungBeschreibung setInt:[value int]]; }

	value = [[NXApp defaultsDB] valueForKey:[self nurGesamtpreisKey]];
	if (value) { [nurGesamtpreis setInt:[value int]]; }
	
	value = [[NXApp defaultsDB] valueForKey:[self myLayoutKey]];
	if (value) { [layout str:[value str]]; }

	value = [[NXApp defaultsDB] valueForKey:[self nrBreiteKey]];
	if (value != nil) [nrBreite setInt:[value int]];

	value = [[NXApp defaultsDB] valueForKey:[self nrBeginKey]];
	if (value != nil) {
		[nrBegin setInt:[value int]];
		[oldBeginNr setInt:[value int]];
	}

	value = [[NXApp defaultsDB] valueForKey:[self prePostfixSelectKey]];
	if (value != nil) [prePostfixSelect setInt:[value int]];

	value = [[NXApp defaultsDB] valueForKey:[self prePostfixKindKey]];
	if (value != nil) [prePostfixKind setInt:[value int]];
	
	value = [[NXApp defaultsDB] valueForKey:[self withDashKey]];
	if (value != nil) [withDash setInt:[value int]];
	return self;
}

- savePrefs:sender
{
	if (needsSaving) {
		if ([[[layoutIcon content] identity] str] != NULL)
			[layout str:[[[layoutIcon content] identity] str]];
		[[NXApp defaultsDB] setValue:layout forKey:[self myLayoutKey]];
		[bezeichnungBeschreibung setInt:[[bezeichnungBeschreibungRadio selectedCell] tag]];
		[nurGesamtpreis setInt:[nurGesamtpreisSwitch state]];
		[[NXApp defaultsDB] setValue:bezeichnungBeschreibung forKey:[self bezeichnungBeschreibungKey]];
		[[NXApp defaultsDB] setValue:nurGesamtpreis forKey:[self nurGesamtpreisKey]];
	
		if ([[NXApp userMgr] isSuperuser]) {
			[nrBreite readFromCell:nrBreiteField];
			[[NXApp defaultsDB] setValue:nrBreite forKey:[self nrBreiteKey]];
			
			if ([self checkEntryFrom:nrBeginField] != nil) {
				[nrBegin readFromCell:nrBeginField];
				[[NXApp defaultsDB] setValue:nrBegin forKey:[self nrBeginKey]];
				[oldBeginNr setInt:[nrBegin int]];
			}
			
			[prePostfixSelect setInt:[[prePostfixSelectRadio selectedCell] tag]];
			[[NXApp defaultsDB] setValue:prePostfixSelect forKey:[self prePostfixSelectKey]];
			
			[prePostfixKind setInt:[[prePostfixKindRadio selectedCell] tag]];
			[[NXApp defaultsDB] setValue:prePostfixKind forKey:[self prePostfixKindKey]];
			
			[withDash setInt:[withDashSwitch state]];
			[[NXApp defaultsDB] setValue:withDash forKey:[self withDashKey]];
		}
		[super savePrefs:sender];
	}
	return self;
}

- openItem:sender
{
	id	anIdentity = [[sender content] identity];
	if (anIdentity) {
		[[[LayoutDocument alloc] initIdentity:anIdentity] makeActive:self];
	}
	return self;
}

- (BOOL)acceptsItem:anItem
{ 
	return	[anItem isKindOf:[LayoutItemList class]] && [anItem isSingle]; 
}

- pasteItem:anItem
{
	if ([anItem isKindOf:[LayoutItemList class]] && [anItem isSingle]) {
		[layoutIcon setContent:anItem];
		[prefsWindow setDocEdited:YES];
		[layoutIcon display];
		return self;
	} else {
		return nil;
	}
}


- checkEntryFrom:sender
{
	id	retVal = self;
	id	result;
	id	string = [QueryString str:"select maxnr+1 from "];
	[string concatSTR:[self maxNrTableName]];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		if (([[[result objectAt:0] objectAt:0] compareInt:[sender intValue]] <= 0) || 
			([oldBeginNr compareInt:[sender intValue]]==0) ){
			retVal = self;
		} else {
			retVal = nil;
		}
	}
	[result free];
	if (retVal == nil) {
		[NXApp beep:[self maxNrTableName]];
	} else {
		[self updateSampleField];
		[self controlDidChange:sender];
	}
	return retVal;
}

- prePostfixSelectClicked:sender
{
	[prePostfixKindRadio setEnabled:([[prePostfixSelectRadio selectedCell] tag] > 0)];
	[self updateSampleField];
	[self controlDidChange:sender];
	return self;
}

- prePostfixKindClicked:sender
{
	[self updateSampleField];
	[self controlDidChange:sender];
	return self;
}

- withDashSwitchClicked:sender
{
	[self updateSampleField];
	[self controlDidChange:sender];
	return self;
}

- updateSampleField
{
	id		aNr;
	id		newNr;
	char	s[1024];
	
	[nrBreite readFromCell:nrBreiteField];
	[nrBegin readFromCell:nrBeginField];
	[prePostfixSelect setInt:[[prePostfixSelectRadio selectedCell] tag]];
	[prePostfixKind setInt:[[prePostfixKindRadio selectedCell] tag]];
	[withDash setInt:[withDashSwitch state]];
	
	sprintf(s,"%0*d", nrBreite?[nrBreite int]:6, [nrBegin int]);
	aNr = [String str:s];

	newNr = [MasterItem copyMakeIdentityNrFromString:aNr 
				prePostfix:prePostfixSelect 
				prePostfixKind:prePostfixKind
				withDash:withDash];
	[newNr writeIntoCell:sampleField];
	[aNr free];
	[newNr free];
	return self;
}

- textDidEnd:anObject endChar:(unsigned short)whyEnd
{
	[self updateSampleField];
	return self;
}
@end
