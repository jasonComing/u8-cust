create view v_CustInvPrice
as

select SKU, min(DocDate) as DocDate, Currency, JobNo, UnitPrice, MovementPrice, PackingPrice, PricingMemo, sum(Quantity) as Quantity
from (
select DocDate, CustomerName, Currency, SKU, Quantity, JobNo, PoNo, UnitPrice, null as MovementPrice, null as PackingPrice, null as PricingMemo, 'PI' as Source
from CustPiOrder
where not exists (select 1 from SO_SOMain where csocode = JobNo)
union
select m.dDate, m.cCusName, m.cexch_name, i.cInvDefine1, d.iQuantity, m.csocode, d.cDefine25, d.iUnitPrice, x.cbdefine16 as MovementPrice, x.cbdefine17 as PricingMemo, dx.chdefine15 as PricingMemo, 'U8' as Source
from SO_SOMain m
join SO_SODetails d on d.id = m.id
left join SO_SODetails_extradefine x on x.iSOsID = d.iSOsID
left join SO_SOMain_extradefine dx on dx.ID = d.ID
join Inventory i on i.cInvCode = d.cInvCode
where m.csocode not like '%_SP') t
group by SKU, Currency, JobNo, UnitPrice, MovementPrice, PackingPrice, PricingMemo