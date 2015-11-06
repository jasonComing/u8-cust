create view v_CustInvPrice
as

select SKU, min(DocDate) as DocDate, Currency, JobNo, UnitPrice, sum(Quantity) as Quantity
from (
select DocDate, CustomerName, Currency, SKU, Quantity, JobNo, PoNo, UnitPrice, 'PI' as Source
from CustPiOrder
where not exists (select 1 from SO_SOMain where csocode = JobNo)
union
select m.dDate, m.cCusName, m.cexch_name, i.cInvDefine1, d.iQuantity, m.csocode, d.cDefine25, d.iUnitPrice, 'U8' as Source
from SO_SOMain m
join SO_SODetails d on d.id = m.id
join Inventory i on i.cInvCode = d.cInvCode
where m.csocode = 'J1452/15') t
group by SKU, Currency, JobNo, UnitPrice