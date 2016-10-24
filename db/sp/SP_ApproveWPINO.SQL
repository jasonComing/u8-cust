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
	declare @spid varchar(50)

	--已審核的單據，不處理
	if not exists(select 1 from Rdrecord01  where cCode=@cCode and dNVerifyTime is  null)
		return

--變更審狀態
	select top 1 @id=id from Rdrecord01  where cCode=@cCode
	Update Rdrecord01  WITH (UPDLOCK)
	Set cHandler=N'System', dVeriDate=convert(date, getdate()),dNVerifyTime=getdate()
	Where Id=@id

	select cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10
	into #LPWriteBackTbl
	from rdrecords01 with (nolock) where 1=2

	create index ix_cinvcode_lpwritebacktbl on #LPWriteBackTbl(cinvcode )

	insert into #LPWriteBackTbl (cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10)
	select cinvcode,isotype,isodid,1* iquantity,1* inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10
	from rdrecords01 as rdrecords
	where isnull(isotype,0)>=4 and id = @id

	delete  #LPWriteBackTbl
	where cinvcode in (
		select cinvcode
		from inventory i with (nolock)
		where isnull(i.cSRPolicy,'') =N'PE')

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

	drop table #LPWriteBackTbl
	drop table #LPWriteBackSumTbl

	select 'mainbatch',* from mainbatch

	update mainbatch set chandler=N'System' where cvouchtype =N'01' and rdmid =@id

	--exec ST_VerForStock N'01',N'1000092330',0,1,1
	exec ST_VerForStock N'01',@id ,0,1,1

	if @debug >0
	begin
		select 'SCM_entryledgerbuffer',* from SCM_entryledgerbuffer
	end

	--取SPID號
	set @spid='spid_'+ cast(@@spid as varchar)
	select 'spid: ' + @spid

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
		select 'SCM_entryledgerbuffer',* from SCM_entryledgerbuffer
	end

	exec Usp_SCM_CommitGeneralLedgerWithCheck N'ST',1,1,0,1,0,1,1,0,1,0,1,0,0 ,0,@spid

end
