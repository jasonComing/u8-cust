CREATE  trigger tri_PoVersonAutoInsert
/*
���ܣ��Զ����ϲɹ����ݱ����ϼ��Ĺ��汾��,
	���汾��ȡ�½��ɹ�����ʱ��ϵͳ�Ѿ���˵İ汾�ţ�		
���ߣ�Jams
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