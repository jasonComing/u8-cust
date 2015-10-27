SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects where object_id = object_id(N'[dbo].[tri_PO_Podetails]') and type = 'TR')
BEGIN
	DROP TRIGGER dbo.tri_PO_Podetails
END
go

CREATE TRIGGER [dbo].[tri_PO_Podetails]
   ON  [dbo].[PO_Podetails]
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from PO_Podetails b
	inner join Inserted bb on b.ID=bb.ID
	inner join v_CustSoInventoryMap m on b.SoDId = m.cSOCode
	inner join Inventory e on m.cInvCode=e.cInvCode
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode
	
	update b set b.cbdefine11 = i.cInvDefine7
	from PO_PODetails_extradefine b
	inner join PO_PODetails d on d.ID = b.ID
	inner join PO_POMain m on m.POId = d.POID
	inner join v_CustSoInventoryMap s on s.cSOCode = d.csocode
	inner join Inventory i on i.cInvCode = s.cInvCode
	inner join Inserted bb on b.ID = bb.ID
	
END

GO


