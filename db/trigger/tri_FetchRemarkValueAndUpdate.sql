Create trigger tri_FetchRemarkValueAndUpdate
/*
�����ܣ���˹����ʱ����ȡ������е�"��������"�ֶ�ֵ
���޸�U8ϵͳ������������ֶΣ�
������ʵ����
��Auth:jams
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


