create view v_CustBomRootMap
as
select i.cinvcode, isnull(dhr.InvCode, dh.InvCode) as HeadCInvCode
from Inventory i
left join v_bom_detail_cust d on d.dinvcode = i.cinvcode
left join v_bom_head dh on dh.bomid = d.bomid
-- one more level!
left join v_bom_detail_cust dr on dr.dinvcode = dh.InvCode
left join v_bom_head dhr on dhr.bomid = dr.bomid
