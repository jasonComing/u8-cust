create view v_CustOM_MODetails_extradefine
as
select e.MODetailsID, e.cbdefine3, e.cbdefine4, e.cBDefine1, e.cbdefine9, e.cbdefine18, e.cbdefine24, e.cbdefine25, convert(int, e.cbdefine29) as cbdefine29, d.cInvCode
from OM_MODetails_extradefine e
join OM_MODetails d on d.MODetailsID = e.MODetailsID
go