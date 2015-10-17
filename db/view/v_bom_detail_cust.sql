SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

if exists (select * from sysobjects where id = object_id('dbo.v_bom_detail_cust') )
	drop view [dbo].[v_bom_detail_cust]
go

GO

create view [dbo].[v_bom_detail_cust] 
As
select c.SortSeq as DSortSeq, c.OpSeq as DOpSeq,bp.invcode as DInvCode, i.cinvname as DInvName, i.cinvstd as DInvStd,i.cEnglishName as DEnglishName , 
u.ccomunitname as DInvUnitName,bp.cBasEngineerFigNo as DBasEngineerFigNo,c.BaseQtyN as DBaseQtyN,c.BaseQtyD as DBaseQtyD,c.CompScrap as DCompScrap,
c.AuxUnitCode as DAuxUnitCode,aux.ccomunitname as DAuxUnitName,c.ChangeRate as DChangeRate,c.AuxBaseQtyN as DAuxBaseQtyN,
i.cInvAddCode as DInvAddCode,c.FVFlag as DFVFlag,o.WIPType as DWIPType,c.EffBegDate as DEffBegDate,
c.EffEndDate as DEffEndDate,o.Offset as DOffset,o.planfactor as DPlanRate,c.producttype as DProductType,c.ByproductFlag as DByproductFlag,
o.AccuCostFlag as DAccuCostFlag,o.CostWIPRel as DCostWIPRel,o.OptionalFlag as DOptionalFlag,o.MutexRule as DMutexRule,o.WhCode as DWhCode,
w.cWhName as DWhName,o.DrawDeptCode as DDeptCode,d.cDepName as DDeptName,c.Remark as DRemark,
i.cComUnitCode as DInvUnit, c.free1 as DInvFree_1, c.free2 as DInvFree_2, c.free3 as DInvFree_3, c.free4 as DInvFree_4, c.free5 as DInvFree_5, 
c.free6 as DInvFree_6, c.free7 as DInvFree_7, c.free8 as DInvFree_8, c.free9 as DInvFree_9, c.free10 as DInvFree_10,
c.define22 as DDefine_22,c.define23 as DDefine_23,c.define24 as DDefine_24,c.define25 as DDefine_25,c.define26 as DDefine_26,c.define27 as DDefine_27,
c.define28 as DDefine_28,c.define29 as DDefine_29,c.define30 as DDefine_30,c.define31 as DDefine_31,c.define32 as DDefine_32,c.define33 as DDefine_33,
c.define34 as DDefine_34,c.define35 as DDefine_35,c.define36 as DDefine_36,c.define37 as DDefine_37,i.cInvDefine1 as DInvDefine_1,
i.cInvDefine2 as DInvDefine_2, i.cInvDefine3 as DInvDefine_3,i.cInvDefine4 as DInvDefine_4,i.cInvDefine5 as DInvDefine_5,
i.cInvDefine6 as DInvDefine_6,i.cInvDefine7 as DInvDefine_7,i.cInvDefine8 as DInvDefine_8,i.cInvDefine9 as DInvDefine_9,
i.cInvDefine10 as DInvDefine_10,i.cInvDefine11 as DInvDefine_11,i.cInvDefine12 as DInvDefine_12,i.cInvDefine13 as DInvDefine_13,
i.cInvDefine14 as DInvDefine_14,i.cInvDefine15 as DInvDefine_15,i.cInvDefine16 as DInvDefine_16,c.opcomponentid,c.bomid as bomid 
,ord.AutoId,DSubFlag =  case when cs.ComponentSubId > 0 then '*' else '' end,DCompScrapFlag = case when cs1.OpComponentId > 0 then '*' else '' end,
COALESCE(pd.description,'') as DOpDesc,v.invattr as DPartAttr,
DAuxQty =( case when c.FVFlag = 0 then c.AuxBaseQtyN / c.BaseQtyD * (1 + c.CompScrap / 100)   
    when  c.FVFlag = 1 then c.AuxBaseQtyN / c.BaseQtyD * (1 + c.CompScrap / 100) /(1-bom_parent.parentscrap/100)	end),
DQty = ((case when c.AuxUnitCode is null or s.iBOMExpandUnitType = 1 then c.BaseQtyN else c.AuxBaseQtyN * c.Changerate end)/c.BaseQtyD * ( 1 + c.CompScrap/100) / case when c.FVFlag = 1 then (1 - bom_parent.ParentScrap/100) else 1 end *  o.PlanFactor /100 )
     

from bom_opcomponent c
inner join bom_bom on bom_bom.bomid= c.bomid
inner join bom_parent on bom_parent.bomid = c.bomid
inner join bas_part bp on bp.partid = c.componentid
inner join inventory i on i.cinvcode=bp.invcode
inner join Inventory_Sub s on i.cinvcode = s.cinvsubcode
inner join ComputationUnit u on u.cComunitCode = i.cComUnitCode
inner join bom_opcomponentopt o on o.optionsid = c.optionsid
left outer join bom_opcomponentsub  cs on cs.opcomponentid = c.opcomponentid and cs.ComponentSubId = (select min(ComponentSubId) from bom_opcomponentsub where OpComponentId = c.OpComponentId) 
left outer join bom_opcomponentscrap cs1 on cs1.OpComponentId = c.OpComponentId and cs1.toqty = 999999999999999999999.999999 
left outer join ComputationUnit aux on aux.cComunitCode = i.ccaComUnitCode
LEFT OUTER JOIN Warehouse w on w.cWhCode = o.WhCode  
left outer join v_bas_inventory v on v.invcode = i.cinvcode
LEFT OUTER JOIN Department d on d.cDepCode = o.drawDeptCode
left outer join bom_orderbom ord on bom_bom.bomid= ord.bomid and bom_bom.BomType=3
left outer join sfc_proutingdetail pd on c.opseq = pd.opseq and (pd.proutingid = (select top 1 ph.PRoutingId 
	FROM sfc_prouting ph, sfc_proutingpart pp             
	WHERE ph.PRoutingId = pp.PRoutingId and ph.status = 3 and (ph.rountingtype = 1 and bom_bom.bomtype=1 and 
    pp.PartId = bom_parent.parentid AND bom_bom.versioneffdate >= ph.VersionEffDate and  bom_bom.versioneffdate <= ph.VersionEndDate) 
or (ph.rountingtype = 2 and bom_bom.bomtype=2 and pp.PartId = bom_parent.parentid and bom_bom.identcode = ph.identcode)
order by ph.VersionEffDate desc))

GO


