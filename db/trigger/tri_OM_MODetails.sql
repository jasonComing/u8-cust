alter  TRIGGER [dbo].[tri_OM_MODetails]
/*
功能:自動補上委外訂單的客號與型號
*/
   ON  [dbo].[OM_MODetails]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON

	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from OM_MODetails b
	inner join Inserted bb on b.MODetailsID=bb.MODetailsID
	inner join v_CustSoInventoryMap m on b.cSOCode = m.cSOCode
	inner join Inventory e on m.cInvCode=e.cInvCode
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode

	SET NOCOUNT OFF
END
