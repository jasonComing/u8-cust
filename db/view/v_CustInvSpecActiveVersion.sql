create view v_CustInvSpecActiveVersion
as
select cInvCode, max(version) as version
from CustInvSpec
where ClosedBy is null
and ApprovedBy is not null
group by cInvCode