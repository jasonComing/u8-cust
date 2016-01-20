Create trigger tri_FetchRemarkValueAndUpdate
/*
　功能：审核规格书时，提取规格书中的"其他描述"字段值
　修改U8系统存货档的描述字段，
　调用实例：
　Auth:jams
*/
on  CustInvSpec
for update
as 
begin  
	declare @cinvCode varchar(20)
	declare @Remarktext nvarchar(1000)
	declare @varsion varchar(20)
	if update(status) 
	begin
		update  ie 
		set ie.cidefine16 =c.SpecValue
		from  Inventory_extradefine ie
		inner join inserted d on  ie.cinvcode = d.cinvcode
		left join CustInvSpecDetail c on (d.cinvcode = c.cinvcode and d.version = c.version)
		where d.status = 1 and 
		c.Propertyid = 102  
	end
end 


