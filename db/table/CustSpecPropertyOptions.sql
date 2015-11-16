create table CustSpecPropertyOption
(
	Id int identity,
	PropertyId int not null,
	SpecValue varchar(400) not null,
	SortOrder int not null,
	constraint ix_CustSpecPropertyOption unique (PropertyId, SpecValue, SortOrder)
)