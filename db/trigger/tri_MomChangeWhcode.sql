alter  trigger [dbo].[tri_MomChangeWhcode]
/*
 功能：PMC修改生產部門為38-辦倉時，自動關連修改料件出庫倉別為 21－辦倉
		方便材料出庫扣倉。
 Auth:Jams
 调用：修改生產訂單-生產部門時，自动触发
*/
on mom_orderdetail
   after update
as
begin
	Set nocount on

	if update(MDeptCode)
	begin
		update m set  WhCode ='21'
		from mom_moallocate m
		left join inserted i on m.modid=i.modid
		where m.InvCode like '6%' and m.WhCode ='03'
		and i.MDeptCode =38
	end

	set nocount off
end