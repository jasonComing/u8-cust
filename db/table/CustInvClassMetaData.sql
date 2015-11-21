create table CustInvClassMetaData
(
	Id int identity,
	cInvCCode varchar(24),
	PropertyId int,
	SortOrder int,
	constraint ix_CustInvClassMetaData unique (cInvCCode, PropertyId, SortOrder)
)