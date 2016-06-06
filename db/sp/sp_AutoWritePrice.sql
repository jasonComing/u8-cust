create proc  sp_AutoWritePrice
/*
功能：补上料件最高采购单价
auth：jams
*/
as
begin
	Set nocount on
	update i  set iInvMPCost =temp.iUnitPrice
	from  Inventory i
	join (
			select cInvCode, iUnitPrice, ID
			from PO_Podetails
			where ID in (
							 select MAX(id)
							 from PO_Podetails
							 where iUnitPrice != 0
							 group by cInvCode
							)
			)  temp
	on i.cInvCode= temp.cInvCode
	where i.iInvMPCost is  null

	Set nocount off
end