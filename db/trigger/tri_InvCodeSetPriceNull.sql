create trigger tri_InvCodeSetPriceNull
/*
功能：新建料号时，清空从复制旧料号带出过来的最高单价
作者：Jams
*/
on Inventory
   after insert
as
	begin
		update  a set  iInvMPCost=null
		from Inventory a join Inserted b  on a.cInvCode = b.cInvCode
	end