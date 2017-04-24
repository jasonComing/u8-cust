CREATE view v_Cust_Inventory_Movt

as

select b.InvCode, d.DInvCode, sd.SpecValue as MovtModelNo
from v_Cust_bom_head_active b
join v_bom_detail_cust d on b.bomid = d.bomid
join CustInvSpecDetail sd on sd.cInvCode = d.DInvCode
join CustInvSpec ss on ss.cInvCode = sd.cInvCode and ss.Version = sd.Version
where d.DInvCode like '604%'
and ss.Status = 1
and sd.PropertyId = 126
go
