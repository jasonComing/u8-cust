alter proc  SP_WriteMoveMentTypeToInvcode
/*
功能：取規格書中相關機芯編碼的機芯類型，補寫入U8存貨檔的
		機芯類型。
Auth：JAMS
*/
as
begin
	Set nocount on

	----取機芯料件的類型
	--select b.cInvCode,b.SpecValue from  CustInvSpec a
	--left join CustInvSpecDetail b on(a.cInvCode=b.cInvCode and a.Version=b.Version)
	--where a.cInvCode like '604%' and a.Status =1
	--and b.PropertyId=126

	----取D料件對應的BOM中機芯編碼
	select  h.InvCode as ParentInvCode, d.DInvCode as ChildInvCode
	into #temp
	from v_bom_head h
	join (select  InvCode ,max(bomid) as 'bomid'
			from  v_bom_head
			where InvCode like 'D%'
			group by InvCode) h2
			on (h.InvCode=h2.InvCode and h.bomid=h2.bomid)
	join v_bom_detail_cust d on d.bomid = h.bomid
	left join Inventory_extradefine x on x.cInvCode = h.InvCode
	where (h.InvCode like 'D_%')and d.DInvCode not like 'P_%'
	and ( d.DInvCode  like '604%' )
	order by h.InvCode

	--變更D料件機芯
	update i set cInvDefine9=bbb.SpecValue
	from Inventory i
	join #temp on i.cInvCode =#temp.ParentInvCode

	join  (select b.cInvCode,b.SpecValue from  CustInvSpec a
			left join CustInvSpecDetail b on(a.cInvCode=b.cInvCode and a.Version=b.Version)
			where a.cInvCode like '604%' and a.Status =1
			and b.PropertyId=126	) bbb
	on #temp.ChildInvCode=bbb.cInvCode

	where (cInvDefine9 is null or  cInvDefine9='') and i.cInvCode like 'D%'

	--變更S料件機芯類型
	update i set cInvDefine9=i2.cInvDefine9
	from Inventory i
	join ( select cInvCode,cInvDefine9,right(cInvCode,len(cInvCode)-2) as 'sku'
			from Inventory
			where cInvCode like 'D_%' and  cInvDefine9 is not null) i2
	on i.cInvCode='S_'+i2.sku
	where (i.cInvDefine9 is null or  i.cInvDefine9='') and i.cInvCode like 'S_%'

	set nocount off
end