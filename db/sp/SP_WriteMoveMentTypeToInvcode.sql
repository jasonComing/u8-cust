alter proc  SP_WriteMoveMentTypeToInvcode
/*
功能：取規格書中相關機芯編碼的機芯類型，補寫入U8存貨檔的
  機芯類型。
Auth：JAMS
*/
as
begin
 Set nocount on

 ----取D料件對應的BOM中機芯編碼
 select  h.InvCode as ParentInvCode, d.DInvCode as ChildInvCode
 into #temp
 from v_bom_head h
 join (
	  select InvCode ,max(bomid) as 'bomid'
	  from v_bom_head
	  where InvCode like 'D%'
	  group by InvCode) h2 on h.bomid=h2.bomid
 join v_bom_detail_cust d on d.bomid = h.bomid
 where h.InvCode like 'D_%'
 and d.DInvCode like '604%'

 insert into #temp
 select 'S_' + RIGHT(ParentInvCode, len(ParentInvCode) - 2), ChildInvCode
 from #temp

 --變更D料件機芯
 update i set cInvDefine9=b.SpecValue
 from Inventory i
 join #temp on i.cInvCode =#temp.ParentInvCode
 join CustInvSpecDetail b on b.cInvCode = #temp.ChildInvCode and b.PropertyId = 126
 join CustInvSpec a on a.Version=b.Version and a.cInvCode = b.cInvCode and a.Status = 1
 where (i.cInvDefine9 is null or i.cInvDefine9='')

 set nocount off
end