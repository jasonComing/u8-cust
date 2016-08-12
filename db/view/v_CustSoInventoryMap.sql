alter VIEW dbo.v_CustSoInventoryMap
AS
 -- Display SO No, Inventory Code
 select c.cSOCode, d.cInvCode
 from SO_SOMain c
 inner join SO_SODetails d on d.AutoID = (
  select top 1 AutoID 
  from SO_SODetails 
  join SO_SODetails_extradefine on SO_SODetails.iSOsID=SO_SODetails_extradefine.iSOsID
  where SO_SODetails.ID = c.ID 
  and SO_SODetails_extradefine.cbdefine30 > 0
  and cInvCode != 'D_GENERAL' )
 where len(c.csocode) = 10
 and c.csocode not like '%/%'
 and c.csocode not like '%\%'
 and c.csocode not like '%-%'
 and c.cSTCode != '03'