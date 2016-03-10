Create Table CustFoaTimeSetConfig
(
	ShipCode varchar(10),
	FromDate varchar(4),
	ToDate varchar(4),
	Timeset varchar(20),
	LastModified datetime default getdate()
)
go
create unique clustered index cIdx_FoaTimeSetConfig on CustFoaTimeSetConfig(ShipCode, FromDate, ToDate)
go
grant select on CustFoaTimeSetConfig to f8report
go


insert CustFoaTimeSetConfig (ShipCode, FromDate, ToDate, Timeset)
select ShipCode, FromDate, ToDate, Timeset
from Cust001..FoaTimeSetConfig
go