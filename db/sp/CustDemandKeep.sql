create procedure CustDemandKeep
	@cwhcode nvarchar(20),
	@makername nvarchar(40),
	@cinvcode nvarchar(120),
	@quantity decimal(30, 10),
	@socode nvarchar(40),
	@batch nvarchar(60) = null
as
begin

declare @initQuantity decimal(30, 10)
declare @finalQuantity decimal(30, 10)

if (select count(*)
	from Inventory
	where cInvCode = @cinvcode
	and cSRPolicy = 'LP') <= 0
begin
	print '存貨檔案不存在或不是LP件: ' + @cinvcode
	return -1
end
	
if (select count(*)
	from CurrentStock
	where cInvCode = @cinvcode
	and cWhCode = @cwhcode
	and cbatch = isnull(@batch, '')
	and isodid = ''
	and iQuantity >= @quantity) <= 0
begin
	print '沒有足夠自由庫存: ' + @cinvcode
	return -1
end

if (select count(*)
	from So_SoMain
	where csocode = @socode) <= 0
begin
	print 'SoCode 不存在: ' + @socode
	return -1
end


begin tran


select @initQuantity = iQuantity
	from CurrentStock
	where cInvCode = @cinvcode
	and cWhCode = @cwhcode
	and cbatch = isnull(@batch, '')
	and isodid = @socode
	
if @initQuantity is null
	set @initQuantity = 0

declare @accountid char(3)
set @accountid = left(right(db_name(), 8), 3)

declare @p5 int
declare @p6 int
exec sp_GetId N'',@accountid,N'rd',2,@p5 output,@p6 output,default

insert into rdrecord08(id,brdflag,cvouchtype,cbustype,csource,cwhcode,ddate,ccode,cmaker,vt_id,iswfcontrolled,dnmaketime,dnmodifytime,dnverifytime) 
values (@p5,N'1',N'08',N'预留入库',N'3',@cwhcode, convert(date, getdate()),@p5,@makername,67,0, getdate(), Null , Null )

Insert Into rdrecord08_ExtraDefine(id) Values (@p5)

Insert Into rdrecords08(autoid,id,cinvcode,inum,iquantity,iunitcost,iprice,ipunitcost,ipprice,cbatch,cvouchcode,cinvouchcode,cinvouchtype,isoutquantity,isoutnum,cfree1,cfree2,dvdate,itrids,cposition,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citem_class,citemcode,cname,citemcname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,cbarcode,inquantity,innum,cassunit,dmadedate,imassdate,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,icheckids,cbvencode,ccheckcode,icheckidbaks,crejectcode,irejectids,ccheckpersoncode,dcheckdate,cmassunit,irsrowno,ioritrackid,coritracktype,cbaccounter,dbkeepdate,bcosting,bvmiused,ivmisettlequantity,ivmisettlenum,cvmivencode,iinvsncount,cserviceoid,cbserviceoid,iinvexchrate,corufts,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cciqbookcode,ibondedsumqty,isodid,isotype,csocode,isoseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,cbmemo,irowno,strowguid,cbsourcecodels,igroupno,idebitids,idebitchildids,cbsysbarcode,icrmvouchids,ccrmvouchcode,iposflag)
	 Values (@p6-1,@p5,@cinvcode,Null,@quantity,Null,Null,Null,Null,@batch,Null,Null,Null,0,0,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,@quantity,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,1,Null,Null,Null,Null,0,0,Null,Null,Null,Null,Null,Null,Null,Null, Null ,Null,Null,Null,Null,@socode,5,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,1,Null,Null,Null,Null,Null,Null,Null,Null,Null) 
Insert Into rdrecords08_ExtraDefine(autoid) Values (@p6-1)

