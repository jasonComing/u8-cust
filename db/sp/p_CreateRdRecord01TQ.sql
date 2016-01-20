PO15107598	605_000141	270	269	1	WPI15113777
WPI15100209

-- 1. Find all rdrecords01 that has testing quantities
-- Get into the warehouse  (No_TQ)
-- Erase it

ALTER PROCEDURE [dbo].[p_CreateRdRecord01TQ] 
	@cCode varchar(60) = null,
	@debug int = 0
AS
BEGIN

declare @p5 int
declare @p6 int
declare @id int
declare @autoid int
declare @rowcount int

-- temp table
select m.id, d.Autoid
into #ProcessIds
from rdrecord01 m
join rdrecords01 d on d.id = m.id
join rdrecords01_ExtraDefine e on e.autoid = d.autoid
where e.cbdefine7 is not null
and cCode = isnull(@cCode, cCode)
and not exists (select 1 from rdrecord01 innerM where innerM.cCode = m.cCode + '_TQ')

select 0 as id, brdflag,cvouchtype,cbustype,csource,cwhcode,ddate,cCode,crdcode,cdepcode,cpersoncode,cptcode,cvencode,cordercode,carvcode,cmemo,cmaker,cdefine1,cdefine2,cdefine10,bpufirst,darvdate,vt_id,bisstqc,ipurarriveid,itaxrate,iexchrate,cexch_name,bomfirst,idiscounttaxtype,iswfcontrolled,dnmaketime,dnmodifytime,dnverifytime,bredvouch,bcredit,iprintcount
into #main
from rdrecord01
where 1 = 0

select 0 as autoid, 0 as id,cinvcode,inum,iquantity,iunitcost,iprice,iaprice,ipunitcost,ipprice,cbatch,cvouchcode,cinvouchcode,cinvouchtype,isoutquantity,isoutnum,cfree1,cfree2,dsdate,itax,isquantity,isnum,imoney,ifnum,ifquantity,dvdate,cposition,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citem_class,citemcode,iposid,facost,cname,citemcname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,cbarcode,inquantity,innum,cassunit,dmadedate,imassdate,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,icheckids,cbvencode,cgspstate,iarrsid,ccheckcode,icheckidbaks,crejectcode,irejectids,ccheckpersoncode,dcheckdate,ioritaxcost,ioricost,iorimoney,ioritaxprice,iorisum,itaxrate,itaxprice,isum,btaxcost,cpoid,cmassunit,imaterialfee,iprocesscost,iprocessfee,dmsdate,ismaterialfee,isprocessfee,iomodid,strcontractid,strcode,cbaccounter,dbkeepdate,bcosting,isumbillquantity,bvmiused,ivmisettlequantity,ivmisettlenum,cvmivencode,iinvsncount,impcost,iimosid,iimbsid,cbarvcode,dbarvdate,iinvexchrate,corufts,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cciqbookcode,ibondedsumqty,iordertype,iorderdid,iordercode,iorderseq,isodid,isotype,csocode,isoseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,cbmemo,ifaqty,istax,irowno,strowguid,idebitids,ioldpartid,foldquantity,cbsysbarcode,bmergecheck,imergecheckautoid,creworkmocode,ireworkmodetailsid,iproducttype,cmaininvcode,imainmodetailsid,isharematerialfee,cplanlotcode,bgift,iposflag
into #detail
from rdrecords01 d
where 1 = 0


if @debug > 0
begin
	select 'ProcessIds', * from #ProcessIds
end

-- loop
declare db_cursor cursor for
	select id, count(*)
	from #ProcessIds
	group by id

open db_cursor
fetch next from db_cursor into @id, @rowcount

