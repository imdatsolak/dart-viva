#import <objc/Storage.h>
#import <sys/param.h>
#import <string.h>
#import <stdio.h>
#import <dart/NiController.h>

@implementation NiController


- machineNames
{
	void			*handle;
	ni_id			dirId;
	ni_idlist		idlist;
	id				result = [[Storage alloc] 
	                          initCount:0
							  elementSize:MAXHOSTNAMELEN+1
							  description:NULL];
	
	if(NI_OK == (status = ni_open(NULL, "/", &handle))) {
		if(NI_OK == (status = ni_root(handle, &dirId))) {
			if(NI_OK == (status = ni_lookup(handle, &dirId, "name", "machines", &idlist))) {
				ni_id		id;
				ni_idlist	idlist1;
				
				id.nii_object = idlist.ni_idlist_val[0];
				id.nii_instance = 0;
				
				if(NI_OK == (status = ni_children(handle, &id, &idlist1))) {
					int i;
					
					for (i = 0; i < idlist1.ni_idlist_len; i++) {
						ni_id		dir;
						ni_namelist	nl;
						char		name[MAXHOSTNAMELEN+1];
						
						dir.nii_object = idlist1.ni_idlist_val[i];
						dir.nii_instance = 0;
						ni_lookupprop(handle, &dir, "name", &nl);
						strncpy(name, nl.ni_namelist_val[0], sizeof(name));
						name[sizeof(name)-1] = (char)0;
						[result addElement:name];
					}
				}
			}
		}
	}
	
	if(NI_OK != status) {
		fprintf(stderr,"%s\n",ni_error(status));
		[result free];
		result = nil;
	}

    return result;
}


- (ni_status)lastStatus
{
	return status;
}


- (const char *)lastError
{
	return ni_error(status);
}

@end
