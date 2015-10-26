SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER tri_PO_Podetails
   ON  PO_Podetails
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	/*
    select b.iorderdid,b.csoordercode,a.cPOID,b.*
	from PO_Pomain a 
	inner join PO_Podetails b on a.POID =b.POID
	inner join SO_SODetails c on b.iSOsID=c.AutoID

	select * from SO_SODetails
	select * from SO_SOMain where cSOCode in('0000000004','0000000005','0000000006')

	select b.*
	from SO_SOMain a 
	inner join SO_SODetails b on a.ID=b.ID and a.cSOCode in('0000000004','0000000005','0000000006')
	*/


	--select b.iorderdid,b.csoordercode,a.cPOID,b.SoDId,e.cInvDefine1,f.cidefine9,b.cDefine29,b.cDefine33
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

	--select b.cDefine30,b.csocode,b.*
	--from PO_Pomain a 
	--inner join PO_Podetails b on a.POID =b.POID  and a.cPOID='PO15090051'