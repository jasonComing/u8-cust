Create TRIGGER [dbo].[tri_AddProjectNOToDiZi]
/*
功能：針對所有ICE客户的采购订单，如果採購單據中有底蓋料件,
		底內字一欄加上 project號
調用方式:新增採購單時,即時觸發執行.
*/
   ON  [dbo].[PO_PODetails_extradefine]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	--cbdefine24 底內字
	--cbdefine25 底外字
	--取出採購訂單的相關底蓋行號,且為ICE客戶的訂單(id,jobno,d_xxx,projectno)
	select i.ID,m.cSOCode,m.cInvCode,y.cInvDefine7 
	into #temp 
	from Inserted i join PO_PODetails  p on i.ID =p.ID
	left join v_CustSoInventoryMap m on m.cSOCode= p.csocode
	left join SO_SOMain so on m.cSOCode=so.cSOCode
	join Inventory y on m.cInvCode=y.cInvCode
	where p.cinvCode like '609%' 
	and so.ccusNAME  Like 'ice%'
	and i.cbdefine25 is null
	
	--更新數據	
	update b set b.cbdefine25 = #temp.cInvDefine7
	from PO_PODetails_extradefine b
	join #temp on b.ID=#temp.ID

	----合並內字+外字,寫入表體欄位"底字/內字",以便帶到到貨單表體中
	--update b set b.cbdefine1 = '內字:'+b.cbdefine24 +'外字:'+b.cbdefine25
	--from PO_PODetails_extradefine b
	--join #temp on b.ID=#temp.ID
	--where  b.cbdefine1 is null
	
END