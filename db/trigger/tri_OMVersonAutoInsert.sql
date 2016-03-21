create  trigger tri_OMVersonAutoInsert
/*
���ܣ��Զ�����ί�ⶩ�����ݾݱ����ϼ��Ĺ��汾��,
	���汾��ȡ�½�ί�ⶩ��ʱ��ϵͳ�Ѿ���˵İ汾�ţ�		
���ߣ�Jams
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