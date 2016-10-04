create table CustStockReservationDetail
(
	Id int identity,
	cSoCode varchar(60),
	Version int,
	cInvCode varchar(120),
	Quantity int,
	Remarks varchar(200),
	IsReEngrave bit
)
go
create unique index Idx_CustStockReservationDetail on CustStockReservationDetail(cSoCode, Version, cInvCode)
go
grant insert on CustStockReservationDetail to f8report
go