create proc  pro_InsertRow
/*
功能：依产成品料号(Ｄ／Ｓ．．)＋版本号
		自动补上相关料号的Project号
*/
as 
begin
	Set nocount on
	declare @cInvcode varchar(30),@cVerson int,@projectNO varchar(30)
	declare my_cursor  cursor for
		select  DISTINCT  Version,cInvCode   from CustInvSpecDetail 　where cInvCode like '%D%' or cInvCode like '%S%'  order by  cInvCode
	
	open my_cursor
	fetch next from my_cursor into @cVerson,@cInvcode
	while @@FETCH_STATUS = 0 
	begin
		if (exists(select * from Inventory where cInvcode=@cInvcode and cinvdefine7 is not null) 
			and (not exists(select * from CustInvSpecDetail where cInvcode=@cInvcode and version=@cVerson and propertyid=212 )) )
			begin
				select top 1  @projectNO =isnull(cinvdefine7,'') from Inventory where  cInvCode = @cInvcode
				insert into CustInvSpecDetail(cInvcode,Version,PropertyId,SpecValue,LastModified)values(@cInvcode,@cVerson,212,@projectNO,getdate())
			end 
			
		fetch next from my_cursor into @cVerson,@cInvcode
	end
	
	close my_cursor
	deallocate my_cursor
	set nocount off
end 