create  trigger tri_OMVersonAutoInsert
/*
功能：自动补上委外订单单据据表身料件的规格版本号,
	　版本号取新建委外订单时，系统已经审核的版本号．		
作者：Jams
*/
on OM_MODetails_extradefine
	for insert
as
begin
	update e  
	set cbdefine29 = isnull(c.Version,'')
	from OM_MODetails_extradefine e
	inner join inserted i on e.MODetailsID  = i.MODetailsID 
	inner join OM_MODetails s on e.MODetailsID  = s.MODetailsID 
	inner join CustInvSpec c on s.cInvCode = c.cInvCode
	where c.Status = 1 and
	(e.cbdefine29 is null OR e.cbdefine29 = '')
end