SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER tri_PO_Podetails_SetSoDId
   ON  PO_Podetails_extradefine
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	if UPDATE(cbdefine3)
	BEGIN
		update a set a.SoDId=b.cbdefine3,a.csocode=b.cbdefine3 
		from PO_Podetails a 
		inner join Inserted b on a.ID=b.ID 
		and isnull(a.SoDId,'')='' 
		and isnull(b.cbdefine3,'')!=''
	END

END
GO

--select a.SoDId,b.cbdefine3,a.csocode,b.cbdefine3 from  PO_Podetails a inner join PO_Podetails_extradefine b on a.ID=b.ID --and isnull(a.SoDId,'')!='' and isnull(b.cbdefine3,'')!=''

--update a set a.SoDId=b.cbdefine3,a.csocode=b.cbdefine3 from PO_Podetails a inner join PO_Podetails_extradefine b on a.ID=b.ID and isnull(b.cbdefine3,'')='JOB150300025'
