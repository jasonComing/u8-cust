CREATE  trigger tri_PoVersonAutoInsert
/*
功能：自动补上采购单据表身料件的规格版本号
作者：Jams
*/
on PO_Podetails_ExtraDefine
   for insert
as
begin
	--Set nocount on
	--declare  @id int,@cInvcode varchar(20),@cVerson varchar(10)
	--declare my_cursor  cursor for
	--	--Select  id,cInvCode From inserted   order by id desc 
	--	Select ID from  inserted
	--open my_cursor
	--fetch next from my_cursor into @id

	--while @@FETCH_STATUS = 0 
	--begin
	--	select @cInvcode=cinvCode from PO_Podetails  where id=@id
	--	select top 1 @cVerson=Version from CustInvSpec where cInvCode =@cInvcode  and Status = 1
 --       update PO_Podetails_ExtraDefine set cbdefine27=@cVerson where  id=@id and ( cbdefine27 is  null OR cbdefine27 ='')
	--	--raisError(@cVerson,16,11)
	--	fetch next from my_cursor into @id
	--end
	
	--close my_cursor
	--deallocate my_cursor
	--set nocount off
	set nocount on
		select ta.id,tb.cinvCode,tc.version into #temptb from inserted ta
			left join PO_Podetails tb on ta.id=tb.id
			left join CustInvSpec tc on tb.cInvCode=tc.cInvCode
			where --tb.cInvCode='605_000111'and 
			tc.Status = 1
		update PO_Podetails_ExtraDefine set cbdefine27=(select top 1 version from  #temptb where PO_Podetails_ExtraDefine.id=#temptb.id ) 
		where  cbdefine27 is  null OR cbdefine27 =''

	 set nocount off
end