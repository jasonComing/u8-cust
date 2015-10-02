USE [UFDATA_003_2015]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects where object_id = object_id(N'[dbo].[tri_RdRecords01]') and type = 'TR')
BEGIN
	DROP TRIGGER dbo.tri_RdRecords01
END
go

CREATE TRIGGER [dbo].[tri_RdRecords01]
   ON  [dbo].[RdRecords01]
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	update b set b.cDefine29=e.cInvDefine1,b.cDefine33=f.cidefine9
	from RdRecords01 b
	inner join Inserted bb on b.AutoID=bb.AutoID
	inner join v_CustSoInventoryMap m on b.isodid = m.cSOCode
	inner join Inventory e on m.cInvCode=e.cInvCode
	left join Inventory_extradefine f on e.cInvCode=f.cInvCode
	
	-- Update 入庫餘數 in 採購入庫單
	update e
	set e.cbdefine6 = a.iQuantity - d.iQuantity - a.fSumRefuseQuantity
	from rdrecords01_extradefine e
	join RdRecords01 d on d.AutoId = e.AutoId
	join PU_ArrivalVouchs a on a.AutoId = d.iArrsId
	join inserted i on i.AutoId = d.AutoId
END

GO


