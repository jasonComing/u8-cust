USE [UFDATA_003_2015]
GO

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
END

GO


