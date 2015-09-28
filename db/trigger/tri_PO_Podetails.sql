USE [UFDATA_003_2015]
GO

/****** Object:  Trigger [dbo].[tri_PO_Podetails]    Script Date: 2015-09-28 14:24:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tri_PO_Podetails]
   ON  [dbo].[PO_Podetails]
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from PO_Pomain a 
	inner join PO_Podetails b on a.POID =b.POID  --and a.cPOID='PO15090051'
	inner join Inserted bb on b.ID=bb.ID
	inner join SO_SOMain c on b.SoDId=c.cSOCode
	inner join SO_SODetails d on c.ID=d.ID
	inner join Inventory e on d.cInvCode=e.cInvCode
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode

	

END

GO


