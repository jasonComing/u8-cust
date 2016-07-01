 create  trigger [dbo].[tri_SetPodetailsInvMPCost]
/*
功能：修改存貨档最高進價時，同時修改PoDetail表体相关料号的最高进价
作者：Jams
*/
on [dbo].[Inventory]
   after update
as
	begin
		Set nocount on

		if UPDATE(iInvMPCost)
			update bb　set bb.iInvMPCost = aa.iInvMPCost
			from PO_Podetails bb join inserted aa on  bb.cInvCode=aa.cInvCode
			where aa.iInvMPCost is not null
			and aa.iInvMPCost != bb.iInvMPCost
			and bb.cbCloser is null

		set nocount off
	end