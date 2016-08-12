

alter TRIGGER [dbo].[tri_PO_Podetails]
   ON  [dbo].[PO_Podetails]
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- 客號, 款號
	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from PO_Podetails b
	inner join Inserted bb on b.ID=bb.ID
	inner join v_CustSoInventoryMap m on b.cSOCode = m.cSOCode
	inner join Inventory e on m.cInvCode=e.cInvCode
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode
	
	-- 客號, 款號 (散件)
	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from PO_Podetails b
	inner join Inserted bb on b.ID=bb.ID
	inner join PO_POMain m on m.poid = b.poid
	inner join SO_SODetails_extradefine d on d.isosid = b.isosid
	inner join Inventory e on e.cInvCode = d.cbdefine40
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode
	where m.cPTCode = '02'
	
	-- 开发技术参数, 機蕊類型
	update b set b.cbdefine11 = i.cInvDefine7, b.cbdefine12 = i.cInvDefine9
	from PO_PODetails_extradefine b
	inner join PO_PODetails d on d.ID = b.ID
	inner join v_CustSoInventoryMap s on s.cSOCode = d.csocode
	inner join Inventory i on i.cInvCode = s.cInvCode
	inner join Inserted bb on b.ID = bb.ID


	--手动新增/修改PO行JOB号时,变更csocode为手动指定的JOB号
	 update b set b.csocode =p.cbdefine3,b.SoType=5
	 from PO_Podetails b
	 inner join Inserted bb on b.ID=bb.ID
	 inner join PO_Podetails_extradefine P on bb.id =p.id
	 where p.cbdefine3 is not null


	--修正PO来源为跟JOB,以便入库可以自动预留
	 update b set b.SoType = 5
	 from PO_Podetails b
	 inner join Inserted bb on b.ID=bb.ID
	 where b.csocode is not null
	 and b.SoType != 5

END

GO


