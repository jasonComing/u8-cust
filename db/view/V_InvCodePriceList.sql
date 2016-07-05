create view  V_InvCodePriceList
/*
功能：取料件最小单价
	（在历史PO单价中与最高进价控制两者之间选取）
*/
as
	  select tbtemp.cInvCode,min(tbtemp.MinPrice) as 'MinPrice'
	  from (select Inventory.cInvCode,isnull(Inventory.iInvMPCost,0) as 'MinPrice'  from Inventory
				union
				select PO_Podetails.cInvCode, PO_Podetails.iUnitPrice as 'MinPrice' from PO_Podetails
				where  PO_Podetails.ID in (
								select MAX(po.id)
								from PO_Podetails as po
								where po.iUnitPrice != 0
								group by po.cInvCode
								)
			  ) as tbtemp
	  group by tbtemp.cInvCode
