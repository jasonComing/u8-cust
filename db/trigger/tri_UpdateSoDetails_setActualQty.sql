alter  trigger [dbo].[tri_UpdateSoDetails_setActualQty] ON [dbo].[SO_SODetails]  
/*
功能：当销售订单关闭行时，自动将已经开票的数量回写到"实际数量"一列
		,并计算总金额.
*/ 
FOR Update,insert
AS  
	set nocount on  
  --批量修改,查找出需修改的行与数据(行号,订单量,开票量,单价,是否关闭)
	update SO_SODetails_ExtraDefine
	set cbdefine30 =(
			case when cSCloser is null then	isnull(i.iQuantity,0)
			else 
				isnull(i.iKPQuantity,0)
			end
			)
	from SO_SODetails_ExtraDefine s
	inner join inserted i on s.isosid = i.isosid
 
	update SO_SODetails_ExtraDefine
	set cbdefine31=cbdefine30 * i.iUnitPrice  
	from SO_SODetails_ExtraDefine s
	inner join inserted i on s.isosid = i.isosid

	set nocount off



--select * from [SO_SODetails] where cSOCode='test0422'

--update [SO_SODetails] set iKPQuantity=50 where autoID=15073
--15073