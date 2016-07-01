create trigger tri_AutoFillPodata
/*
功能：采购员批理生单时，自动补上表头相关必填项，
		（部门、业务员、付款条件、质量等级-A，建档作废标记－否）
		表身补士啤行、赠品－否，不参加MRP运算
作者：Jams
*/
on po_pomain
   after update
as
begin
	set nocount on

	declare @poid bigint

	if UPDATE (csysbarcode)
        and not exists (SELECT 1 from Deleted where csysbarcode is not null)
        and not exists (select 1 from Inserted where cPTCode is not null)
	begin

		declare mycursor cursor for
			select POID from inserted

		open mycursor
		fetch next from mycursor into @poid

		while @@FETCH_STATUS = 0
		begin
			exec SP_AutoFillPodata  @poid
			fetch next from mycursor into @poid
		end

		close mycursor
		deallocate mycursor
	end

	set nocount off
end