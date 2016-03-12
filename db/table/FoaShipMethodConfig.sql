create table CustFoaShipMethodConfig
(
	Id int identity,
	Regex varchar(200) not null,
	ShipMethod varchar(50) not null,
	ShipMethodDescription varchar(50) not null,
	Sort int not null,
	LastModified datetime default getdate() not null
)
go
grant select on CustFoaShipMethodConfig to f8report
go

insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('DHL.*', 'Air', '空运', 10)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('LOCAL.*', 'Local', 'LOCAL(本地)', 20)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('UPS.*', 'Air', '空运', 30)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('FEDEX.*', 'Air', '空运', 40)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('.+-A.*', 'Air', '空运', 50)
insert CustFoaShipMethodConfig (Regex, ShipMethod, ShipMethodDescription, Sort) values ('.+-S.*', 'Sea', '海运', 60)

go