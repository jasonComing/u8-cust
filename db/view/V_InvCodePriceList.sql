alter view  V_InvCodePriceList
/*
功能：取料件最小单价
	（在历史PO单价中与最高进价控制两者之间选取）
*/
as
	select d.cInvCode, d.iUnitPrice as 'UnitPrice', i.iInvMPCost, iif(d.iUnitPrice > i.iInvMPCost, i.iInvMPCost, d.iUnitPrice) as 'MinPrice'
	from PO_Podetails d
	join (select MAX(po.id) as Id
	from PO_Podetails as po
	where po.iUnitPrice != 0
	group by po.cInvCode) t on t.Id = d.id
	join Inventory i on i.cInvCode = d.cInvCode