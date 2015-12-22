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

go
grant insert,update,delete on CustInvSpecDetail to f8report
go
alter table CustInvSpecDetail alter column SpecValue nvarchar(400) not null
go