while @@FETCH_STATUS = 0 
begin
	exec sp_GetId '','004','rd',@rowcount,@p5 output,@p6 output,default
	
	if (@debug > 0)
	begin
		select 'p5, p6', @p5, @p6
	end
	
	-- now insert into rdrecord01
	insert into #main
	select @p5 as id, brdflag,cvouchtype,cbustype,csource,cwhcode,ddate,cCode + '_TQ' as cCode,crdcode,cdepcode,cpersoncode,cptcode,cvencode,cordercode,carvcode,cmemo,'system',cdefine1,cdefine2,cdefine10,bpufirst,darvdate,vt_id,bisstqc,ipurarriveid,itaxrate,iexchrate,cexch_name,bomfirst,idiscounttaxtype,iswfcontrolled,getdate(),null, null,bredvouch,bcredit,iprintcount
	from rdrecord01
	where id = @id
	
	-- now insert into rdrecords
	select @rowcount = count(*) from #ProcessIds where id = @id
	
	declare autoid_cursor cursor for
		select AutoId
		from #ProcessIds
		where id = @id
	
	open autoid_cursor
	fetch next from autoid_cursor into @autoid

	while @@FETCH_STATUS = 0 
	begin
		insert into #detail
		select @p6-@rowcount+1, @p5,cinvcode,inum,e.cbdefine7,iunitcost,iprice,iaprice,ipunitcost,ipprice,cbatch,cvouchcode,cinvouchcode,cinvouchtype,isoutquantity,isoutnum,cfree1,cfree2,dsdate,itax,isquantity,isnum,imoney,ifnum,ifquantity,dvdate,cposition,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citem_class,citemcode,iposid,facost,cname,citemcname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,cbarcode,inquantity,innum,cassunit,dmadedate,imassdate,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,icheckids,cbvencode,cgspstate,iarrsid,ccheckcode,icheckidbaks,crejectcode,irejectids,ccheckpersoncode,dcheckdate,ioritaxcost,ioricost,iorimoney,ioritaxprice,iorisum,itaxrate,itaxprice,isum,btaxcost,cpoid,cmassunit,imaterialfee,iprocesscost,iprocessfee,dmsdate,ismaterialfee,isprocessfee,iomodid,strcontractid,strcode,cbaccounter,dbkeepdate,bcosting,isumbillquantity,bvmiused,ivmisettlequantity,ivmisettlenum,cvmivencode,iinvsncount,impcost,iimosid,iimbsid,cbarvcode,dbarvdate,iinvexchrate,corufts,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cciqbookcode,ibondedsumqty,iordertype,iorderdid,iordercode,iorderseq,isodid,isotype,csocode,isoseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,cbmemo,ifaqty,istax,irowno,strowguid,idebitids,ioldpartid,foldquantity,cbsysbarcode,bmergecheck,imergecheckautoid,creworkmocode,ireworkmodetailsid,iproducttype,cmaininvcode,imainmodetailsid,isharematerialfee,cplanlotcode,bgift,iposflag
		from rdrecords01 d
		join rdrecords01_extradefine e on e.autoid = d.autoid
		and e.autoid = @autoid
		
		 Insert Into rdrecords01_ExtraDefine(autoid) Values  (@p6-@rowcount+1)
		 
		set @rowcount = @rowcount - 1
		
		fetch next from autoid_cursor into @autoid
	end
	
	close autoid_cursor
	deallocate autoid_cursor
	
	fetch next from db_cursor into @id, @rowcount

end

close db_cursor
deallocate db_cursor

if @debug >0
begin
	select 'main', * from #main
	select 'detail', * from #detail
end

insert into rdrecord01(id,brdflag,cvouchtype,cbustype,csource,cwhcode,ddate,ccode,crdcode,cdepcode,cpersoncode,cptcode,cvencode,cordercode,carvcode,cmemo,cmaker,cdefine1,cdefine2,cdefine10,bpufirst,darvdate,vt_id,bisstqc,ipurarriveid,itaxrate,iexchrate,cexch_name,bomfirst,idiscounttaxtype,iswfcontrolled,dnmaketime,dnmodifytime,dnverifytime,bredvouch,bcredit,iprintcount,
iverifystate ,cHandler, dVeriDate)
select *, 0, 'system', convert(char(10), getdate(), 121)
from #main

Insert Into rdrecord01_ExtraDefine(id)
select id from #main

Insert Into rdrecords01(autoid,id,cinvcode,inum,iquantity,iunitcost,iprice,iaprice,ipunitcost,ipprice,cbatch,cvouchcode,cinvouchcode,cinvouchtype,isoutquantity,isoutnum,cfree1,cfree2,dsdate,itax,isquantity,isnum,imoney,ifnum,ifquantity,dvdate,cposition,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citem_class,citemcode,iposid,facost,cname,citemcname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,cbarcode,inquantity,innum,cassunit,dmadedate,imassdate,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,cdefine36,cdefine37,icheckids,cbvencode,cgspstate,iarrsid,ccheckcode,icheckidbaks,crejectcode,irejectids,ccheckpersoncode,dcheckdate,ioritaxcost,ioricost,iorimoney,ioritaxprice,iorisum,itaxrate,itaxprice,isum,btaxcost,cpoid,cmassunit,imaterialfee,iprocesscost,iprocessfee,dmsdate,ismaterialfee,isprocessfee,iomodid,strcontractid,strcode,cbaccounter,dbkeepdate,bcosting,isumbillquantity,bvmiused,ivmisettlequantity,ivmisettlenum,cvmivencode,iinvsncount,impcost,iimosid,iimbsid,cbarvcode,dbarvdate,iinvexchrate,corufts,iexpiratdatecalcu,cexpirationdate,dexpirationdate,cciqbookcode,ibondedsumqty,iordertype,iorderdid,iordercode,iorderseq,isodid,isotype,csocode,isoseq,cbatchproperty1,cbatchproperty2,cbatchproperty3,cbatchproperty4,cbatchproperty5,cbatchproperty6,cbatchproperty7,cbatchproperty8,cbatchproperty9,cbatchproperty10,cbmemo,ifaqty,istax,irowno,strowguid,idebitids,ioldpartid,foldquantity,cbsysbarcode,bmergecheck,imergecheckautoid,creworkmocode,ireworkmodetailsid,iproducttype,cmaininvcode,imainmodetailsid,isharematerialfee,cplanlotcode,bgift,iposflag)
select * from #detail

