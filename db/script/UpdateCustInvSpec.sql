update s
set s.Status = 2
from UFDATA_001_2015..CustInvSpec s
join (select cInvCode, Version
	from UFDATA_001_2015..CustInvSpec
	where Status = 1) v on v.cInvCode = s.cInvCode and s.Version < v.Version
