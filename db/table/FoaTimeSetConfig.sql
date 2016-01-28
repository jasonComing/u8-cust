Create Table FoaTimeSetConfig
(
	ShipCode varchar(10),
	FromDate varchar(4),
	ToDate varchar(4),
	Timeset varchar(20),
	LastModified datetime default getdate()
)
go
create unique clustered index cIdx_FoaTimeSetConfig on FoaTimeSetConfig(ShipCode, FromDate, ToDate)
go
grant select on FoaTimeSetConfig to f8report
go
