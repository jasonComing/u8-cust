 create  trigger [dbo].[tri_SetBomAmount]
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
		begin
			update bom_opcomponent
			set Define27 = (i.iInvMPCost * (d.BaseQtyN / d.BaseQtyD))
			from bom_opcomponent d
			join bas_part p on p.partid = d.componentid
			join inventory i on i.cInvCode = p.invcode
			join inserted aa on aa.cInvCode = i.cInvCode
		end

		set nocount off
	end