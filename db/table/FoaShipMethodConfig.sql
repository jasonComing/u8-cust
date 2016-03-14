create table CustFoaShipMethodConfig
(
	Id int identity,
	Regex varchar(200) not null,
	ShipMethod int not null,
	ShipMethodDescription varchar(50) not null,
	Sort int not null,
	LastModified datetime default getdate() not null
)
go
grant select on CustFoaShipMethodConfig to f8report
go

insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('DHL.*', 2, '空运', 10)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('LOCAL.*', 1, 'LOCAL(本地)', 20)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('UPS.*', 2, '空运', 30)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('FEDEX.*', 2, '空运', 40)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('.+-A.*', 2, '空运', 50)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('.+-S.*', 3, '海运', 60)

go