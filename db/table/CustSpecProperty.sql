create table CustSpecProperty
(
	PropertyId int not null,
	Name varchar(100) not null,
	LastModified datetime default getdate()
	constraint ak_CustSpecProperty unique(PropertyId)
)
go
grant insert,update,delete on CustSpecProperty to f8report


alter table CustSpecProperty add PropertyType int default 0


update CustSpecProperty
set PropertyType = 0
where PropertyId not in (70, 71, 72, 73)

update CustSpecProperty
set PropertyType = 1
where PropertyId in (70, 71, 72, 73)