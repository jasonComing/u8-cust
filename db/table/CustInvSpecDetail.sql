create table CustInvSpecDetail
(
	Id int identity,
	cInvCode varchar(100),
	Version int,
	PropertyId int,
	SpecValue varchar(400),
	LastModified datetime default getdate()
	primary key (cInvCode, Version, PropertyId)
)