CREATE  trigger tri_PoVersonAutoInsert
/*
功能：自动补上采购单据表身料件的规格版本号,
	　版本号取新建采购单据时，系统已经审核的版本号．		
作者：Jams
*/
on PO_Podetails_ExtraDefine
	for insert
as
begin
	update e  
	set cbdefine29 = c.Version
	from PO_Podetails_ExtraDefine e
	inner join inserted i on e.ID = i.ID
	inner join PO_Podetails s on e.id = s.id
	inner join CustInvSpec c on s.cInvCode = c.cInvCode
	where c.Status = 1 and
	(e.cbdefine29 is null OR e.cbdefine29 = '')
end