create trigger tri_PoMainHeadDataSet
/*
功能：自动初始化采购单表头的采购类型、部门、业务员'
		建档作废标记－否 等等信息列
作者：Jams
*/
on PO_POMain
   after insert
as
begin
	set nocount on

		select m.Poid, '01'as cPTCode, pe.cPersonCode, pe.cPersonName, d.cDepCode
		into #t
		from Person pe
		join Department d on pe.cDepCode = d.cDepCode
		join PO_POMain m on m.cMaker = pe.cPersonName
		join Inserted i on i.PoId = m.PoId
		where d.cDepCode in ('24', '25', '26', '27', '28', '41')

		 update PO_POMain
		 set cPTCode = #t.cPTCode
		 from  PO_POMain
		 Join  #t  on  PO_POMain.POID = #t.POID
		 where PO_POMain.cPTCode is null
		 
		 update PO_POMain
		 set cPersonCode = #t.cPersonCode
		 from  PO_POMain
		 Join  #t  on  PO_POMain.POID = #t.POID
		 where PO_POMain.cPersonCode is null

		 update PO_POMain
		 set cDepCode = #t.cDepCode
		 from  PO_POMain
		 Join  #t  on  PO_POMain.POID = #t.POID
		 where PO_POMain.cDepCode is null
		
		 update PO_POMain
		 set cdefine1 = 'A'
		 from  PO_POMain
		 Join  #t  on  PO_POMain.POID = #t.POID
		 where PO_POMain.cdefine1 is null

		 update PO_POMain
		 set cPayCode = '01'
		 from  PO_POMain
		 Join  #t  on  PO_POMain.POID = #t.POID
		 where PO_POMain.cPayCode is null

	 set nocount off
end
