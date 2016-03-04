create table FoaShipMethodConfig
(
	Id int identity,
	Regex varchar(200) not null,
	ShipMethod varchar(50) not null,
	Sort int not null,
	LastModified datetime default getdate() not null
)
go
grant select on FoaShipMethodConfig to f8report
go