Insert Into rdrecords08(autoid,id,cinvcode,inum,iquantity,iunitcost,iprice,ipunitcost,ipprice,cbatch,cvouchcode,cinvouchcode,cinvouchtype,isoutquantity,isoutnum,cfree1,cfree2,dvdate,itrids,cposition,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citem_class,citemcode,cname,citemcname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,cbarcode,inquantity,innum,cassunit,dmadedate,imassdate,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,icheckids,cbvencode,ccheckcode,icheckidbaks,crejectcode,irejectids,ccheckpersoncode,dcheckdate,cmassunit,irsrowno,ioritrackid,coritracktype,cbaccounter,dbkeepdate,bcosting,bvmiused,ivmisettlequantity,ivmisettlenum,cvmivencode,iinvsncount,cserviceoid,cbserviceoid,iinvexchrate,corufts,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cciqbookcode,ibondedsumqty,isodid,isotype,csocode,isoseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,cbmemo,irowno,strowguid,cbsourcecodels,igroupno,idebitids,idebitchildids,cbsysbarcode,icrmvouchids,ccrmvouchcode,iposflag)
	 Values (@p6,@p5,@cinvcode,Null,@quantity*-1,Null,Null,Null,Null,@batch,Null,Null,Null,0,0,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,@quantity*-1,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,2,Null,Null,Null,Null,0,0,Null,Null,Null,Null,Null,Null,Null,Null, Null ,Null,Null,Null,Null,Null,0,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,2,Null,Null,Null,Null,Null,Null,Null,Null,Null) 
Insert Into rdrecords08_ExtraDefine(autoid) Values (@p6)

 
select cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10 
into #LPWriteBackTbl 
from rdrecords01 with (nolock) where 1=2  

create index ix_cinvcode_lpwritebacktbl on #LPWriteBackTbl(cinvcode )

insert into #LPWriteBackTbl (cinvcode,isotype,isodid,iquantity,inum,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10) 
values (@cinvcode,5,@socode,@quantity,0,N'',N'',N'',N'',N'',N'',N'',N'',N'',N'')

delete  #LPWriteBackTbl  
where cinvcode in (select cinvcode from inventory i with (nolock) where isnull(i.cSRPolicy,'') =N'PE') 

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
from #LPWriteBackTbl a 
inner join inventory I on a.cinvcode = I.cinvcode 


select cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,sum(isnull(iquantity,0)) as iquantity,sum(isnull(inum,0)) as inum  
into  #LPWriteBackSumTbl 
from #LPWriteBackTbl 
group by cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10  

create index index_lpwritebacksumtbl on #LPWriteBackSumTbl(cinvcode,isotype,isodid,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10 ) 
	 
	 
insert into ST_DemandKeepInfo (cinvcode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,iquantity,inum,idemandtype,cdemandid )   
 select cinvcode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,0,0,isotype,isodid   
from #LPWriteBackSumTbl a 
where not exists (
	select cinvcode 
	from ST_DemandKeepInfo 
	where cinvcode=a.cinvcode 
	and idemandtype = a.isotype and cdemandid = a.isodid    and cfree1 = a.cfree1 and  cfree2 = a.cfree2 and cfree3 = a.cfree3 and cfree4 = a.cfree4 and cfree5 = a.cfree5 and cfree6 = a.cfree6    and cfree7 = a.cfree7 and cfree8 = a.cfree8 and cfree9 = a.cfree9 and cfree10 = a.cfree10 
)

update ST_DemandKeepInfo 
set iquantity =isnull(a.iquantity,0) + isnull(b.iquantity,0) ,inum =isnull(a.inum,0) + isnull(b.inum,0)    
from ST_DemandKeepInfo a 
inner join #LPWriteBackSumTbl b on a.cinvcode =b.cinvcode and a.idemandtype = b.isotype and a.cdemandid = b.isodid  and a.cfree1 =b.cfree1 and a.cfree2 =b.cfree2 and a.cfree3 =b.cfree3 and a.cfree4 =b.cfree4 and a.cfree5 =b.cfree5 and a.cfree6 =b.cfree6  and a.cfree7 =b.cfree7 and a.cfree8 =b.cfree8 and a.cfree9 =b.cfree9 and a.cfree10 =b.cfree10 
 
update b 
set b.cbvencode =
	case when isnull(b.cvmivencode,'') <> '' then b.cvmivencode 
	else case when  isnull(a.cvencode,'') = '' then isnull(b.cbvencode,'') 
	else isnull(a.cvencode,'')  end  end   
