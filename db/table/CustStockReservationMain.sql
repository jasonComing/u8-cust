create table CustStockReservationMain
(
	cSoCode varchar(60),
	Version int,
	Status tinyint,
	CreatedBy varchar(100),
	CreatedAt datetime default current_timestamp
)
go
create unique index Idx_CustStockReservationMain on CustStockReservationMain(cSoCode, Version)
go
grant insert,update on CustStockReservationMain to f8report
go