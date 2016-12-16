Create trigger [dbo].[tri_PVBaddSoCode]
/*
功能:新建採購發標時,表體行補足JOB號
JAMS  2016/12/06
*/
on [dbo].[PurBillVouchs_extradefine]
   after insert, update
as
begin
	set nocount on

	update pe set cbdefine3 = temp.csocode
	from PurBillVouchs_extradefine pe
	inner join (
		select i.cbdefine3,po.csocode,p.ID
		from inserted i
		left join PurBillVouchs p on i.id = p.id
		left join PO_Podetails po on po.id = p.iPOsID
		) temp on temp.ID = pe.ID
	where pe.cbdefine3 is null or pe.cbdefine3 = ''

	set nocount off
end