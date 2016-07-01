create view v_InventoryAuthClass
as
Select Id, cACCode
from aa_authclass
where cBusObId=N'inventory'
go
