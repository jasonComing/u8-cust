update s
set s.Status = 2
from UFDATA_001_2015..CustInvSpec s
join (select cInvCode, Version
	from UFDATA_001_2015..CustInvSpec
	where Status = 1) v on v.cInvCode = s.cInvCode and s.Version < v.Version

update e
set e.cbdefine29 = s.Version
from PO_PODetails_extradefine e
join PO_PODetails d on d.ID = e.ID
join CustInvSpec s on s.cInvCode = d.cInvCode and s.Status = 1
where e.cbdefine29 is null

update e
set e.cbdefine29 = s.Version
from OM_MODetails_extradefine e
join OM_MODetails d on d.MODetailsID = e.MODetailsID
join CustInvSpec s on s.cInvCode = d.cInvCode and s.Status = 1
where e.cbdefine29 is null