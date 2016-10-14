alter proc SP_ApproveWPINO
/*
功能：依測試TQ單據號，做審核動作,
		TQ採購入庫量，自動加到報廢倉庫存。

調用：exec SP_ApproveWPINO 'WPI16100005_TQ',1
     delete from SCM_CommitEntryBuffer
	  delete from  SCM_entryledgerbuffer
*/
	@cCode varchar(60) = null,
	@debug int = 0
as
begin
	declare @id bigint
	declare @spid varchar

	--已審核的單據，不處理
	if not exists(select 1 from Rdrecord01  where cCode=@cCode and cHandler is  null)
		return

--變更審狀態
	select top 1 @id=id from Rdrecord01  where cCode=@cCode
	Update Rdrecord01  WITH (UPDLOCK)  Set cHandler=N'System', dVeriDate=getdate(),dNVerifyTime=getdate() Where Id=@id

	--Update Rdrecord01  Set cHandler=''  where  cCode='WPI16100001_TQ'

	select cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10
	into #LPWriteBackTbl
	from rdrecords01 with (nolock) where 1=2

	--為何做索引？
	create index ix_cinvcode_lpwritebacktbl on #LPWriteBackTbl(cinvcode )

	insert into #LPWriteBackTbl (cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10)
	select cinvcode,isotype,isodid,1* iquantity,1* inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10
	from rdrecords01 as rdrecords
	where isnull(isotype,0)>=4 and id = @id

	delete  #LPWriteBackTbl  where cinvcode in (select cinvcode from inventory i with (nolock) where isnull(i.cSRPolicy,'') =N'PE')

	update #LPWriteBackTbl
	set inum = case when I.igrouptype =2 then isnull(a.inum,0) else 0 end ,
		cfree1 = case when isnull(I.bconfigfree1,0) =0 then '' else isnull(a.cfree1,'') end ,
		cfree2 = case when isnull(I.bconfigfree2,0) =0 then '' else isnull(a.cfree2,'') end ,
		cfree3 = case when isnull(I.bconfigfree3,0) =0 then '' else isnull(a.cfree3,'') end ,
		cfree4 = case when isnull(I.bconfigfree4,0) =0 then '' else isnull(a.cfree4,'') end ,
		cfree5 = case when isnull(I.bconfigfree5,0) =0 then '' else isnull(a.cfree5,'') end ,
		cfree6 = case when isnull(I.bconfigfree6,0) =0 then '' else isnull(a.cfree6,'') end ,
		cfree7 = case when isnull(I.bconfigfree7,0) =0 then '' else isnull(a.cfree7,'') end ,
		cfree8 = case when isnull(I.bconfigfree8,0) =0 then '' else isnull(a.cfree8,'') end ,
		cfree9 = case when isnull(I.bconfigfree9,0) =0 then '' else isnull(a.cfree9,'') end ,
		cfree10 = case when isnull(I.bconfigfree10,0) =0 then '' else isnull(a.cfree10,'') end
	from #LPWriteBackTbl a inner join inventory I on a.cinvcode = I.cinvcode

	select cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,
		cfree7,cfree8,cfree9,cfree10,sum(isnull(iquantity,0)) as iquantity,sum(isnull(inum,0)) as inum
	into  #LPWriteBackSumTbl
	from #LPWriteBackTbl
	group by cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10

	--？？為何做索引？
	create index index_lpwritebacksumtbl
	on #LPWriteBackSumTbl(cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10)

	--插入預留表
	insert into ST_DemandKeepInfo (cinvcode,cfree1,cfree2,cfree3,cfree4,cfree5,
			cfree6,cfree7,cfree8,cfree9,cfree10,iquantity,inum,idemandtype,cdemandid)
	select cinvcode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,0,0,isotype,isodid
	from #LPWriteBackSumTbl a
	where not exists(
			select cinvcode from ST_DemandKeepInfo
			where cinvcode=a.cinvcode and idemandtype = a.isotype and cdemandid = a.isodid
					and cfree1 = a.cfree1 and  cfree2 = a.cfree2 and cfree3 = a.cfree3 and cfree4 = a.cfree4
					and cfree5 = a.cfree5 and cfree6 = a.cfree6    and cfree7 = a.cfree7 and cfree8 = a.cfree8
					and cfree9 = a.cfree9 and cfree10 = a.cfree10
					)

	--變更預留表數量
	update ST_DemandKeepInfo
	set iquantity =isnull(a.iquantity,0) + isnull(b.iquantity,0),
		inum =isnull(a.inum,0) + isnull(b.inum,0)
	from ST_DemandKeepInfo a
	inner join #LPWriteBackSumTbl b
	on (a.cinvcode =b.cinvcode and a.idemandtype = b.isotype and a.cdemandid = b.isodid
		and a.cfree1 =b.cfree1 and a.cfree2 =b.cfree2 and a.cfree3 =b.cfree3
		and a.cfree4 =b.cfree4 and a.cfree5 =b.cfree5 and a.cfree6 =b.cfree6  and a.cfree7 =b.cfree7
		and a.cfree8 =b.cfree8 and a.cfree9 =b.cfree9 and a.cfree10 =b.cfree10)

	--if @debug >0
	--	begin
	--			select '#LPWriteBackTbl',* from #LPWriteBackTbl
	--			select '##LPWriteBackSumTbl',* from #LPWriteBackSumTbl
	--	end
	drop table #LPWriteBackTbl
	drop table #LPWriteBackSumTbl

	select 'mainbatch',* from mainbatch

	update mainbatch set chandler=N'System' where cvouchtype =N'01' and rdmid =@id

	--exec ST_VerForStock N'01',N'1000092330',0,1,1
	exec ST_VerForStock N'01',@id ,0,1,1

	if @debug >0
			select 'SCM_entryledgerbuffer',* from SCM_entryledgerbuffer

	--取SPID號
	select 'spid：'+ cast(@@spid as varchar)
	set @spid='spid_'+ cast(@@spid as varchar)

	insert into SCM_Item(cInvCode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10)
		select distinct cInvCode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10
		from SCM_EntryLedgerBuffer a with (nolock)
		where a.transactionid=@spid
		and not exists (
				select 1 from SCM_Item Item
				where Item.cInvCode=a.cInvCode and Item.cfree1=a.cfree1
				and Item.cfree2=a.cfree2 and Item.cfree3=a.cfree3
				and Item.cfree4=a.cfree4 and Item.cfree5=a.cfree5
				and Item.cfree6=a.cfree6 and Item.cfree7=a.cfree7 and Item.cfree8=a.cfree8
				and Item.cfree9=a.cfree9 and Item.cfree10=a.cfree10
				)
   if @debug >0
	begin
		select 'SCM_Item',* from SCM_Item where cInvCode='607_000855'
		select 'SCM_entryledgerbuffer',* from SCM_entryledgerbuffer
	end

	declare @ItemId varchar(10)
	select top 1 @ItemId=Id  from SCM_Item  order by id desc
	select  top 10 * from SCM_Item  order by id desc

	select  '@ItemId：' +@ItemId
	----刪除數量為負數的
	--  delete  from  SCM_entryledgerbuffer where Subject='0101' and TransactionId=@spid and iQuantity <0

	--准備數據
	update SCM_EntryLedgerBuffer
	set ibillquantity = 0,ibillnum = 0
	where sequenceid in
			(  select min(sequenceid) from SCM_EntryLedgerBuffer where TransactionId=@spid
						group by documenttype,documentdid,documentid,cwhcode,cinvcode,isnull(cfree1,''),
								isnull(cfree2,''),isnull(cfree3,''),isnull(cfree4,''),isnull(cfree5,''),
								isnull(cfree6,''),isnull(cfree7,''),isnull(cfree8,''),isnull(cfree9,''),
								isnull(cfree10,''),isnull(cvmivencode,''),isnull(cbatch,'')
						having count(sequenceid) > 1
					)
	and TransactionId=@spid

	update a
	set itemId =Item.Id,
	inum=case when inventory.igrouptype=2 then a.inum else 0 end,
	ibillnum=case when inventory.igrouptype=2 then a.ibillnum else 0 end,
	DemandPlanType=case when isnull(inventory.cSRPolicy,N'PE') = N'LP' and bspecialorder=1
						then a.DemandPlanType else 0 end,
	DemandPlanDId=case when isnull(inventory.cSRPolicy,N'PE') = N'LP' and bspecialorder=1
						then case when isnull(a.DemandPlanType,0)=0  then '' else  a.DemandPlanDId end  else '' end,
	PEDemandPlanType=case when isnull(inventory.cSRPolicy,N'PE') = N'LP' and bspecialorder=1
						then 0 else a.DemandPlanType end,
	PEDemandPlanDId=case when not ( isnull(inventory.cSRPolicy,N'PE') = N'LP' and bspecialorder=1) then
						case when isnull(a.DemandPlanType,0)=0  then '' else  a.DemandPlanDId end  else '' end
   from SCM_EntryLedgerBuffer a with (nolock)
	inner join SCM_Item Item with (nolock) on a.transactionid=@spid
				and Item.cInvCode=a.cInvCode and Item.cfree1=a.cfree1 and Item.cfree2=a.cfree2 and Item.cfree3=a.cfree3
				and Item.cfree4=a.cfree4 and Item.cfree5=a.cfree5 and Item.cfree6=a.cfree6 and Item.cfree7=a.cfree7
				and Item.cfree8=a.cfree8 and Item.cfree9=a.cfree9 and Item.cfree10=a.cfree10
   inner join inventory with (nolock) on a.cinvcode=inventory.cinvcode
   where TransactionId=@spid

	if @debug > 0
		select 'SCM_entryledgerbuffer33',* from SCM_EntryLedgerBuffer

	declare @tempspid varchar(20)
	select top 1  @tempspid =TransactionId   from SCM_EntryLedgerBuffer order by SequenceId

	if @debug > 0
		select  'TransactionId：'+@tempspid

	delete from SCM_CommitEntryBuffer where TransactionId=@tempspid

	--插入SCM_CommitEntryBuffer
	insert into SCM_CommitEntryBuffer(subject,cwhcode,cinvcode,ItemId,cbatch,cVMIVenCode,
			iquantity,inum,ibillquantity,ibillnum,transactionid,
			DocumentType,DocumentId,DocumentDId,DemandPlanType,DemandPlanDId,
			cBusType,cSource,dmdate,dvdate,imassunit,imassday,cExpirationdate,dExpirationdate,iExpiratDateCalcu)
   select left(subject,4),cwhcode,EntryLedgerBuffer.cinvcode,ItemId,cbatch,cVMIVenCode,sum(iquantity) as iquantity,
			sum(inum) as inum,sum(ibillquantity) as ibillquantity,sum(ibillnum) as ibillnum,EntryLedgerBuffer.TransactionId,DocumentType,DocumentId,
			DocumentDId,DemandPlanType,DemandPlanDId,cBusType,cSource,
			max(dmdate) as dmdate,max(dvdate) as dvdate,
			max(imassunit) as imassunit,max(imassday) as imassday,
			max(cExpirationdate),max(dExpirationdate),max(iExpiratDateCalcu)
	from SCM_EntryLedgerBuffer EntryLedgerBuffer with(nolock)
	where TransactionId=@tempspid and isnull(cwhcode,N'')<>N''
	group by left(subject,4),cwhcode,EntryLedgerBuffer.cinvcode,itemid,cbatch,
	cVMIVenCode,DocumentType, DocumentId,DocumentDId,DemandPlanType,DemandPlanDId,cBusType,cSource,EntryLedgerBuffer.TransactionId
	having(sum(iquantity)<>0 or sum(inum) <>0 or
	isnull(max(dvdate),'1900-01-01')<>isnull(min(dvdate),'1900-01-01') or
	isnull(max(dmdate),'1900-01-01')<>isnull(min(dmdate),'1900-01-01') )

	if @debug >0
		select 'SCM_CommitEntryBuffer' as SCM_CommitEntryBuffer表,* from SCM_CommitEntryBuffer

	--放入緩存表 #Buffer
	select cwhcode,cinvcode,ItemId,cbatch,cVMIVenCode,demandplantype,demandplandid,iquantity,inum,istopquantity,
		 istopnum,idisablequantity,idisablenum,iinquantity,iinnum,itransinquantity,itransinnum,ioutquantity,ioutnum,
		 itransoutquantity,itransoutnum,dmdate,dvdate,imassunit,imassday,cExpirationdate,dExpirationdate ,iExpiratDateCalcu
   into #Buffer
   from  (select cwhcode,cinvcode,ItemId,cbatch,cVMIVenCode,demandplantype,demandplandid,
		  sum(case when subject=N'0201' then iquantity else 0 end) as iquantity,
		  sum(case when subject=N'0201' then inum else 0 end) as inum,
		  sum(case when subject=N'0202' then iquantity else 0 end) as istopquantity,
		  sum(case when subject=N'0202' then inum else 0 end) as istopnum,
						 sum(case when subject=N'0203' then iquantity else 0 end) as idisablequantity,
		  sum(case when subject=N'0203' then inum else 0 end) as idisablenum,
		  sum(case when subject=N'0101' then iquantity else 0 end) as iinquantity,
		  sum(case when subject=N'0101' then inum else 0 end) as iinnum,
		  sum(case when subject=N'0102' then iquantity else 0 end) as itransinquantity,
		  sum(case when subject=N'0102' then inum else 0 end) as itransinnum,
						 sum(case when subject=N'0301' then iquantity else 0 end) as ioutquantity,
		  sum(case when subject=N'0301' then inum else 0 end) as ioutnum,
		  sum(case when subject=N'0302' then iquantity else 0 end) as itransoutquantity,
		  sum(case when subject=N'0302' then inum else 0 end) as itransoutnum,
		  max(dmdate) as dmdate,max(dvdate) as dvdate,max(imassunit) as imassunit,
		  max(imassday) as imassday ,max(cExpirationdate) as cExpirationdate,
		  max(dExpirationdate)  as dExpirationdate,max(iExpiratDateCalcu) as iExpiratDateCalcu
            from SCM_CommitEntryBuffer with(nolock) where TransactionId=@tempspid
            group by cwhcode,cinvcode,itemid,cbatch,cVMIVenCode,demandplantype,demandplandid) b

	where iquantity<>0 or inum<>0 or istopquantity<>0 or istopnum<>0 or idisablequantity<>0 or
				idisablenum<> 0 or iinquantity <> 0 or iinnum <> 0 or itransinquantity<>0 or itransinnum <> 0
				or ioutquantity <> 0 or ioutnum <> 0 or itransoutquantity<>0 or itransoutnum<>0

	if @debug >0
			select '#Buffer' as Buffer表 , * from  #Buffer

	  --變更現存量表
	Update CurrentStock set CurrentStock.iquantity =CurrentStock.iquantity+b.iquantity,
			CurrentStock.inum =CurrentStock.inum+b.inum,
			CurrentStock.fstopquantity =CurrentStock.fstopquantity+b.istopquantity,
			CurrentStock.fstopnum =CurrentStock.fstopnum+b.istopnum,
			CurrentStock.fdisablequantity =CurrentStock.fdisablequantity+b.idisablequantity,
			CurrentStock.fdisablenum =CurrentStock.fdisablenum+b.idisablenum,
			CurrentStock.finquantity =CurrentStock.finquantity+b.iinquantity,
			CurrentStock.finnum =CurrentStock.finnum+b.iinnum,
			CurrentStock.ftransinquantity =CurrentStock.ftransinquantity+b.itransinquantity,
			CurrentStock.ftransinnum =CurrentStock.ftransinnum+b.itransinnum,
			CurrentStock.foutquantity =CurrentStock.foutquantity+b.ioutquantity,
			CurrentStock.foutnum =CurrentStock.foutnum+b.ioutnum,
			CurrentStock.ftransoutquantity =CurrentStock.ftransoutquantity+b.itransoutquantity,
			CurrentStock.ftransoutnum =CurrentStock.ftransoutnum+b.itransoutnum,
			CurrentStock.dmdate=b.dmdate,
			CurrentStock.dvdate=b.dvdate,
			CurrentStock.cmassunit=b.imassunit,
			CurrentStock.imassdate=b.imassday,
			CurrentStock.cExpirationdate=b.cExpirationdate,
			CurrentStock.dExpirationdate =b.dExpirationdate,
			currentstock.iExpiratDateCalcu=b.iExpiratDateCalcu
	from CurrentStock  inner join #Buffer b with(nolock) on
	dbo.CurrentStock.cWhCode = b.cWhCode AND
	dbo.CurrentStock.cInvCode = b.cInvCode AND
	--dbo.CurrentStock.ItemId = b.ItemId AND
	dbo.CurrentStock.cBatch = b.cBatch and
	dbo.CurrentStock.cVMIVenCode = b.cVMIVenCode and
	dbo.CurrentStock.isotype = b.demandplantype and
	dbo.CurrentStock.isodid = b.demandplandid

	--不存時，插入
	insert into CurrentStock(cwhcode,cinvcode,itemId,cbatch,cVMIVenCode,isotype,isodid,iquantity,inum,
		  fstopquantity,fstopnum,fdisablequantity,fdisablenum,finquantity,finnum,ftransinquantity,
		  ftransinnum,foutquantity,foutnum,ftransoutquantity,ftransoutnum,cfree1,cfree2,cfree3,cfree4,cfree5,
		  cfree6,cfree7,cfree8,cfree9,cfree10,dmdate,dvdate,cmassunit,imassdate,cExpirationdate,dExpirationdate,iExpiratDateCalcu)

	select cwhcode,b.cinvcode,b.ItemId,cbatch,cVMIVenCode,demandplantype,demandplandid,iquantity,
	inum,istopquantity,istopnum,idisablequantity,idisablenum,iinquantity,iinnum,
	itransinquantity,itransinnum,ioutquantity,ioutnum,itransoutquantity,itransoutnum,
	cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,dmdate,dvdate,
	imassunit,imassday ,cExpirationdate,dExpirationdate,iExpiratDateCalcu
	from #Buffer b with(nolock)
	inner join SCM_Item item with (nolock)
   on b.cInvCode =Item.cInvCode
	--and b.ItemId=Item.id
	where not exists
            (select 1 from CurrentStock where
				dbo.CurrentStock.cWhCode = b.cWhCode  AND
            dbo.CurrentStock.cInvCode = b.cInvCode AND
            --dbo.CurrentStock.ItemId = b.ItemId AND
            dbo.CurrentStock.cBatch = b.cBatch and
            dbo.CurrentStock.cVMIVenCode = b.cVMIVenCode and
            dbo.CurrentStock.isotype = b.demandplantype and
            dbo.CurrentStock.isodid = b.demandplandid)

	-- 更新生产日期 保质期等信息
	update CurrentStock
		set CurrentStock.dmdate=b.dmdate,CurrentStock.dvdate=b.dvdate,
		CurrentStock.cmassunit= case when isnull(currentstock.cmassunit,0)=0 then 0 else b.imassunit end ,
		CurrentStock.cExpirationdate=b.cExpirationdate,
		CurrentStock.dExpirationdate=case when isnull(b.iExpiratDateCalcu,0)=0 then null else b.dExpirationdate end,
		currentstock.iExpiratDateCalcu=b.iExpiratDateCalcu,imassdate=b.imassday
   from CurrentStock inner join SCM_EntryLedgerBuffer b with (nolock)
   on b.TransactionId=@spid and  dbo.CurrentStock.cWhCode = b.cWhCode AND
                  dbo.CurrentStock.cInvCode = b.cInvCode AND
                  dbo.CurrentStock.ItemId = b.ItemId AND
                  dbo.CurrentStock.cBatch = b.cBatch and
                  dbo.CurrentStock.cVMIVenCode = b.cVMIVenCode and
                  dbo.CurrentStock.isotype = b.demandplantype and
                  dbo.CurrentStock.isodid = b.demandplandid
   where isnull(iBillQuantity,0)<>0

	delete from SCM_EntryLedgerBuffer where TransactionId=@tempspid
	delete from SCM_EntryLedgerBuffer where TransactionId=@tempspid

		--exec Usp_SCM_CommitGeneralLedgerWithCheck N'ST',1,1,0,1,0,1,1,0,1,0,1,0,0 ,0,@spid

end

