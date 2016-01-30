create view v_CustPO_POdetails_extradefine
as
select e.ID, e.cbdefine3, e.cbdefine4, e.cBDefine1, e.cBDefine2, e.cbdefine9, e.cbdefine11, e.cbdefine12, e.cBDefine15, e.cbdefine18, e.cbdefine19, e.cbdefine20, e.cbdefine21, e.cbdefine23, e.cbdefine24, e.cbdefine25, convert(int, e.cbdefine29) as cbdefine29, d.cInvCode
from PO_POdetails_extradefine e
join PO_PODetails d on d.id = e.id
go
