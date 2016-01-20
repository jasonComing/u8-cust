create table CustInvClassMetaData
(
	Id int identity,
	cInvCCode varchar(24),
	PropertyId int,
	SortOrder int,
	IsNewSection bit not null default 0,
	ShowInPo bit not null default 1,
	LastModified datetime not null default getdate()
	constraint ix_CustInvClassMetaData unique (cInvCCode, PropertyId, SortOrder)
)
grant insert,update,delete on CustInvClassMetaData to f8report