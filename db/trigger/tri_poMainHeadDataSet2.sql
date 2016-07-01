create trigger tri_PoMainHeadDataSet2
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

		 update PO_POMain_ExtraDefine
		 set chdefine19 = '否'
		 from PO_POMain_ExtraDefine
		 join inserted on inserted.POID = inserted.POID
		 where PO_POMain_ExtraDefine.chdefine19 is null

	 set nocount off
end