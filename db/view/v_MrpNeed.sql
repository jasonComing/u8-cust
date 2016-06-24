CREATE view  v_MrpNeed
/*
功能：查询PE料件(包料、604_000017)所计划的需求列表
Auto:JAMS
*/
as
	 Select v.InvCode,i.cInvName,n.*
	 from mps_netdemand n inner join bas_part p on n.PartId = p.PartId
	 inner join mps_planproject j on n.ProjectId=j.ProjectId
	 inner join v_bas_inventory v on p.InvCode = v.InvCode
	 inner join Inventory i on v.InvCode=i.cInvCode
	 inner join mps_plancode c on j.PlanCodeId=c.PlanCodeId
	 Left Outer join mps_netdemandbak nbak on n.DemandId=nbak.DemandId
	 Left Outer join AA_RequirementClass rc on rc.cRClassCode=n.DemandCode
	 left outer join person psp on i.cPurPersonCode=psp.cPersonCode
	 left outer join person psi on i.cInvPersonCode=psi.cPersonCode
	 left outer join person pcu on n.CloseUser=pcu.cPersonCode
	 Where n.delflag = 0
	 And  ((coalesce(n.SupplyingRCode,'') = '') Or (n.PlanCode=n.SupplyingRCode And n.PlanCode=n.SupplyingPCode))
	 And  1=1
	 And ((v.InvCCode >= N'801') And (v.InvCCode <= N'818')) And n.Status in (1,2,4) and c.PlanCode= N'01'and ( n.SupplyType In (0,1,2,3,7))
	 or (v.InvCode='604_000017')
	 --or (v.InvCode <> '1')
	 --Order by n.PlanCode