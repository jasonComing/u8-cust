create table CustSpecProperty
(
	PropertyId int identity,
	Name varchar(100),
	LastModified datetime default getdate()
	constraint ak_CustSpecProperty unique(Name)
)