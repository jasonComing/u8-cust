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


alter table CustInvSpecDetail add cVenCode nvarchar(40) null

alter table CustInvSpecDetail drop constraint PK__CustInvS__81F301AC38946F48
alter table add constraint pk_CustInvSpecDetail primary key (Id)