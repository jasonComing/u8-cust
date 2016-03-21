CREATE  trigger [dbo].[tri_UpdateSoDetails_setActualQty] ON [dbo].[SO_SODetails]  
/*
���ܣ������۶����ر���ʱ���Զ����Ѿ���Ʊ��������д��"ʵ������"һ��
*/ 
FOR Update,insert
AS  
set nocount on  

update SO_SODetails_ExtraDefine
set cbdefine30 = case
  when i.cscloser is null then isnull(i.iQuantity,0)
  else isnull(i.iKPQuantity, 0)
  end,
  cbdefine31=cbdefine30 * i.iUnitPrice  
from SO_SODetails_ExtraDefine s
inner join inserted i on s.isosid = i.isosid

set nocount off