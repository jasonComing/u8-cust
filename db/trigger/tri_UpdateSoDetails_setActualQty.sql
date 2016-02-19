 Create trigger [dbo].[tri_UpdateSoDetails_setActualQty] ON [dbo].[SO_SODetails]  
/*
功能：当销售订单关闭行时，自动将已经开票的数量回写到"实际数量"一列
*/ 
FOR Update 
AS  
set nocount on  
if update(cscloser)
begin
	if exists(select * from inserted where cscloser <> '' and iKPQuantity > 0  )
		begin
			update SO_SODetails_ExtraDefine set cbdefine30 = isnull(iKPQuantity,0)
			from SO_SODetails_ExtraDefine s inner join inserted i on s.isosid = i.isosid
		end
	else
		begin
			update SO_SODetails_ExtraDefine set cbdefine30 = isnull(iQuantity,0)
			from SO_SODetails_ExtraDefine s inner join inserted i on s.isosid = i.isosid
		end
end
set nocount off  

