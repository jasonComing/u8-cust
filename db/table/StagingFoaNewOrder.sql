use Cust004
go
Create table StagingFoaNewOrder
(
Id   int identity,
Date	datetime not null,
PoNo	varchar(50) null,
PoLineNo	varchar(10) null,
CustSoNo	varchar(50) null,
CustSoLineNo	varchar(10) null,
OrderDate	datetime null,
Style	varchar(50) null,
ShipTo	varchar(20) null,
PoLineQty	int null,
ShipWindow	datetime null,
ReorderLT	varchar(50) null,
Factory	varchar(50) null,
OrderType	varchar(20) null,
LineType	varchar(20) null,
Collection	varchar(20) null,
BrandCode	varchar(20) null,
Brand		varchar(20) null,
Dome		varchar(20) null,
BuyPrice	decimal null,
PoRemarks	varchar(5000) null,
PoLineRemarks	varchar(5000) null,
ReqDelvDate	datetime null
)
go
create index idx_FoaNewOrder on StagingFoaNewOrder(Date)
go
grant select,insert,update,delete on StagingFoaNewOrder to f8report