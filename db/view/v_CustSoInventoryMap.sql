alter VIEW dbo.v_CustSoInventoryMap
AS
	-- Display SO No, Inventory Code
	select c.cSOCode, d.cInvCode
	from SO_SOMain c
	inner join SO_SODetails d on d.AutoID = (
		select top 1 AutoID 
		from SO_SODetails 
		join  SO_SODetails_extradefine sx on  SO_SODetails.iSOsID=sx.iSOsID
		where SO_SODetails.ID = c.ID
		and cInvCode != 'D_GENERAL'
		and sx.cbdefine30 > 0 )
	where len(c.csocode) = 10
	and c.csocode not like '%/%'
	and c.csocode not like '%\%'
	and c.csocode not like '%-%'
