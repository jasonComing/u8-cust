CREATE VIEW dbo.v_CustSoInventoryMap
AS
	-- Display SO No, Inventory Code
	select c.cSOCode, d.cInvCode
	from SO_SOMain c
	inner join SO_SODetails d on d.AutoID = (select top 1 AutoID from SO_SODetails where SO_SODetails.ID = c.ID)
GO