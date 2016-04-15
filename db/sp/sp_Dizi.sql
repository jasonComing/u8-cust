ALTER proc [dbo].[sp_Dizi]
/*
功能:將PO單據上內外字一欄沒有信息的,
		以內字列+外字列的內容補填上
		以便做到貨時,可以帶出底蓋的內外字信息
*/
AS
begin
	update PO_Podetails_extradefine set cBDefine1=isnull(cbdefine24,'')+isnull(cbdefine25,'')
	where cBDefine1 is null
	and ID in( select d.ID from PO_Podetails_extradefine  d 
				where (d.cbdefine24 is not null or d.cbdefine25 is not null ) and  d.cBDefine1 is null
				)
end