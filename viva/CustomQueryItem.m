#if 0
BEGIN TABLE DEFS

create table customquery
(
	nr			varchar(15),
	bezeichnung	varchar(50),
	query		text
)
go
create unique clustered index customqueryindex on customquery(nr)
go

END TABLE DEFS
#endif



