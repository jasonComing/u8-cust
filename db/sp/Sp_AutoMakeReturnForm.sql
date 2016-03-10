
ALTER  proc [dbo].[sp_AutoMakeReturnForm]
/*
功能：依采购入库单上的拒收数量，
		自动开到货拒收单据，单据号
		形如：AP16013293_RT
调用：在采购入单保存新增时，自动触发执行
作者：jams
*/
@formNO varchar(30), --採購入庫單號
@debug int=0 --是1否0测试
as 
begin
	Set nocount on
	declare @ArvCode varchar(30)	--到貨單號
	declare @ArvRowid varchar(30)	--到货单表身记录行标记号
	declare @irowcount int			--拒收数量＞0的的总行数
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
	and not exists (select 1 from rdrecord01 innerM where innerM.cCode = m.cCode + '_RT')

	if @debug > 0
	begin
		select '#tb', *
		from #tb
	end
	
	--Loop by each Voucher
	declare my_cursor cursor for
		select distinct(cbarvcode), count(*)
		from #tb
		group by cbarvcode
	open my_cursor
	fetch next from my_cursor into @ArvCode, @irowcount
	while @@FETCH_STATUS = 0 
	begin

		-- Get the ID
		exec sp_GetId '','001','PuArrival',@irowcount,@ifatherid output,@ichild output,default
		
		select 'Id', @irowcount as count, @ifatherid as father, @ichild as child
		
		-- Insert the main table
		insert into PU_ArrivalVouch([iVTid],[ID],[cCode],[cPTCode],[dDate],[cVenCode]
           ,[cDepCode],[cPersonCode],[cPayCode],[cexch_name],[iExchRate],[iTaxRate]
           ,[cMemo],[cBusType],[cMaker],[bNegative],[cDefine1]
           ,[cDefine10],[iDiscountTaxType],[iBillType]
           ,[cMakeTime]
           ,[cAuditDate]
           ,[caudittime]
           ,[cverifier]
           ,[iverifystateex]
           ,[ireturncount]
           ,[IsWfControlled]
           ,[cVenPUOMProtocol]
           ,[cchanger]
           ,[iflowid]
           ,[iPrintCount]
           ,[ccleanver]
           ,[cpocode]
           ,[csysbarcode]
         )
		  select 
		  8169, 
		  @ifatherid,
		  @ArvCode+'_RT',
		  [cPTCode]
		  ,CONVERT(date, getdate()) -- dDate
           ,[cVenCode]
           ,[cDepCode],[cPersonCode],[cPayCode],[cexch_name],[iExchRate],[iTaxRate]
           ,null --cMemo
		   ,[cBusType]
		   ,'system' --cMaker
		   ,1 --bNegative
		   ,[cDefine1]
           ,[cDefine10],[iDiscountTaxType]
		   ,2 --iBillType
           ,getdate()
           ,[cAuditDate]
           ,[caudittime]
           ,[cverifier]
           ,0 --iverifystateex
           ,[ireturncount]
           ,[IsWfControlled]
           ,[cVenPUOMProtocol]
           ,[cchanger]
           ,[iflowid]
           ,[iPrintCount]
           ,[ccleanver]
           ,[cpocode]
           ,'||pujs|'+@ArvCode+'_RT' --csysbarcode
		   from PU_ArrivalVouch
		   where cCode = @ArvCode

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
			insert into PU_ArrivalVouchs([Autoid]
           ,[ID]
           ,[cWhCode]
           ,[cInvCode]
           ,[iNum]
           ,[iQuantity]
           ,[iOriCost]
           ,[iOriTaxCost]
           ,[iOriMoney]
           ,[iOriTaxPrice]
           ,[iOriSum]
           ,[iCost]
           ,[iMoney]
           ,[iTaxPrice]
           ,[iSum]
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
           ,[cDefine26]
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
           ,[fValidInQuan]
           ,[fKPQuantity]
           ,[fRealQuantity]
           ,[fValidQuantity]
           ,[finValidQuantity]
           ,[cCloser]
           ,[iCorId]
           ,[fRetQuantity]
           ,[fInValidInQuan]
           ,[bGsp]
           ,[cBatch]
           ,[dVDate]
           ,[dPDate]
           ,[fRefuseQuantity]
           ,[cGspState]
           ,[fValidNum]
           ,[fValidInNum]
           ,[fInValidNum]
           ,[fRealNum]
           ,[bTaxCost]
           ,[bInspect]
           ,[fRefuseNum]
           ,[iPPartId]
           ,[iPQuantity]
           ,[iPTOSeq]
           ,[SoDId]
           ,[SoType]
           ,[ContractRowGUID]
           ,[imassdate]
           ,[cmassunit]
           ,[bexigency]
           ,[cbcloser]
           ,[fSumRefuseQuantity]
           ,[FSumRefuseNum]
           ,[fRetNum]
           ,[fDTQuantity]
           ,[fInvalidInNum]
           ,[fDegradeQuantity]
           ,[fDegradeNum]
           ,[fDegradeInQuantity]
           ,[fDegradeInNum]
           ,[fInspectQuantity]
           ,[fInspectNum]
           ,[iInvMPCost]
           ,[guids]
           ,[iinvexchrate]
           ,[objectid_source]
           ,[autoid_source]
           ,[ufts_source]
           ,[irowno_source]
           ,[csocode]
           ,[isorowno]
           ,[iorderid]
           ,[cordercode]
           ,[iorderrowno]
           ,[dlineclosedate]
           ,[ContractCode]
           ,[ContractRowNo]
           ,[RejectSource]
           ,[iciqbookid]
           ,[cciqbookcode]
           ,[cciqcode]
           ,[fciqchangrate]
           ,[irejectautoid]
           ,[iExpiratDateCalcu]
           ,[cExpirationdate]
           ,[dExpirationdate]
           ,[cupsocode]
           ,[iorderdid]
           ,[iordertype]
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
           ,[ivouchrowno]
           ,[irowno]
           ,[cbMemo]
           ,[cbsysbarcode]
           ,[carrivalcode]
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
           ,[bgift]) 
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
           ,[iTaxPrice]
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
           ,[cDefine26]
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
           ,0 --fRealQuantity
           ,0 --fValidQuantity
           ,0 --finValidQuantity
           ,[cCloser]
           ,@ArvRowid --iCorId
           ,0 --fRetQuantity
           ,[fInValidInQuan]
           ,[bGsp]
           ,[cBatch]
           ,[dVDate]
           ,[dPDate]
           ,[fRefuseQuantity]
           ,[cGspState]
           ,[fValidNum]
           ,[fValidInNum]
           ,[fInValidNum]
           ,[fRealNum]
           ,[bTaxCost]
           ,[bInspect]
           ,[fRefuseNum]
           ,[iPPartId]
           ,[iPQuantity]
           ,[iPTOSeq]
           ,[SoDId]
           ,[SoType]
           ,[ContractRowGUID]
           ,[imassdate]
           ,[cmassunit]
           ,[bexigency]
           ,[cbcloser]
           ,[fSumRefuseQuantity]
           ,[FSumRefuseNum]
           ,[fRetNum]
           ,[fDTQuantity]
           ,[fInvalidInNum]
           ,[fDegradeQuantity]
           ,[fDegradeNum]
           ,[fDegradeInQuantity]
           ,[fDegradeInNum]
           ,[fInspectQuantity]
           ,[fInspectNum]
           ,[iInvMPCost]
           ,[guids]
           ,[iinvexchrate]
           ,[objectid_source]
           ,[autoid_source]
           ,[ufts_source]
           ,[irowno_source]
           ,[csocode]
           ,[isorowno]
           ,[iorderid]
           ,[cordercode]
           ,[iorderrowno]
           ,[dlineclosedate]
           ,[ContractCode]
           ,[ContractRowNo]
           ,[RejectSource]
           ,[iciqbookid]
           ,[cciqbookcode]
           ,[cciqcode]
           ,[fciqchangrate]
           ,[irejectautoid]
           ,[iExpiratDateCalcu]
           ,[cExpirationdate]
           ,[dExpirationdate]
           ,[cupsocode]
           ,[iorderdid]
           ,[iordertype]
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
           ,@rowcount --ivouchrowno
           ,[irowno]
           ,null --cbMemo
           ,'||pujs|' + @ArvCode + '_RT' + '|' + cast(ivouchrowno as varchar(2)) --cbsysbarcode
           ,null --carrivalcode
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
           ,[bgift]
		   from PU_ArrivalVouchs
		   where AutoId = @ArvRowid
		   
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
		--exec sp_AutoMakeReturnForm 'WPI16020115',1
		
		--select * from PU_ArrivalVouch where ccode='AP16020079'
		--select * from  PU_ArrivalVouchs where id='1000015927'
  --    select * from PU_ArrivalVouchs where id='2'

		--Select Max(pu_arrivalvouch.ID) AS ID From pu_arrivalvouch where 1=2 

		--AP16013293_RT