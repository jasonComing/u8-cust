CREATE view v_SoInvPoDetailsMap
as
select d.sodid, d.cInvCode, max(m.cpoid) as cPoid
from PO_PODetails d
join PO_POMain m on m.poid = d.poid
where d.sodid is not null
group by d.sodid, d.cInvCode
