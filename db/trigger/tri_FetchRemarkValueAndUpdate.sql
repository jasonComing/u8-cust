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
	Set nocount on
  declare @cinvCode varchar(20),@Remarktext nvarchar(1000),@varsion varchar(20)
	if update(status) 
		begin
	 		select inserted.cinvcode,inserted.version,CustInvSpecDetail.SpecValue  into #temptb from inserted  
				left join CustInvSpecDetail on inserted.cinvcode=CustInvSpecDetail.cinvcode
			where inserted.cinvcode=CustInvSpecDetail.cinvcode and  CustInvSpecDetail.Propertyid=102
				and inserted.Version= CustInvSpecDetail.version and inserted.status='1'
	--inserted.cinvcode='602_000010' and
	--select CustInvSpec.cinvcode,CustInvSpec.version,CustInvSpecDetail.SpecValue   from CustInvSpec  
	--left join CustInvSpecDetail on CustInvSpec.cinvcode=CustInvSpecDetail.cinvcode
	--where CustInvSpec.cinvcode=CustInvSpecDetail.cinvcode and CustInvSpecDetail.Propertyid=102
	--and CustInvSpec.Version= CustInvSpecDetail.version and CustInvSpec.status='1' order by cinvcode 
	--select * from #temptb

			update Inventory_extradefine 
				set cidefine16=(select top 1 SpecValue from  #temptb where #temptb.cinvcode=Inventory_extradefine.cinvcode  ) 
			where --( cidefine16 is  null OR cidefine16 ='') and
				Inventory_extradefine.cinvcode in (select cinvcode  from  #temptb )
		end
	Set nocount off
end 