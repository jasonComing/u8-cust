create  trigger tri_PoMainHeadDataSet
/*
功能：自动初始化采购单表头的采购类型、部门、业务员'
		建档作废标记－否 等等信息列
作者：Jams
*/
on PO_POMain_ExtraDefine
   after insert
as
begin
	set nocount on

		 select i.POID,'01'as cPTCode , temp.cDepCode,temp.cPersonCode
		 into #t
		 from inserted i
		 left join PO_POMain p on i.poid= p.poid
		 join  (select  u.cUser_Id,u.cUser_Name, D.cDepCode,pe.cPersonCode
					from  Ufsystem..ua_user  u
					join Department d on u.cDept=d.cDepName
					left join Person  pe on u.cUser_Id =pe.cPersonCode  ) temp on  p.cMaker = temp.cUser_Name

		 update PO_POMain set cPTCode = #t.cPTCode,
								cDepCode = isnull(#t.cDepCode,''),
								cPersonCode = isnull(#t.cPersonCode,null)
		 from  PO_POMain   Join  #t  on  PO_POMain.POID = #t.POID

		 update PO_POMain_ExtraDefine set chdefine19='否'
		 from PO_POMain_ExtraDefine  join #t on PO_POMain_ExtraDefine.POID= #t.POID

	 set nocount off
end