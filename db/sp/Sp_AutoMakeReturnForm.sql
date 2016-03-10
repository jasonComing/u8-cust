
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
	set @ArvCode=''

	--非法的采购入库单号或无拒收数量，退出
	if not exists (select * from  rdrecord01 where ccode=@formNO) 
		return
   if not exists (select a.* from  rdrecords01 a left join rdrecord01 b on a.id=b.id 
						left join  rdrecords01_ExtraDefine c on a.autoid=c.autoid
						where b.ccode=@formNO and c.cbdefine26 is not null)
		return
	--取出拒收数量＞０的行，记下到货单表身记录AutoID,并提取出到货数量，拒收数量，存于临时表#TB
		select a.cbarvcode,a.iArrsId,a.cInvCode,d.iquantity,c.cbdefine26  into #tb from   rdrecords01 a left join rdrecord01 b on a.id=b.id 
						left join  rdrecords01_ExtraDefine c on a.autoid=c.autoid
						left join  PU_ArrivalVouchs d on a.iArrsId=d.Autoid
						where b.ccode=@formNO and c.cbdefine26 is not null
	--取出到货单号
	select top 1  @ArvCode=cbarvcode from   rdrecords01 a left join rdrecord01 b on a.id=b.id 
						left join  rdrecords01_ExtraDefine c on a.autoid=c.autoid
						where b.ccode=@formNO and c.cbdefine26 is not null
		
	--查询出到货单表头＼表身信息，并加入主#maintb＼子#deteils表
 	select * into  #maintb from PU_ArrivalVouch where ccode=@ArvCode
	select * into  #deteils from PU_ArrivalVouchs
		where id =(select top 1 ID from PU_ArrivalVouch where ccode=@ArvCode )
		and autoid in(select iarrsid from #tb ) order by autoid
	
   select @irowcount=count(iArrsId) from #tb
	select @irowcount as '条数'
   exec sp_GetId '','001','PuArrival',@irowcount,@ifatherid output,@ichild output,default
   --变更主表数据
	update #maintb set id=@ifatherid
						,ccode=ccode+'_RT'
						,dDate=getdate()
						,cMaker='System'
						,bNegative =1
						,iBillType=2
						,cMakeTime=getdate()
						,cMemo=''
						,cverifier=''
						,iverifystate=0
						,iverifystateex=0
						,cbustype='普通采购'
						,cVenCode ='256'
						,cDepCode =27
						,cexch_name='港币'
						,iexchrate=1
						,iflowid=0
						,cpocode=''
						,csysbarcode ='||pujs|'+ccode+'_RT'
   
	--取出主表单据号
	declare @mainCode varchar(30)	--拒收单主表的单据号
	declare @mainRowid varchar(30)	--拒收单主表行ID
	select top 1 @mainCode = ccode, @mainRowid=id from  #maintb
	
	--变更子表数据
	declare  @ReturnNUM int		--拒收数量
	declare my_cursor  cursor for
		select cbarvcode,iArrsId,cbdefine26  from #tb 
	open my_cursor
	fetch next from my_cursor into @ArvCode,@ArvRowid,@ReturnNUM
	
	while @@FETCH_STATUS = 0 
	begin
		update #deteils set Autoid=@ichild -@irowcount +1
								,ID=@mainRowid
								,iquantity=-@ReturnNUM
								,iOriMoney=-@ReturnNUM * iOriCost 
								,iOriSum=-@ReturnNUM * iOriCost 
								,iMoney =-@ReturnNUM * iOriCost 
								,iSum =-@ReturnNUM * iOriCost 
								,fValidInQuan =0
								,iNum=0
								,fValidQuantity =0
								,iCorId =''
								,fRetQuantity = 0
								,fInValidInQuan =0
								,fRealQuantity=0
								,cbmemo=''
								,ivouchrowno=1
								,cInvCode ='619_000176'
								,carrivalcode=''
								,cbsysbarcode='||pujs|' + @mainCode + '|' + cast(ivouchrowno as varchar(2))
				where autoid=@ArvRowid

				set @irowcount = @irowcount - 1
		
		fetch next from my_cursor into @ArvCode,@ArvRowid,@ReturnNUM
	end
	close my_cursor
	deallocate my_cursor
	

	if @debug >0
		begin
			select * from #tb
			select *  from  #maintb
			select * from PU_ArrivalVouch where ccode='AP16020079'
			select *  from  #deteils
			select * from  PU_ArrivalVouchs where id='1000015927'
		end


   --将数据写入表
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
		  select [iVTid],[ID],[cCode],[cPTCode],[dDate],[cVenCode]
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
           ,[csysbarcode] from  #maintb

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
			   select [Autoid]
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
           ,[bgift] from  #deteils

	set nocount off
end
		--exec sp_AutoMakeReturnForm 'WPI16020115',1
		
		--select * from PU_ArrivalVouch where ccode='AP16020079'
		--select * from  PU_ArrivalVouchs where id='1000015927'
  --    select * from PU_ArrivalVouchs where id='2'

		--Select Max(pu_arrivalvouch.ID) AS ID From pu_arrivalvouch where 1=2 

		--AP16013293_RT