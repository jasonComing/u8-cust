create trigger tri_AutoFillPodata
/*
功能：采购员批理生单时，自动补上表头相关必填项，
		（部门、业务员、付款条件、质量等级-A，建档作废标记－否）
		表身补士啤行、赠品－否，不参加MRP运算

作者：Jams
*/
on PO_Podetails
   after insert
as
begin
	set nocount on

	declare @PoNO varchar(30)			--PO订单号
	declare @poid bigint
	declare @makerCode varchar(30)　	--制单人工号
	declare @makerName varchar(50)　	--制单人姓名
	declare @PersonCode varchar(30)	--业务员代码

	declare @DepCode varchar(30)		--部门代码

	declare @rowcount int				--表体需要加载士啤的行数
	declare @MaxRowNum int				--表体最大行号


	--取出PO订单号
	select top 1 @PoNO =isnull(PO_Pomain.cPOID,null) from inserted
	left join PO_Pomain on PO_Pomain.POID=inserted.POID

	if not exists(select * from PO_Pomain where cPOID =@PoNO )
		return

	--取出poid/制单人
	select  @poid =POID,@makerName=cMaker  from  PO_Pomain  where cPOID =@PoNO

	select top 1 @PersonCode= p.[cPersonCode],@DepCode=p.[cDepCode]
	from  [Person] as p
	left join [Department] as d on  d.[cDepCode] = p.[cDepCode]
	where  p.cPersonName=@makerName

	--＝＝以下变更表头信息＝＝＝＝
	update PO_POMain
	set cPTCode ='01'
	from  PO_POMain
	where PO_POMain.cPTCode is null
	and  cPOID=@PoNO

	update PO_POMain
	set cdefine1 = 'A'
	from  PO_POMain
	where PO_POMain.cdefine1 is null
	and  cPOID=@PoNO

	update PO_POMain
	set cPayCode = '01'
	from  PO_POMain
	where PO_POMain.cPayCode is null
	and  cPOID=@PoNO


	update PO_POMain
	set cDepCode =isnull(@DepCode,null)
	from  PO_POMain
	where PO_POMain.cDepCode is null
	and  cPOID=@PoNO

	update PO_POMain
	set cPersonCode = isnull(@PersonCode,null)
	from  PO_POMain
	where PO_POMain.cPersonCode is null
	and  cPOID=@PoNO


	--表头扩展项
	update PO_POMain_ExtraDefine
	set chdefine19 = '否'
	from PO_POMain_ExtraDefine
	where PO_POMain_ExtraDefine.chdefine19 is null
	and POID=@poid


	--＝＝＝＝以下为表体更新　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

	--取出表体需要加载士啤的行数

	select @rowcount =count(*) from inserted
	where poid=@poid　
	and bgift=0

	select @MaxRowNum =max(ivouchrowno) from inserted

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
			select inserted.ID,inserted.cInvCode,inserted.iQuantity,isnull(Inventory.cInvDefine13,0.0) as iRate from inserted
			left join Inventory  on inserted.cinvCode=Inventory.cinvCode
			where poid=@poid
			and bgift=0
			order by inserted.ivouchrowno

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

			select @iChildID - @rowcount + @irowx,cpoid,cinvcode,@iQuantity * @iRate ,inum,iquotedprice,0,0,itax,0,idiscount,0,
				0,0,0,inatdiscount,darrivedate,cfree1,cfree2,ipertaxrate,cdefine22,cdefine23,
				cdefine24,cdefine25,cdefine26,cdefine27,iflag,citemcode,citem_class,ppcids,citemname,cfree3,cfree4,cfree5,
				cfree6,cfree7,cfree8,cfree9,cfree10,bgsp,poid,cunitid,0,iappids,cdefine28,cdefine29,'false',
				cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,isosid,btaxcost,csource,cbcloser,ippartid,
				ipquantity,iptoseq,sotype,sodid,contractrowguid,cupsocode,iinvmpcost,contractcode,contractrowno,fporefusequantity,
				fporefusenum,iorderdid,iordertype,csoordercode,iorderseq,cbclosetime,cbclosedate,cbg_itemcode,cbg_itemname,
				cbg_caliberkey1,cbg_caliberkeyname1,cbg_caliberkey2,cbg_caliberkeyname2,cbg_caliberkey3,cbg_caliberkeyname3,
				cbg_calibercode1,cbg_calibername1,cbg_calibercode2,cbg_calibername2,cbg_calibercode3,cbg_calibername3,ibg_ctrl,
				cbg_auditopinion,fexquantity,fexnum, @MaxRowNum+999+ @irowx ,cbg_caliberkey4,cbg_caliberkeyname4,cbg_caliberkey5,cbg_caliberkeyname5,
				cbg_caliberkey6,cbg_caliberkeyname6,cbg_calibercode4,cbg_calibername4,cbg_calibercode5,cbg_calibername5,
				cbg_calibercode6,cbg_calibername6,csocode,irowno,cxjspdids,cbmemo,planlotnumber,1,'||pupo|'+@PoNO+'|'+ cast( @MaxRowNum+999+@irowx as varchar)
			from 	PO_PODetails where id=@bodyID

		 --Values(1000054570,N'PO16060155',N'601_000004',480,0,NULL,1,480,0,480,NULL,1,480,0,480,NULL,'2016-08-03',
		 --NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1009500624,NULL,NULL,NULL,NULL,NULL,NULL,
		 --NULL,NULL,NULL,0,1000021150,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		 --0,N'mrp',NULL,NULL,NULL,NULL,5,N'J160402690',NULL,N'GEN018176680',15.485,NULL,NULL,NULL,NULL,NULL,
		 --0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		 --NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'J160402690',
		 --NULL,NULL,NULL,NULL,NULL,0)

		-- 插入扩展表

		 Insert Into PO_PODetails_ExtraDefine(id,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,
			  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,
			  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39)

	　	 select @iChildID - @rowcount + @irowx ,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine9,cbdefine11,
			  cbdefine12,cbdefine15,cbdefine18,cbdefine19,cbdefine20,cbdefine21,cbdefine23,
			  cbdefine24,cbdefine25,cbdefine29,cbdefine32,cbdefine35,cbdefine39
		 from PO_PODetails_ExtraDefine
		 where id=@bodyID

		--Values (1000054570,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		--NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
		set @irowx=@irowx+1

		fetch next from my_cursor into @bodyID, @invCode,@iQuantity,@iRate

	end

	close my_cursor
	deallocate my_cursor

	set nocount off
end