alter proc SP_AutoFillPodata
/*
功能：采购员批理生单时，自动补上表头相关必填项，
		（部门、业务员、付款条件、质量等级-A，建档作废标记－否）
		表身补士啤行、赠品－否，不参加MRP运算

调用：在采购入单保存新增时，自动触发执行
		exec SP_AutoFillPodata  1000021343
作者：jams
*/
@poid bigint= 0 --採購單POID
as
begin
	set nocount on

	declare @PoNO  varchar(30)			--采购订单号

	declare @rowcount int				--表体需要加载士啤的行数
	declare @MaxRowNum int				--表体最大行号

	if not exists(select * from PO_Pomain where POID =@poid )
		return

	--取出cpoid
	select  top 1 @PoNO=cPOID  from  PO_Pomain  where POID =@poid

	--变更表头信息
	update PO_POMain
	set cPTCode = isnull(cPTCode, '01'),
		cdefine1 = isnull(cdefine1, 'A'),
		cPayCode = isnull(cPayCode, '01')
	where POID =@poid

	update PO_PoMain
	set cDepCode = isnull(PO_PoMain.cDepCode, Department.cDepCode),
		cPersonCode = isnull(PO_PoMain.cPersonCode, Person.cPersonCode)
	from PO_PoMain
	join Person on Person.cPersonName = PO_PoMain.cMaker
	left join Department on Department.cDepCode = Person.cDepCode
	where PO_PoMain.POID = @poid

	--表头扩展项
	update PO_POMain_ExtraDefine
	set chdefine19 = '否'
	from PO_POMain_ExtraDefine
	where chdefine19 is null
	and POID=@poid


	--====以下为表体更新　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
	--取出表体需要加载士啤的行数
	select @rowcount =count(*) from PO_Podetails
	where poid=@poid
	and bgift=0

	select @MaxRowNum =max(ivouchrowno) from PO_Podetails where poid=@poid

	if(@rowcount = 0 or @MaxRowNum =0)
		return

	--取出等待要插入的表体ID号
	declare @ifatherID int
	declare @iChildID int
	exec sp_getID N'00',N'001',N'Pomain',@rowcount,@ifatherID output,@iChildID output

	declare @bodyID bigint
	declare @invCode varchar(30)
	declare @iQuantity int
	declare @iRate  float
	declare @irowx int

	set @irowx=1

	declare my_cursor cursor for
			select PO_Podetails.ID,PO_Podetails.cInvCode,PO_Podetails.iQuantity,isnull(Inventory.cInvDefine13,0.0) as iRate from PO_Podetails
			left join Inventory  on PO_Podetails.cinvCode=Inventory.cinvCode
			where poid=@poid
			and bgift=0
			order by PO_Podetails.ivouchrowno

	open my_cursor
	fetch next from my_cursor into @bodyID, @invCode,@iQuantity,@iRate

	while @@FETCH_STATUS = 0
	begin
			Insert Into PO_PODetails(id,cpoid,cinvcode,iquantity,inum,iquotedprice,iunitprice,imoney,itax,isum,idiscount,inatunitprice,
				inatmoney,inattax,inatsum,inatdiscount,darrivedate,cfree1,cfree2,ipertaxrate,cdefine22,cdefine23,
				cdefine24,cdefine25,cdefine26,cdefine27,iflag,citemcode,citem_class,ppcids,citemname,cfree3,cfree4,cfree5,
				cfree6,cfree7,cfree8,cfree9,cfree10,bgsp,poid,cunitid,itaxprice,iappids,cdefine28,cdefine29,cdefine30,
				cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,isosid,btaxcost,csource,cbcloser,ippartid,
				ipquantity,iptoseq,sotype,sodid,contractrowguid,cupsocode,iinvmpcost,contractcode,contractrowno,fporefusequantity,
				fporefusenum,iorderdid,iordertype,csoordercode,iorderseq,cbclosetime,cbclosedate,cbg_itemcode,cbg_itemname,
				cbg_caliberkey1,cbg_caliberkeyname1,cbg_caliberkey2,cbg_caliberkeyname2,cbg_caliberkey3,cbg_caliberkeyname3,
				cbg_calibercode1,cbg_calibername1,cbg_calibercode2,cbg_calibername2,cbg_calibercode3,cbg_calibername3,ibg_ctrl,
				cbg_auditopinion,fexquantity,fexnum,ivouchrowno,cbg_caliberkey4,cbg_caliberkeyname4,cbg_caliberkey5,cbg_caliberkeyname5,
				cbg_caliberkey6,cbg_caliberkeyname6,cbg_calibercode4,cbg_calibername4,cbg_calibercode5,cbg_calibername5,
				cbg_calibercode6,cbg_calibername6,csocode,irowno,cxjspdids,cbmemo,planlotnumber,bgift,cbsysbarcode)

			select @iChildID - @rowcount + @irowx,cpoid,cinvcode,@iQuantity * @iRate ,0,iquotedprice,0,0,itax,0,idiscount,0,
				0,0,0,inatdiscount,darrivedate,cfree1,cfree2,ipertaxrate,cdefine22,cdefine23,
				cdefine24,cdefine25,cdefine26,cdefine27,iflag,citemcode,citem_class,ppcids,citemname,cfree3,cfree4,cfree5,
				cfree6,cfree7,cfree8,cfree9,cfree10,bgsp,poid,cunitid,0,iappids,cdefine28,cdefine29,'false',
				cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,isosid,btaxcost,csource,cbcloser,ippartid,
				ipquantity,iptoseq,sotype,sodid,contractrowguid,cupsocode,iinvmpcost,contractcode,contractrowno,fporefusequantity,
				fporefusenum,iorderdid,iordertype,csoordercode,iorderseq,cbclosetime,cbclosedate,cbg_itemcode,cbg_itemname,
				cbg_caliberkey1,cbg_caliberkeyname1,cbg_caliberkey2,cbg_caliberkeyname2,cbg_caliberkey3,cbg_caliberkeyname3,
				cbg_calibercode1,cbg_calibername1,cbg_calibercode2,cbg_calibername2,cbg_calibercode3,cbg_calibername3,ibg_ctrl,
				cbg_auditopinion,fexquantity,fexnum, @MaxRowNum+@irowx ,cbg_caliberkey4,cbg_caliberkeyname4,cbg_caliberkey5,cbg_caliberkeyname5,
				cbg_caliberkey6,cbg_caliberkeyname6,cbg_calibercode4,cbg_calibername4,cbg_calibercode5,cbg_calibername5,
				cbg_calibercode6,cbg_calibername6,csocode,irowno,cxjspdids,cbmemo,planlotnumber,1,'||pupo|'+@PoNO+'|'+ cast( @MaxRowNum+@irowx as varchar)
			from 	PO_PODetails where id=@bodyID


		-- 插入扩展表
		 Insert Into PO_PODetails_ExtraDefine(id,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,
			  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,
			  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39)

	　	 select @iChildID - @rowcount + @irowx ,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,
			  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,
			  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39
		 from PO_PODetails_ExtraDefine
		 where id=@bodyID

		set @irowx=@irowx+1

		fetch next from my_cursor into @bodyID, @invCode,@iQuantity,@iRate

	end

	close my_cursor
	deallocate my_cursor

	set nocount off
end
