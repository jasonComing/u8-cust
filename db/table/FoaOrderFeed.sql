use Cust004
go
Create table CustFoaOrderFeed
(
Id   int identity,
Date	datetime not null,
OrderStatus varchar(50) not null,
TypeOfChange varchar(50) not null,
PoNo	varchar(50) null,
OrderLine	varchar(10) null,
SoNo	varchar(50) null,
Style	varchar(50) null,
Brand		varchar(20) null,
UnitPrice	decimal(20, 4) null,
PoOrderQty	int null,
OrderType  varchar(50) null,
LineType	varchar(20) null,
Season  varchar(50) null,
CreateDate  datetime null,
ShipWindow	datetime null,
ShipTo	varchar(20) null,
ShippingAgent varchar(50) null,
Factory  varchar(50) null,
LastModified datetime default getdate()
)
go
create index idx_FoaOrderFeed on CustFoaOrderFeed(Date)
go
grant select,insert,update,delete on CustFoaOrderFeed to f8report

insert into CustFoaOrderFeed (Date, OrderStatus, TypeOfChange, PoNo, OrderLine, SoNo, Style, Brand, UnitPrice, PoOrderQty, LineType, Season, CreateDate, ShipWindow, ShipTo, ShippingAgent, Factory) values ()