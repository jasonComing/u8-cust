alter  trigger [dbo].[tri_UpdateSoDetails_setActualQty] ON [dbo].[SO_SODetails]  
/*
功能：当销售订单关闭行时，自动将已经开票的数量回写到"实际数量"一列
		,并计算总金额.
*/ 
FOR Update,insert
AS  
set nocount on  

--declare @quantity int
--select @quantity = case
--  when id.cscloser is null then isnull(id.iQuantity,0)
--  else isnull(id.iKPQuantity, 0)
--  end
--from inserted id

--update SO_SODetails_ExtraDefine
--set cbdefine30 = @quantity,
--  cbdefine31=@quantity * i.iUnitPrice  
--from SO_SODetails_ExtraDefine s
--inner join inserted i on s.isosid = i.isosid

  --批量修改,查找出需修改的行与数据(行号,订单量,开票量,单价,是否关闭)
	select isosid,iQuantity,iKPQuantity,iUnitPrice,cscloser
	into #temp
	from inserted

	update SO_SODetails_ExtraDefine
	set cbdefine30 =isnull(i.iQuantity,0) ,
	cbdefine31=isnull(i.iQuantity,0) * i.iUnitPrice  
	from SO_SODetails_ExtraDefine s
	inner join #temp i on s.isosid = i.isosid
	where cscloser is null

	update SO_SODetails_ExtraDefine
	set cbdefine30 =isnull(i.iKPQuantity,0),
	cbdefine31=isnull(i.iKPQuantity,0) * i.iUnitPrice  
	from SO_SODetails_ExtraDefine s
	inner join #temp i on s.isosid = i.isosid
	where cscloser is not null

set nocount off



select * from [SO_SODetails] where cSOCode='test0422'

update [SO_SODetails] set iKPQuantity=50 where autoID=15073
15073