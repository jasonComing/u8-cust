create  trigger [dbo].[tri_UpdateSoDetails_setActualQty] ON [dbo].[SO_SODetails]  
/*
功能：当销售订单关闭行时，自动将已经开票的数量回写到"实际数量"一列
*/ 
FOR Update,insert
AS  
set nocount on  

declare @quantity int
select @quantity = case
  when id.cscloser is null then isnull(id.iQuantity,0)
  else isnull(id.iKPQuantity, 0)
  end
from inserted id

update SO_SODetails_ExtraDefine
set cbdefine30 = @quantity,
  cbdefine31=@quantity * i.iUnitPrice  
from SO_SODetails_ExtraDefine s
inner join inserted i on s.isosid = i.isosid

set nocount off

