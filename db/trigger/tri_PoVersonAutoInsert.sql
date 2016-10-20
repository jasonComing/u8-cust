CREATE  trigger tri_PoVersonAutoInsert
/*
功能：自动补上采购单据表身料件的规格版本号,
	　版本号取新建采购单据时，系统已经审核的版本号．
作者：Jams
*/
on PO_Podetails_extradefine
	for insert
as
begin
	update e  
	set cbdefine29 = isnull(c.Version,'')
	from PO_Podetails_ExtraDefine e
	inner join inserted i on e.ID = i.ID
	inner join PO_Podetails s on e.id = s.id
	inner join CustInvSpec c on s.cInvCode = c.cInvCode
	where c.Status = 1 and
	(e.cbdefine29 is null OR e.cbdefine29 = '')

	--電鍍PO時，以關連料號的版本號來更新
	update e
	set cbdefine29 = isnull(c.Version,'')
	from PO_Podetails_ExtraDefine e
	inner join inserted i on e.ID = i.ID
	inner join PO_Podetails s on e.id = s.id
	left join  PO_Pomain  pm  on pm.POID=s.POID
	inner join CustInvSpec c on e.cbdefine39 = c.cInvCode
	where pm.cPTCode=99 and
	e.cbdefine39 is not null and
	c.Status = 1 
	--and (e.cbdefine29 is null OR e.cbdefine29 = '')

end
GO