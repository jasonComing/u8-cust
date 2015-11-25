create table CustSpecProperty
(
	PropertyId int not null,
	Name varchar(100) not null,
	LastModified datetime default getdate()
	constraint ak_CustSpecProperty unique(PropertyId)
)
go
grant insert,update,delete on CustSpecProperty to f8report