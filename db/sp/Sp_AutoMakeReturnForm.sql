/*

從SQL Profiler取得的SQL, 001 拒收單: AP16033322


-- 新增拒收單表頭 (1000016913)
if not exists (select ccode from PU_ArrivalVouch where id=N'1000016913')
Insert Into PU_ArrivalVouch(ivtid,id,ccode,cptcode,ddate,cvencode,cdepcode,cpersoncode,cpaycode,csccode,cexch_name,iexchrate,itaxrate,cmemo,cbustype,cmaker,bnegative,cdefine1,cdefine2,cdefine3,cdefine4,cdefine5,cdefine6,cdefine7,cdefine8,cdefine9,cdefine1


0,cdefine11,cdefine12,cdefine13,cdefine14,cdefine15,cdefine16,ccloser,idiscounttaxtype,ibilltype,cvouchtype,cgeneralordercode,ctmcode,cincotermcode,ctransordercode,dportdate,csportcode,caportcode,csvencode,carrivalplace,dclosedate,idec,bcal,guid,iverifyst


ate,cauditdate,cverifier,iverifystateex,ireturncount,iswfcontrolled,cvenpuomprotocol,cchanger,iflowid,ccleanver,cpocode,csysbarcode,ccurrentauditor) Values (8169,1000016913,N'AP16033322',N'01','2016-03-10',N'245',N'34',NULL,N'01',NULL,N'港币',1,0,N'所有材质跟做开大


货，物料全部交物流部仓!',N'普通采购',N'Jason Ching',1,N'AAA',N' ST151107/1108',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NUL


L,NULL,NULL,NULL)

Insert Into PU_ArrivalVouch_ExtraDefine(id,chdefine3,chdefine11,chdefine13,chdefine16,chdefine19,chdefine23) Values (1000016913,NULL,NULL,NULL,NULL,NULL,NULL)

-- 更新到貨單表體 (1000035068)
UPDATE Pu_ArrivalVouchs 
SET Pu_ArrivalVouchs.fsumrefusequantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))+ABS(CONVERT(DECIMAL(20,7),-12)), Pu_ArrivalVouchs.frefusequantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))+ABS(CONVERT


(DECIMAL(20,7),-12)), Pu_ArrivalVouchs.fValidQuantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iQuantity,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))-ABS(CONVERT(DECIMAL(20,7),-12)), Pu_ArrivalVouchs.fRealQuantity=CONVERT(


DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iQuantity,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))-ABS(CONVERT(DECIMAL(20,7),-12)), Pu_ArrivalVouchs.fsumrefusenum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+ABS(CO


NVERT(DECIMAL(20,7),-.012)), Pu_ArrivalVouchs.fRefuseNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+ABS(CONVERT(DECIMAL(20,7),-.012)), Pu_ArrivalVouchs.fValidNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iNum,0))-CONVERT(DECIMAL(2


0,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-ABS(CONVERT(DECIMAL(20,7),-.012)), Pu_ArrivalVouchs.fRealnum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.inum,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-ABS(CONVERT(DECIMAL(20,7),-.


012)) 
WHERE Pu_ArrivalVouchs.autoid=1000035068

-- 更新到貨單表體
UPDATE Pu_ArrivalVouchs 
set fRefuseNum=frefusequantity/Unit1.ichangrate,fsumrefusenum=fsumrefusequantity/Unit1.ichangrate,fValidNum=fValidQuantity/Unit1.ichangrate,fRealnum=fRealQuantity/Unit1.ichangrate 
from Pu_ArrivalVouchs  
LEFT JOIN Inventory ON Pu_ArrivalVouchs.cInvCode = Inventory.cInvCode 
LEFT JOIN ComputationUnit as Unit1 on Pu_ArrivalVouchs.cunitid=Unit1.cComUnitCode 
Where IsNull(Inventory.igrouptype, 0) = 1 And Pu_ArrivalVouchs.autoid=1000035068

-- 更新採購單表體
UPDATE Po_Podetails 
SET Po_Podetails.iArrQTY=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.iArrQTY,0))- ABS( CONVERT(DECIMAL(20,7),-12)),Po_Podetails.iArrNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.iArrNum,0))-ABS(CONVERT(DECIMAL(20,7),-.012)), Po_Podetails.fPoValidQuantity=CO


NVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoValidQuantity,0))-ABS(CONVERT(DECIMAL(20,7),-12)),Po_Podetails.fPoValidNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoValidNum,0))-ABS(CONVERT(DECIMAL(20,7),-.012)), Po_Podetails.fPoRefuseQuantity=CONVERT(DECIM


AL(20,7),ISNULL(Po_Podetails.fPoRefuseQuantity,0))+ABS(CONVERT(DECIMAL(20,7),-12)),Po_Podetails.fPoRefuseNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoRefuseNum,0))+ABS(CONVERT(DECIMAL(20,7),-.012)), Po_Podetails.iArrMoney=ISNULL(Po_Podetails.iArrMoney


,0)-ABS((-4.2)), Po_Podetails.iNatArrMoney=ISNULL(Po_Podetails.iNatArrMoney,0)-ABS((-4.2)) 
from Po_Podetails 
inner join Pu_ArrivalVouchs on Po_Podetails.id=Pu_ArrivalVouchs.iposid  
WHERE Pu_ArrivalVouchs.autoid=1000035068

-- 更新到貨單表頭, 這是否需要?
update Pu_ArrivalVouch 
set ddate=ddate 
from Pu_ArrivalVouch 
inner join Pu_ArrivalVouchs on Pu_ArrivalVouch.id=Pu_ArrivalVouchs.id 
WHERE Pu_ArrivalVouchs.autoid=1000035068

-- 新增拒收單表體 (1000035434)
Insert Into 
PU_ArrivalVouchs(autoid,id,cwhcode,cinvcode,inum,iquantity,ioricost,ioritaxcost,iorimoney,ioritaxprice,iorisum,icost,imoney,itaxprice,isum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,itaxrate,cdefine22,cdefine23,cdefine24,cdefin


e25,cdefine26,cdefine27,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,citem_class,citemcode,iposid,citemname,cunitid,fkpquantity,frealquantity,fvalidquantity,finvalidquantity,ccloser,icorid,bgsp,cbatch


,dvdate,dpdate,frefusequantity,cgspstate,fvalidnum,finvalidnum,frealnum,btaxcost,binspect,frefusenum,ippartid,ipquantity,iptoseq,sodid,sotype,contractrowguid,imassdate,cmassunit,bexigency,cbcloser,fdtquantity,finvalidinnum,fdegradequantity,fdegradenum,fde


gradeinquantity,fdegradeinnum,finspectquantity,finspectnum,iinvmpcost,guids,iinvexchrate,objectid_source,autoid_source,ufts_source,irowno_source,csocode,isorowno,iorderid,cordercode,iorderrowno,dlineclosedate,contractcode,contractrowno,rejectsource,iciqbo


okid,cciqbookcode,cciqcode,fciqchangrate,irejectautoid,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cupsocode,iorderdid,iordertype,csoordercode,iorderseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,


cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,ivouchrowno,irowno,cbmemo,cbsysbarcode,carrivalcode,ipickedquantity,ipickednum,isourcemocode,isourcemodetailsid,freworkquantity,freworknum,fsumreworkquantity,fsumreworknum,iproducttype,cmain


invcode,imainmodetailsid,planlotnumber,bgift) 
Values (1000035434,1000016913,N'12',N'804_000025',-.012,-12,.35,.35,-4.2,0,-4.2,.35,-4.2,0,-4.2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1000005823,NULL,N


'202',NULL,NULL,NULL,NULL,NULL,1000035068,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N' PO15107968',NULL,NULL,


NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,N'AP16030099',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0)

Insert Into PU_ArrivalVouchs_ExtraDefine(autoid,cbdefine3,cbdefine4,cbdefine1,cbdefine2,cbdefine8,cbdefine9,cbdefine11,cbdefine15,cbdefine18,cbdefine21,cbdefine23) Values (1000035434,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

*/


