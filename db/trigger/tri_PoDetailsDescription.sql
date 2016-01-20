USE [UFDATA_003_2015]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects where object_id = object_id(N'[dbo].[tri_PoDetailsDescription]') and type = 'TR')
BEGIN
	DROP TRIGGER dbo.tri_PoDetailsDescription
END
go

ALTER TRIGGER [dbo].[tri_PoDetailsDescription]
   ON  [dbo].[PO_Podetails_extradefine]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(cbdefine19)
    BEGIN
	  
		-- item formula
		update d set d.cbdefine20=isnull(d.cbdefine19, i.cidefine13)
		from PO_Podetails_extradefine d
		join Inserted bb on d.Id=bb.Id
		join PO_PODetails dd on dd.id = d.id
		join Inventory_extradefine i on i.cInvCode = dd.cInvCode
	
	END
END




