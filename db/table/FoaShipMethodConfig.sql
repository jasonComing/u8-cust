create table CustFoaShipMethodConfig
(
	Id int identity,
	Regex varchar(200) not null,
	ShipMethod varchar(50) not null,
	Sort int not null,
	LastModified datetime default getdate() not null
)
go
grant select on CustFoaShipMethodConfig to f8report
go

insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort)
select Regex, ShipMethod, Sort
from Cust001..FoaShipMethodConfig

go