CREATE  proc [dbo].[sp_AutoMakeReturnForm]
/*
功能：依采购入库单上的拒收数量，
		自动开到货拒收单据，单据号
		形如：AP16013293_RT
调用：在采购入单保存新增时，自动触发执行
		exec sp_AutoMakeReturnForm 'WPI16030731',1
作者：jams
*/
@formNO varchar(30), --採購入庫單號
@debug int=0 --是1否0测试
as 
begin
	Set nocount on
	declare @ArvCode varchar(30)	--到貨單號
	declare @ArvRowid varchar(30)	--到货单表身记录行标记号
	declare @irowcount int			--拒收数量>0的的总行数
	declare @ifatherid int			--主表main表ID
	declare @ichild int				--子表details的行标记号
	declare @ReturnNUM int			--拒收数量

	select d.cbarvcode, d.iArrsId, e.cbdefine26
	into #tb
	from rdrecord01 m
	join rdrecords01 d on d.id = m.id
	join rdrecords01_ExtraDefine e on e.autoid = d.autoid
	where e.cbdefine26 is not null
	and cCode = isnull(@formNO, cCode)
	and not exists (select 1 from PU_ArrivalVouch innerM where innerM.cCode = d.cbarvcode + '_RT')

	if @debug > 0
	begin
		select  '#tb', *
		from #tb
	end
	
	--Loop by each Voucher
	declare my_cursor cursor for
		select distinct(cbarvcode), count(*)
		from #tb
		group by cbarvcode
	open my_cursor
	fetch next from my_cursor into @ArvCode, @irowcount	--记录每张到货单有几行拒收？
	while @@FETCH_STATUS = 0 
	begin

		-- Get the ID
		exec sp_GetId '','004','PuArrival',@irowcount,@ifatherid output,@ichild output,default
		
		select 'Id', @irowcount as count, @ifatherid as father, @ichild as child   
	
		insert into PU_ArrivalVouch([iVTid],[ID],[cCode],[cPTCode],[dDate],[cVenCode],[cDepCode],[cPersonCode],
			[cPayCode],[cexch_name],[iExchRate],[iTaxRate],[cMemo],[cBusType],[cMaker],[bNegative],[cDefine1],
			[cDefine10],[iDiscountTaxType],[iBillType],[cMakeTime],[cAuditDate],[caudittime],[cverifier],
			[iverifystateex],[ireturncount],[IsWfControlled],[cVenPUOMProtocol],[cchanger],[iflowid],
			[iPrintCount],[ccleanver],[cpocode],[csysbarcode])
		select 
		8169, 
		@ifatherid,
		@ArvCode+'_RT',
		[cPTCode]
		,CONVERT(date, getdate()) -- dDate
		,[cVenCode]
		,[cDepCode],[cPersonCode],[cPayCode],[cexch_name],[iExchRate],[iTaxRate]
		,[cMemo]
		,[cBusType]
		,'system' --cMaker
		,1 --bNegative
		,[cDefine1]
		,[cDefine10]
		,[iDiscountTaxType]
		,2 --iBillType
		,CONVERT(varchar(100), GETDATE(), 25) --[cMakeTime]
		,CONVERT(varchar(100), GETDATE(), 23)--[cAuditDate]审核日期
		,CONVERT(varchar(100), GETDATE(), 25)--[caudittime]审核时间
		,'system'   --[cverifier] 审核人
		,2 --iverifystateex   工作审批状态 0未审，2已审   －--Set cAuditTime = GetDate(),cAuditDate = N'2016-03-12',cVerifier=N'黄作战',iverifystateex='2'											
		,[ireturncount]
		,[IsWfControlled]
		,[cVenPUOMProtocol]
		,[cchanger]
		,0 ----[iflowid]--流程ID
		,[iPrintCount]
		,[ccleanver]
		,null   --[cpocode]  采购订单号
		,'||pujs|'+@ArvCode+'_RT' --csysbarcode
		from PU_ArrivalVouch
		where cCode = @ArvCode

		--表头扩展表   
		Insert Into PU_ArrivalVouch_ExtraDefine(id) Values (@ifatherid)
		
		declare @rowcount int
		set @rowcount = 1
		-- Insert into detail table
		declare detail_cursor cursor for
			select iArrsId, cbdefine26
			from #tb
			where cbarvcode = @ArvCode

		open detail_cursor
		fetch next from detail_cursor into @ArvRowid, @ReturnNUM
		while @@FETCH_STATUS = 0 
		begin
		
			declare @detailQuantity decimal(20, 7)
			declare @detailNum decimal(20, 7)
			
			set @detailQuantity = ABS(CONVERT(DECIMAL(20,7),-@ReturnNUM))
			--set @detailNum = ABS(CONVERT(DECIMAL(20, 7), -@ReturnNUM) / CONVERT(DECIMAL(20, 7), 1000))  
			set @detailNum =0  

			-- 更新到貨單表體
			UPDATE Pu_ArrivalVouchs
			SET Pu_ArrivalVouchs.fsumrefusequantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))+@detailQuantity,  
				Pu_ArrivalVouchs.frefusequantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))+@detailQuantity,
				Pu_ArrivalVouchs.fValidQuantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iQuantity,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))-@detailQuantity,
				Pu_ArrivalVouchs.fRealQuantity=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iQuantity,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusequantity,0))-@detailQuantity,
				--Pu_ArrivalVouchs.fsumrefusenum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+@detailNum,    --已拒收件数 
				--Pu_ArrivalVouchs.fRefuseNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+@detailNum,      --拒收件数 
				--Pu_ArrivalVouchs.fValidNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iNum,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-@detailNum,
				--Pu_ArrivalVouchs.fRealnum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.inum,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-@detailNum 
				Pu_ArrivalVouchs.fsumrefusenum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+ABS(CONVERT(DECIMAL(20,7),0)),
				Pu_ArrivalVouchs.fRefuseNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))+ABS(CONVERT(DECIMAL(20,7),0)), 
				Pu_ArrivalVouchs.fValidNum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.iNum,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-ABS(CONVERT(DECIMAL(20,7),0)), 
				Pu_ArrivalVouchs.fRealnum=CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.inum,0))-CONVERT(DECIMAL(20,7),ISNULL(Pu_ArrivalVouchs.fsumrefusenum,0))-ABS(CONVERT(DECIMAL(20,7),0))
			WHERE Pu_ArrivalVouchs.autoid=@ArvRowid
			
			-- 更新到貨單表體
			UPDATE Pu_ArrivalVouchs 
			set fRefuseNum=frefusequantity/Unit1.ichangrate,
				fsumrefusenum=fsumrefusequantity/Unit1.ichangrate,
				fValidNum=fValidQuantity/Unit1.ichangrate,
				fRealnum=fRealQuantity/Unit1.ichangrate 
			from Pu_ArrivalVouchs  
			LEFT JOIN Inventory ON Pu_ArrivalVouchs.cInvCode = Inventory.cInvCode 
			LEFT JOIN ComputationUnit as Unit1 on Pu_ArrivalVouchs.cunitid=Unit1.cComUnitCode 
			Where IsNull(Inventory.igrouptype, 0) = 1 And Pu_ArrivalVouchs.autoid=@ArvRowid
		
			-- 更新採購單表體
			UPDATE Po_Podetails 
			SET Po_Podetails.iArrQTY=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.iArrQTY,0))- @detailQuantity,
				Po_Podetails.iArrNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.iArrNum,0))-@detailNum,
				Po_Podetails.fPoValidQuantity=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoValidQuantity,0))-@detailQuantity,
				Po_Podetails.fPoValidNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoValidNum,0))-@detailNum,
				Po_Podetails.fPoRefuseQuantity=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoRefuseQuantity,0))+@detailQuantity,
				Po_Podetails.fPoRefuseNum=CONVERT(DECIMAL(20,7),ISNULL(Po_Podetails.fPoRefuseNum,0))+@detailNum,
				Po_Podetails.iArrMoney=ISNULL(Po_Podetails.iArrMoney,0)-ABS((Po_Podetails.iUnitPrice * @ReturnNUM)),  --<<<<<<<<<<<<<<<<<<< where does this 4.2 come from???
				Po_Podetails.iNatArrMoney=ISNULL(Po_Podetails.iNatArrMoney,0)-ABS((Po_Podetails.iNatUnitPrice * @ReturnNUM))   --<<<<<<<<<<<<<<<<<<<< where does this 4.2 come from???
			from Po_Podetails 
			inner join Pu_ArrivalVouchs on Po_Podetails.id=Pu_ArrivalVouchs.iposid  
			WHERE Pu_ArrivalVouchs.autoid=@ArvRowid

			update Pu_ArrivalVouch 
				set ddate=ddate 
			from Pu_ArrivalVouch 
			inner join Pu_ArrivalVouchs on Pu_ArrivalVouch.id=Pu_ArrivalVouchs.id 
			WHERE Pu_ArrivalVouchs.autoid=@ArvRowid

			--插入拒收单表身
			insert into PU_ArrivalVouchs([Autoid],[ID],[cWhCode],[cInvCode],[iNum],
					[iQuantity],[iOriCost],[iOriTaxCost],[iOriMoney],[iOriTaxPrice],
					[iOriSum],[iCost],[iMoney],[iTaxPrice],[iSum],
					[cFree1],[cFree2],[cFree3],[cFree4],[cFree5],
					[cFree6],[cFree7],[cFree8],[cFree9],[cFree10],
					[iTaxRate],[cDefine22],[cDefine23],[cDefine24],[cDefine25],
					[cDefine26],[cDefine27],[cDefine28],[cDefine29],[cDefine30],
					[cDefine31],[cDefine32],[cDefine33],[cDefine34],[cDefine35],
					[cDefine36],[cDefine37],[cItem_class],[cItemCode],[iPOsID],
					[cItemName],[cUnitID],[fValidInQuan],[fKPQuantity],[fRealQuantity],
					[fValidQuantity],[finValidQuantity],[cCloser],[iCorId],[fRetQuantity],
					[fInValidInQuan],[bGsp],[cBatch],[dVDate],[dPDate],
					[fRefuseQuantity],[cGspState],[fValidNum],[fValidInNum],[fInValidNum],
					[fRealNum],[bTaxCost],[bInspect],[fRefuseNum],[iPPartId],
					[iPQuantity],[iPTOSeq],[SoDId],[SoType],[ContractRowGUID],
					[imassdate],[cmassunit],[bexigency],[cbcloser],[fSumRefuseQuantity],
					[FSumRefuseNum],[fRetNum],[fDTQuantity],[fInvalidInNum],[fDegradeQuantity],
					[fDegradeNum],[fDegradeInQuantity],[fDegradeInNum],[fInspectQuantity],[fInspectNum],
					[iInvMPCost],[guids],[iinvexchrate],[objectid_source],[autoid_source],
					[ufts_source],[irowno_source],[csocode],[isorowno],[iorderid],
					[cordercode],[iorderrowno],[dlineclosedate],[ContractCode],[ContractRowNo],
					[RejectSource],[iciqbookid],[cciqbookcode],[cciqcode],[fciqchangrate],
					[irejectautoid],[iExpiratDateCalcu],[cExpirationdate],[dExpirationdate],[cupsocode],
					[iorderdid],[iordertype],[csoordercode],[iorderseq],[cBatchProperty1],
					[cBatchProperty2],[cBatchProperty3],[cBatchProperty4],[cBatchProperty5],
					[cBatchProperty6],[cBatchProperty7],[cBatchProperty8],[cBatchProperty9],[cBatchProperty10],
					[ivouchrowno],[irowno],[cbMemo],[cbsysbarcode],[carrivalcode],[ipickedquantity],
					[ipickednum],[iSourceMOCode],[iSourceMODetailsID],[freworkquantity],[freworknum],
					[fsumreworkquantity],[fsumreworknum],[iProductType],[cMainInvCode],[iMainMoDetailsID],[PlanLotNumber],[bgift]) 
			select @ichild -@irowcount +@rowcount  --AutoId
           ,@ifatherid --ID
           ,[cWhCode]
           ,[cInvCode]
           ,0 --iNum
           ,-@ReturnNUM --iQuantity
           ,[iOriCost]
           ,[iOriTaxCost]
           ,-@ReturnNUM * iOriCost --iOriMoney
           ,[iOriTaxPrice]
           ,-@ReturnNUM * iOriCost --iOriSum
           ,[iCost]
           ,-@ReturnNUM * iOriCost --iMoney
           ,0	-- [iTaxPrice]    
           ,-@ReturnNUM * iOriCost --iSum
           ,[cFree1]
           ,[cFree2]
           ,[cFree3]
           ,[cFree4]
           ,[cFree5]
           ,[cFree6]
           ,[cFree7]
           ,[cFree8]
           ,[cFree9]
           ,[cFree10]
           ,[iTaxRate]
           ,[cDefine22]
           ,[cDefine23]
           ,[cDefine24]
           ,[cDefine25]
           ,null -- [cDefine26]  --拒收数量
           ,[cDefine27]
           ,[cDefine28]
           ,[cDefine29]
           ,[cDefine30]
           ,[cDefine31]
           ,[cDefine32]
           ,[cDefine33]
           ,[cDefine34]
           ,[cDefine35]
           ,[cDefine36]
           ,[cDefine37]
           ,[cItem_class]
           ,[cItemCode]
           ,[iPOsID]
           ,[cItemName]
           ,[cUnitID]
           ,0 --fValidInQuan
           ,[fKPQuantity]
           ,null  --fRealQuantity
           ,null  --fValidQuantity
           ,null  --finValidQuantity
           ,[cCloser]
           ,@ArvRowid --iCorId
           ,0 --fRetQuantity
           ,[fInValidInQuan]
           ,0  --[bGsp] 是否质检
           ,[cBatch]
           ,[dVDate]
           ,[dPDate]
           ,null --[fRefuseQuantity] --拒收数量
           ,[cGspState]
           ,null  --  [fValidNum]
           ,null  ---[fValidInNum]
           ,null	--[fInValidNum]
           ,null  ---[fRealNum]
           ,0  --[bTaxCost]价格标准
           ,[bInspect]
           ,null ---[fRefuseNum]
           ,[iPPartId]
           ,[iPQuantity]
           ,[iPTOSeq]
           ,[SoDId]
           ,[SoType]
           ,[ContractRowGUID]
           ,[imassdate]
           ,[cmassunit]
           ,0 ---[bexigency] 是否紧急物料
           ,[cbcloser]
           ,null  ---[fSumRefuseQuantity]
           ,null  ---[FSumRefuseNum]
           ,[fRetNum]
           ,[fDTQuantity]
           ,null  ---[fInvalidInNum]
           ,[fDegradeQuantity]
           ,[fDegradeNum]
           ,[fDegradeInQuantity]
           ,[fDegradeInNum]
           ,[fInspectQuantity]
           ,[fInspectNum]
           ,[iInvMPCost]
           ,[guids]
           ,0.0 ----[iinvexchrate] 换算率  
           ,[objectid_source]
           ,[autoid_source]
           ,[ufts_source]
           ,[irowno_source]
           ,[csocode]		--job订单号
           ,[isorowno]
           ,[iorderid]
           ,[cordercode]   --采购订单号
           ,[iorderrowno]
           ,[dlineclosedate]
           ,[ContractCode]
           ,[ContractRowNo]
           ,0    --[RejectSource]  --拒收来源
           ,[iciqbookid]
           ,[cciqbookcode]
           ,[cciqcode]
           ,[fciqchangrate]
           ,[irejectautoid]
           ,0 ---[iExpiratDateCalcu]  有效期推断方式 
           ,[cExpirationdate]
           ,[dExpirationdate]
           ,[cupsocode]
           ,[iorderdid]
           ,[iordertype]  --销售订单类型 
           ,[csoordercode]
           ,[iorderseq]
           ,[cBatchProperty1]
           ,[cBatchProperty2]
         ,[cBatchProperty3]
           ,[cBatchProperty4]
           ,[cBatchProperty5]
           ,[cBatchProperty6]
           ,[cBatchProperty7]
           ,[cBatchProperty8]
           ,[cBatchProperty9]
           ,[cBatchProperty10]
           ,@rowcount --ivouchrowno 单据行号 
           ,[irowno] 
           ,null --cbMemo
           ,'||pujs|' + @ArvCode + '_RT' + '|' + cast(ivouchrowno as varchar(2)) --cbsysbarcode 系统条码
           ,@ArvCode   ---carrivalcode   -- 到货单号
           ,[ipickedquantity]
           ,[ipickednum]
           ,[iSourceMOCode]
           ,[iSourceMODetailsID]
           ,[freworkquantity]
           ,[freworknum]
           ,[fsumreworkquantity]
           ,[fsumreworknum]
           ,[iProductType]
           ,[cMainInvCode]
           ,[iMainMoDetailsID]
           ,[PlanLotNumber]
           ,0  ---[bgift]   ---是否赠品 
		   from PU_ArrivalVouchs
		   where AutoId = @ArvRowid
		   
		   --写入表身扩展表
			Insert Into PU_ArrivalVouchs_ExtraDefine(autoid) Values (@ichild -@irowcount +@rowcount)

		   set @rowcount = @rowcount + 1
		   fetch next from detail_cursor into @ArvRowid, @ReturnNUM
		end
		close detail_cursor
		deallocate detail_cursor
		
		fetch next from my_cursor into @ArvCode, @irowcount
	end
	close my_cursor
	deallocate my_cursor
	
	set nocount off
end
	