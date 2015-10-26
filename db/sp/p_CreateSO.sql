SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
exec p_CreateSO 'JOB150100033'

select * from SO_SOMain where id>1000000051
select * from SO_SODetails where ID>1000000051
select ID,chdefine1,chdefine2,chdefine3 from SO_SOMain_extradefine where id>1000000051
select iSOsID,cbdefine1,cbdefine2,cbdefine3,cbdefine4 from SO_SODetails_extradefine where iSOsID in(select iSOsID from SO_SODetails where ID>1000000051)

delete SO_SOMain_extradefine where id>1000000051
delete from SO_SODetails_extradefine where iSOsID in(select iSOsID from SO_SODetails where ID>1000000051)
delete SO_SOMain where id>1000000051
delete SO_SODetails where ID>1000000051

*/
CREATE PROCEDURE [dbo].[p_CreateSO]  --  exec p_CreateSO 'JOB150100033'
	@DocNo varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	if exists(select top 1 1 from SO_SOMain where cSOCode=@DocNo+'_SP')
	begin
		select '已经生成对应士啤订单：'+@DocNo+'_SP,若有变更请手工修改该单据' as ReStr
		return
	end

	declare @P1 int      --主表ID  
	declare @P2 int      --子表iSOsID  
	declare @cAccID varchar(3)          --账套号，如：'001'等
	declare @InvCode varchar(50)--成品编码
	declare @SPCode varchar(50)--士啤编码
	declare @iQuantity decimal(16,4)
	declare @LineCount int
	declare @MinID int
	select @cAccID=left(right(DB_NAME(),8),3)  
	
	--订单头 和订单体
	select * into #SO_SOMain from SO_SOMain where cSOCode=@DocNo
	select * into #SO_SOMain_extradefine from SO_SOMain_extradefine where ID in(select ID from #SO_SOMain)
	select * into #SO_SODetails from SO_SODetails where ID in(select ID from #SO_SOMain)
	select * into #SO_SODetails_extradefine from SO_SODetails_extradefine where iSOsID in(select iSOsID from SO_SODetails where ID in(select ID from #SO_SOMain))

	--未设定士啤编码 抛错
	if exists(select top 1 1 from #SO_SODetails a left join Inventory_extradefine b on a.cInvCode=b.cInvCode where isnull(b.cidefine12,'')='')
	begin
		select top 1 '存货：'+a.cInvCode+'未设定士啤编码，请先于成品档案设定士啤编码' as ReStr
		from #SO_SODetails a left join Inventory_extradefine b on a.cInvCode=b.cInvCode where isnull(b.cidefine12,'')=''
		return
	end;
	--当前成品未设定士啤编码 抛错
	if exists(select top 1 1 from #SO_SODetails a inner join Inventory_extradefine b on a.cInvCode=b.cInvCode left join t_SOSP c on b.cidefine12=c.SPcode where isnull(c.SPcode,'')='')
	begin
		select top 1 '存货：'+a.cInvCode+'设定的士啤编码'+b.cidefine12+'不存在，请先于存货档案设定正确的士啤编码' as ReStr
		from #SO_SODetails a inner join Inventory_extradefine b on a.cInvCode=b.cInvCode left join t_SOSP c on b.cidefine12=c.SPcode where isnull(c.SPcode,'')=''
		return
	end;

	if ''='作废'
	begin
		----成品编码和士啤编码
		--select @InvCode=min(c.cInvCode),@SPCode=min(c.cInvDefine1),@iQuantity=sum(iQuantity),@MinID=min(AutoID)
		--from SO_SOMain a 
		--inner join SO_SODetails b on a.ID=b.ID and a.cSOCode=@DocNo 
		--inner join Inventory c on b.cInvCode=c.cInvCode
		----抛错
		--if isnull(@SPCode,'')=''
		--begin
		--	select '当前成品未设定士啤编码，请先于成品档案设定士啤编码'
		--	return
		--end;
		--if not exists(select top 1 1 from t_SOSP where SPcode=@SPCode)
		--begin
		--	select '通过当前成品的士啤编码'+@SPCode+'未能查找到对应士啤方案,请核实'
		--	return
		--end;
		----通过BOM和士啤方案组装行存货
		--select f.cInvCode,f.cInvName,g.ClassType,g.Qty,g.Proportion,d.BaseQtyN,d.BaseQtyD,f.cComUnitCode     --,case when g.ClassType='数量' then g.Qty else @iQuantity*(d.BaseQtyN/d.BaseQtyD)*g.Proportion end as Qty,f.cComUnitCode
		--into #b
		--from bas_part a 
		--inner join bom_parent b on b.parentid=a.PartId and a.InvCode=@InvCode
		--inner join bom_bom c on b.BomId=c.BomId
		--inner join Bom_opcomponent d on d.BomId=c.BomId
		--inner join bas_part e on d.ComponentId=e.PartID
		--inner join Inventory f on e.InvCode=f.cInvCode
		--inner join t_SOSPs g on g.SOSP=@SPCode and g.Class=left(f.cInvCode,3)
		----关联到订单行

		----行数
		--select @LineCount=count(*) from #b
		----获取主子表开始ID
		--exec sp_GetId N'00',@cAccID,N'Somain',@LineCount,@P1 output,@P2 output  
		--set @P2=@P2-@LineCount
		----编辑和插入主表
		--update #SO_SOMain set ID=@P1,cSOCode=cSOCode+'_SP',iStatus=0,dverifysystime=null,icreditstate=null,dverifydate=null,iverifystate=0,cVerifier=null,cCloser=null,bReturnFlag=0,bOrder=0,cChanger=null,cCreChpName=null,cLocker=null
		--insert into SO_SOMain select * from #SO_SOMain
		----编辑和插入子表
		--insert into SO_SODetails(cSOCode,cInvCode,dPreDate,iQuantity,iNum
		--	,iQuotedPrice,iUnitPrice,iTaxUnitPrice,iMoney,iTax,iSum,iDisCount,iNatUnitPrice,iNatMoney,iNatTax,iNatSum,iNatDisCount,iFHNum,iFHQuantity,iFHMoney,iKPQuantity,iKPNum,iKPMoney,bFH
		--	,iSOsID,KL,KL2,cInvName,iTaxRate--,iInvExchRate--转换率
		--	,cUnitID--计量单位Code 需计算
		--	,ID,FPurQuan,fSaleCost,fSalePrice,iQuoID,dPreMoDate,iRowNo
		--	,iMoQuantity,iPreKeepQuantity,iPreKeepNum,iPreKeepTotQuantity,iPreKeepTotNum
		--	--,dreleasedate释放日期 没有
		--	,fcusminprice,fimquantity,fomquantity,ballpurchase,finquantity,foutquantity,foutnum,iexchsum,imoneysum
		--	,fretquantity,fretnum,bOrderBOM,bOrderBOMOver,fPurSum,fPurBillQty,fPurBillSum,fVeriDispQty,fVeriDispSum,bgift
		--	--,cbSysBarCode--单据行条码
		--	)
		--select @DocNo+'_SP',a.cInvCode,b.dPreDate,a.Qty,a.Qty
		--	,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		--	,@P2+ROW_NUMBER() OVER(order by a.cInvCode),100,100,a.cInvName,0--,1
		--	,a.cComUnitCode--计量单位Code 需计算
		--	,@P1,0,0,0,0,b.dPreMoDate,ROW_NUMBER() OVER(order by a.cInvCode)
		--	,0,0,0,0,0
		--	--,null
		--	,0,0,0,0,0,0,0,0,0
		--	,0,0,0,0,0,0,0,0,0,0
		--	--,null--单据行条码
		--from #b a inner join SO_SODetails b on b.AutoID=@MinID

		return
	end;

	--通过BOM和士啤方案组装行存货
	--select f.cInvCode,f.cInvName,g.ClassType,g.Qty,g.Proportion,d.BaseQtyN,d.BaseQtyD,f.cComUnitCode     --,case when g.ClassType='数量' then g.Qty else @iQuantity*(d.BaseQtyN/d.BaseQtyD)*g.Proportion end as Qty,f.cComUnitCode
	select aa.AutoID,f.cInvCode,f.cInvName,g.ClassType,g.Qty,g.Proportion,d.BaseQtyN,d.BaseQtyD,f.cComUnitCode,aa.iSOsID as OldiSOsID,aa.iQuantity
		,cast(case when g.ClassType='数量' then g.Qty else g.Proportion*aa.iQuantity*d.BaseQtyN/d.BaseQtyD end as int) as NewiQuantity
	into #b
	from bas_part a inner join #SO_SODetails aa on a.InvCode=aa.cInvCode inner join Inventory_extradefine aaa on a.InvCode=aaa.cInvCode
	inner join bom_parent b on b.parentid=a.PartId
	inner join bom_bom c on b.BomId=c.BomId
	inner join Bom_opcomponent d on d.BomId=c.BomId
	inner join bas_part e on d.ComponentId=e.PartID
	inner join Inventory f on e.InvCode=f.cInvCode
	inner join t_SOSPs g on g.SOSP=aaa.cidefine12 and g.Class=left(f.cInvCode,3)

	--行数
	select @LineCount=count(*) from #b
	--获取主子表开始ID
	exec sp_GetId N'00',@cAccID,N'Somain',@LineCount,@P1 output,@P2 output  
	set @P2=@P2-@LineCount
	select *,@P2+ROW_NUMBER() OVER(order by cInvCode) as NewiSOsID into #bb from #b
	--编辑和插入主表
	update #SO_SOMain set ID=@P1,cSOCode=cSOCode+'_SP',iStatus=0,dverifysystime=null,icreditstate=null,dverifydate=null,iverifystate=0,cVerifier=null,cCloser=null,bReturnFlag=0,bOrder=0,cChanger=null,cCreChpName=null,cLocker=null,cSysBarCode=cSysBarCode+'_SP'
	update #SO_SOMain_extradefine set ID=@P1
	insert into SO_SOMain(cSTCode,dDate,cSOCode,cCusCode,cDepCode,cPersonCode,cSCCode,cCusOAddress,cPayCode,cexch_name,iExchRate,iTaxRate,iMoney,cMemo,iStatus,cMaker,cVerifier,cCloser,bDisFlag,cDefine1,cDefine2,cDefine3,cDefine4,cDefine5,cDefine6,cDefine7,cDefine8,cDefine9,cDefine10,bReturnFlag,cCusName,bOrder,ID,iVTid,cChanger,cBusType,cCreChpName,cDefine11,cDefine12,cDefine13,cDefine14,cDefine15,cDefine16,coppcode,cLocker,dPreMoDateBT,dPreDateBT,cgatheringplan,caddcode,iverifystate,ireturncount,iswfcontrolled,icreditstate,cmodifier,dmoddate,dverifydate,ccusperson,dcreatesystime,dverifysystime,dmodifysystime,iflowid,bcashsale,cgathingcode,cChangeVerifier,dChangeVerifyDate,dChangeVerifyTime,outid,ccuspersoncode,dclosedate,dclosesystime,iPrintCount,fbookratio,bmustbook,fbooksum,fbooknatsum,fgbooksum,fgbooknatsum,csvouchtype,cCrmPersonCode,cCrmPersonName,cMainPersonCode,cSysBarCode,ioppid,optnty_name,cCurrentAuditor,contract_status,csscode,cinvoicecompany,cAttachment) 
	select cSTCode,dDate,cSOCode,cCusCode,cDepCode,cPersonCode,cSCCode,cCusOAddress,cPayCode,cexch_name,iExchRate,iTaxRate,iMoney,cMemo,iStatus,cMaker,cVerifier,cCloser,bDisFlag,cDefine1,cDefine2,cDefine3,cDefine4,cDefine5,cDefine6,cDefine7,cDefine8,cDefine9,cDefine10,bReturnFlag,cCusName,bOrder,ID,iVTid,cChanger,cBusType,cCreChpName,cDefine11,cDefine12,cDefine13,cDefine14,cDefine15,cDefine16,coppcode,cLocker,dPreMoDateBT,dPreDateBT,cgatheringplan,caddcode,iverifystate,ireturncount,iswfcontrolled,icreditstate,cmodifier,dmoddate,dverifydate,ccusperson,dcreatesystime,dverifysystime,dmodifysystime,iflowid,bcashsale,cgathingcode,cChangeVerifier,dChangeVerifyDate,dChangeVerifyTime,outid,ccuspersoncode,dclosedate,dclosesystime,iPrintCount,fbookratio,bmustbook,fbooksum,fbooknatsum,fgbooksum,fgbooknatsum,csvouchtype,cCrmPersonCode,cCrmPersonName,cMainPersonCode,cSysBarCode,ioppid,optnty_name,cCurrentAuditor,contract_status,csscode,cinvoicecompany,cAttachment from #SO_SOMain
	insert into SO_SOMain_extradefine select * from #SO_SOMain_extradefine
	--编辑和插入子表    select * from SO_SODetails
	insert into SO_SODetails(cSOCode,cInvCode,dPreDate,iQuantity,iNum
		,iQuotedPrice,iUnitPrice,iTaxUnitPrice,iMoney,iTax,iSum,iDisCount,iNatUnitPrice,iNatMoney,iNatTax,iNatSum,iNatDisCount,iFHNum,iFHQuantity,iFHMoney,iKPQuantity,iKPNum,iKPMoney,bFH
		,iSOsID,KL,KL2,cInvName,iTaxRate--,iInvExchRate--转换率
		,cUnitID--计量单位Code 需计算
		,ID,FPurQuan,fSaleCost,fSalePrice,iQuoID,dPreMoDate,iRowNo
		,iMoQuantity,iPreKeepQuantity,iPreKeepNum,iPreKeepTotQuantity,iPreKeepTotNum
		--,dreleasedate释放日期 没有
		,fcusminprice,fimquantity,fomquantity,ballpurchase,finquantity,foutquantity,foutnum,iexchsum,imoneysum
		,fretquantity,fretnum,bOrderBOM,bOrderBOMOver,fPurSum,fPurBillQty,fPurBillSum,fVeriDispQty,fVeriDispSum,bgift
		--,cbSysBarCode--单据行条码
		,cDefine22,cDefine23,cDefine24,cDefine25,cDefine26,cDefine27,cDefine28,cDefine29,cDefine30,cDefine31,cDefine32,cDefine33,cDefine34,cDefine35,cDefine36,cDefine37
		)
	select @DocNo+'_SP',a.cInvCode,b.dPreDate,NewiQuantity,null
		,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		--,@P2+ROW_NUMBER() OVER(order by a.cInvCode),100,100,a.cInvName,0--,1
		,a.NewiSOsID,100,100,a.cInvName,0--,1
		,a.cComUnitCode--计量单位Code 需计算
		,@P1,0,0,0,0,b.dPreMoDate,ROW_NUMBER() OVER(order by a.cInvCode)
		,0,0,0,0,0
		--,null
		,0,0,0,0,0,0,0,0,0
		,0,0,0,0,0,0,0,0,0,0
		--,null--单据行条码
		,cDefine22,cDefine23,cDefine24,cDefine25,cDefine26,cDefine27,cDefine28,cDefine29,cDefine30,cDefine31,cDefine32,cDefine33,cDefine34,cDefine35,cDefine36,cDefine37
	from #bb a inner join SO_SODetails b on b.AutoID=a.AutoID

	insert into #SO_SODetails_extradefine(iSOsID,cbdefine1,cbdefine2,cbdefine3,cbdefine4)
	select b.NewiSOsID,cbdefine1,cbdefine2,cbdefine3,cbdefine4 from #SO_SODetails_extradefine a inner join #bb b on a.iSOsID=b.OldiSOsID

	select '生单完成，单号:'+@DocNo+'_SP' as ReStr

	--select ID from SO_SOMain where cSOCode='0000000225'
	--select cInvCode,cUnitID from SO_SODetails where ID=1000000245
	--select cComUnitCode  from Inventory where cInvCode='010204'


	
END

GO


