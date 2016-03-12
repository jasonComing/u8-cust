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

insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('DHL.*', '空运', 10)
insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('LOCAL.*', 'LOCAL(本地)', 20)
insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('UPS.*', '空运', 30)
insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('FEDEX.*', '空运', 40)
insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('.+-A.*', '空运', 50)
insert CustFoaShipMethodConfig (Regex, ShipMethod, Sort) values ('.+-S.*', '海运', 60)

go