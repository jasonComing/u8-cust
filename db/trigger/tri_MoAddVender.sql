--drop trigger [tri_MoAddVender]
alter  trigger [dbo].[tri_MoAddVender]
/*
 功能：創建生產訂單時,子件信息報表上加上供應商信息
 Auth:Jams
 调用：創建生產訂單時，自动触发 
*/
on mom_moallocate
   after insert,update
as
begin
	Set nocount on

	--取出JOB所的採購單(採購單,料號.供應商名稱,生產訂單明細ID,生产子件表ID)
	select distinct d.cPOID,c.cInvCode,e.cVenAbbName,a.MoDId,a.AllocateId
	into #temp 
	from inserted a 
	left join mom_orderdetail b on a.modid=b.modid
	left join PO_Podetails c on b.SoDId=c.SoDId
	left join PO_Pomain d on c.POID=d.POID
	join Vendor e on d.cVenCode =e.cVenCode 
	where a.InvCode like '6%' 
	--and  a.MoDId=1000003406

	--更新數據(生產子件信息--加上供商應信息)
	update mom_moallocate_extradefine
	set cbdefine34=#temp.cVenAbbName
	from mom_moallocate_extradefine 
	join  #temp  on mom_moallocate_extradefine.AllocateId=#temp.AllocateId 
	where  mom_moallocate_extradefine.cbdefine34  is null
	 
	set nocount off
end 