--Insert Into rdrecords01_ExtraDefine(autoid)
--select autoid from #detail

-- now update the quantity
update rdrecords01 set corufts ='' where id in (select id from #main)

select a.id,autoid ,1 * convert (decimal(30,3),iquantity) as iquantity,1 * convert(decimal(30,3),inum) as iNum, 1 * iPrice as Imoney ,a.Cinvcode, Corufts  as Corufts, iArrsID,iPOsID,iOMoDID,iIMBSID,iIMOSID,isotype,iSoDid,iRejectIds,iCheckIdBaks ,csource,cbustype,iCheckIds,  bMergeCheck,iMergeCheckAutoId, 2 as iOperate   
into #Ufida_WBBuffers_PurchaseIn
from rdrecord01 b 
inner join rdrecords01 a on a.id=b.id 
where b.id in (select id from #main)

select max(id) as id,autoid,Sum(iquantity) as iquantity,sum(inum) as inum,sum(imoney) as imoney,max(cinvcode) as cinvcode ,Max(corufts) as corufts,  max(iArrsID) as iArrsID,max(iPOsID) as iPOsID,max(iOMoDID) as iOMoDID,max(iIMBSID) as iIMBSID ,max(iIMOSID) as iIMOSID, max(isotype) as isotype,max(iSoDid) as iSoDid,max(iRejectIds) as iRejectIds,max(iCheckIdBaks) as iCheckIdBaks , isnull(bMergeCheck,0) as bMergeCheck,max(iMergeCheckAutoId) as iMergeCheckAutoId,  max(csource) as csource,max(cbustype) as cbustype,sum(iOperate) as iOperate, case  sum(iOperate)  when 3 then N'M' when 2 then N'A' when 1 then N'D' end as editprop  
into  #Ufida_WBBuffers_PurchaseIn_ST 
from #Ufida_WBBuffers_PurchaseIn 
group by autoid,isnull(bMergeCheck,0)  
having (Sum(iquantity)<>0 or Sum(inum)<>0 or Sum(imoney)<>0)

select iArrsID as idID ,Sum(iquantity) as iquantity,sum(inum) as inum,sum(imoney) as imoney,0 as iBHGQuantity, 0 as iBHGnum,min(cinvcode) as cinvcode,min(corufts) as corufts ,0 as istflowid  
into #Ufida_WBBuffers_PurchaseIn_Target 
from #Ufida_WBBuffers_PurchaseIn_ST 
where isnull(iArrsID,0)<>0 
group by iArrsID

if (@debug > 0)
begin
	select '#target', * from #Ufida_WBBuffers_PurchaseIn_Target
end

 select CONVERT(DECIMAL(38,3),ISNULL(T1.fReceivedQTY,0))+CONVERT(DECIMAL(38,3),ISNULL(T2.iQuantity,0)), 
 CONVERT(DECIMAL(38,3),ISNULL(T1.fReceivedNum,0))+CONVERT(DECIMAL(38,3),ISNULL(T2.iNum,0)) 
 FROM Po_Podetails T1
 INNER JOIN (
	select sum(t2.iquantity) as iquantity,sum(t2.inum) as inum,iposid 
	from pu_arrivalvouchs 
	inner join  #Ufida_WBBuffers_PurchaseIn_Target AS T2 ON T2.idID=pu_arrivalvouchs.autoID 
	where isnull(iposid,0)<>0 group by iposid ) T2 on T2.iposid=t1.id
	

 UPDATE T1 
 SET  T1.fReceivedQTY=CONVERT(DECIMAL(38,3),ISNULL(T1.fReceivedQTY,0))+CONVERT(DECIMAL(38,3),ISNULL(T2.iQuantity,0)), 
 T1.fReceivedNum=CONVERT(DECIMAL(38,3),ISNULL(T1.fReceivedNum,0))+CONVERT(DECIMAL(38,3),ISNULL(T2.iNum,0)) 
 FROM Po_Podetails T1
 INNER JOIN (
	select sum(t2.iquantity) as iquantity,sum(t2.inum) as inum,iposid 
	from pu_arrivalvouchs 
	inner join  #Ufida_WBBuffers_PurchaseIn_Target AS T2 ON T2.idID=pu_arrivalvouchs.autoID 
	where isnull(iposid,0)<>0 group by iposid ) T2 on T2.iposid=t1.id

END