from rdrecord08 a  with (nolock) 
inner join rdrecords08 b   on a.id =b.id  
inner join inventory i with (nolock) on b.cinvcode=i.cinvcode  
where a.id =@p5 and i.btrack =1 and isnull(b.cvouchcode,0)=0  and isnull(a.cbustype,'') not in (N'调拨入库',N'调拨出库')
 
exec ST_SaveForStock N'08',@p5,0,0 ,1

exec ST_SaveForTrackStock N'08',@p5, 0 ,1

declare @tranid varchar(50)
set @tranid = 'spid_' + convert(varchar(10), @@spid)

insert into SCM_Item(cInvCode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10)
select distinct cInvCode,cfree1,cfree2,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10  
from SCM_EntryLedgerBuffer a with (nolock) 
where a.transactionid=@tranid and not exists (
	select 1 
	from SCM_Item Item 
	where Item.cInvCode=a.cInvCode and Item.cfree1=a.cfree1 and Item.cfree2=a.cfree2 and Item.cfree3=a.cfree3 and Item.cfree4=a.cfree4 and Item.cfree5=a.cfree5 and Item.cfree6=a.cfree6 and Item.cfree7=a.cfree7 and Item.cfree8=a.cfree8 and Item.cfree9=a.cfree9 and Item.cfree10=a.cfree10)
 
exec Usp_SCM_CommitGeneralLedgerWithCheck N'ST',1,1,0,1,0,1,1,0,1,0,1,0,0 ,0,@tranid

declare @p2 int
exec USP_SCMCommitTrackStock @tranid,@p2 output

declare @seed char(4)
select @seed = FORMAT(GETDATE(), 'yyMM')

declare @maxnumber nvarchar(60)
select @maxnumber = cNumber
From VoucherHistory  with (ROWLOCK)  
Where  CardNumber='0301' and cContent='日期' and cSeed=@seed

update VoucherHistory 
set cNumber=@maxnumber + 1 
Where  CardNumber='0301' and cContent='日期' and cSeed=@seed

declare @rdcode nvarchar(60)
set @rdcode = 'WOI' + @seed + format(@maxnumber+1, 'd4')

Update RdRecord08 
Set cCode = @rdcode
Where Id = @p5

declare @pp6 nvarchar(5)
declare @p7 nvarchar(200)
exec AA_GeneralBarCode @accountid,N'0301',N'08',N'st1',@rdcode,@pp6 output,@p7 output

Update RdRecord08 
Set csysbarcode = @p7
Where Id = @p5
 
Update rdrecords08 
Set cbsysbarcode = @p7+N'|'+cast(irowno as nvarchar(19)) 
Where id = @p5

exec IA_SP_WriteUnAccountVouchForST @p5,N'08'

update a  
set csocode = (case when isnull(a.isotype,0)=1 then so_sodetails.csocode when isnull(a.isotype,0)=3  then ex_order.ccode else isodid end ),  
	isoseq  = (case when isnull(a.isotype,0)=1 then so_sodetails.irowno when isnull(a.isotype,0)=3   then ex_orderdetail.irowno else null end )  
from rdrecords08 a   
left join so_sodetails with (nolock)  ON a.isodid = convert(nvarchar(40),so_sodetails.isosid) and a.isotype=1  
left join ex_orderdetail with (nolock) on a.isodid = convert(nvarchar(40),ex_orderdetail.autoid) and a.isotype=3  
left join ex_order with (nolock) on ex_orderdetail.id=ex_order.id  
where a.id = @p5

Update Rdrecord08  WITH (UPDLOCK)  
Set cHandler=@makername,dVeriDate=convert(date, getdate())
Where id=@p5


-- valiation
select @finalQuantity = iQuantity
	from CurrentStock
	where cInvCode = @cinvcode
	and cWhCode = @cwhcode
	and cbatch = isnull(@batch, '')
	and isodid = @socode
	
if @finalQuantity is null
	set @finalQuantity = 0

if @finalQuantity - @quantity != @initQuantity
begin
	print '預留失敗. 結果現存量:' + convert(varchar(20), @finalQuantity) + ' 原本現存量: ' + convert(varchar(20), @initQuantity)
	rollback;
end
else
begin
	commit;
end

end