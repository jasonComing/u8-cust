create view v_CustInvSpecActiveVersion
as
select cInvCode, max(version) as version
from CustInvSpec
where ClosedBy is null
group by cInvCode