ALTER trigger [dbo].[tri_getRefPrice]
/*
 功能：创建采购订单时，取出料件最近一次的历史
 采购单价做為參考單價
 Auth:Jams
 调用：建立采购单时，自动触发 
*/
on [dbo].[PO_Podetails_extradefine]
   for insert,update
as
begin
	Set nocount on

	update PO_Podetails_extradefine
	set cbdefine32=(
						select top 1 isnull(dd.iunitprice,0)
						from inserted a
						join  PO_Podetails b on a.id=b.id
						join PO_Pomain c on b.poid=c.poid
						left join PO_PODetails dd on dd.cInvCode = b.cInvCode
						left join PO_POMain dm on dm.poid = dd.poid
						where dd.iUnitPrice > 0  
						and dm.cVenCode = c.cVenCode
						and b.id != dd.id
						and a.id=aa.ID
						order by dd.id desc
						)
	 from PO_Podetails_extradefine
	 join inserted aa on PO_Podetails_extradefine.id=aa.id
	set nocount off
end