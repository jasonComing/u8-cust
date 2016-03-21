-- Add new row, change the quantity of the first row

create table #SoDetail
(
    cinvcode nvarchar(120),
    dpredate datetime,
    iquantity decimal(30, 10),
    iunitprice decimal(30, 10),
    isosid int,
    dpremodate datetime,
    irowno int,
    cbsysbarcode nvarchar(160),
    shipto nvarchar(120),
    sono nvarchar(120),
    polineno nvarchar(120),
    pono nvarchar(120),
    timeset nvarchar(240),
    shipmethod nvarchar(240),
    backtext nvarchar(200),
    id int
)
go
create procedure CustNewSoRows
    @changer nvarchar(40),
    @mainId int,
    @debug int = 0
as
begin

begin transaction;
begin try

    declare @detailRowCount int
    select @detailRowCount = count(*) from #SoDetail

    declare @ccuscode nvarchar(40)
    declare @csocode nvarchar(60)

    select
        @ccuscode = ccuscode,
        @csocode = csocode
    from So_SOMain
    where id = @mainId

    declare @p5 int
    declare @p6 int
    exec sp_getID '00','001','Somain',@detailRowCount, @p5 output,@p6 output
    --select @p5, @p6

    -- populate #SODetails
    declare @irowno int
    declare @p6Incrementer int
    set @p6Incrementer = 1

    declare d_cursor cursor
        for select irowno from #SODetail
    open d_cursor
    fetch next from d_cursor into @irowno

    while @@fetch_status = 0
    begin
        update #SoDetail
        set isosid = @p6 - @detailRowCount + @p6Incrementer        
        where irowno = @irowno

        set @p6Incrementer = @p6Incrementer + 1
        fetch next from d_cursor into @irowno
    end

    close d_cursor
    deallocate d_cursor

    update #SoDetail
    set cbsysbarcode=N'||SA17|' + m.csocode + '+''|' + convert(varchar(10), irowno)
    from #SoDetail d
    join SO_SOMain m on m.id = d.id
    where d.id = m.id

    if @debug > 0
    begin
        select 'SoDetail' as SoDetail, *
        from #SoDetail
    end

    Update SO_SOMain 
    SET 
        istatus=0, --狀態 未審核
        iverifystate=0, --審核狀態
        cchanger=@changer,
        cchangeverifier=Null,
        dchangeverifydate=Null,
        dchangeverifytime=Null,
        cverifier=isnull(cverifier,@changer),
        dverifydate=isnull(dverifydate, getdate()),
        dverifysystime=isnull(dverifysystime, getdate()),
        dmodifysystime = isnull(dmodifysystime, getdate())  --變更的訂單必需要填這個
    Where  ID = @mainId

    Insert Into SO_SODetails(cinvcode,dpredate,iquantity,inum,iquotedprice,iunitprice,itaxunitprice,imoney,itax,isum,idiscount,inatunitprice,inatmoney,inattax,inatsum,inatdiscount,ifhnum,ifhquantity,ifhmoney,ikpquantity,ikpnum,ikpmoney,cmemo,cfree1,cfree2,isosid,kl,kl2,cinvname,itaxrate,cdefine22,cdefine23,cdefine24,cdefine25,cdefine26,cdefine27,citemcode,citem_class,citemname,citem_cname,cfree3,cfree4,cfree5,cfree6,cfree7,cfree8,cfree9,cfree10,iinvexchrate,cunitid,id,cdefine28,cdefine29,cdefine30,cdefine31,cdefine32,cdefine33,cdefine34,cdefine35,fpurquan,fsalecost,fsaleprice,cquocode,iquoid,cscloser,dpremodate,irowno,icusbomid,imoquantity,ccontractid,ccontracttagcode,ccontractrowguid,ippartseqid,ippartid,ippartqty,ccusinvcode,ccusinvname,iprekeepquantity,iprekeepnum,iprekeeptotquantity,iprekeeptotnum,fcusminprice,fimquantity,fomquantity,ballpurchase,finquantity,foutquantity,iexchsum,imoneysum,iaoids,cpreordercode,fretquantity,fretnum,borderbom,borderbomover,idemandtype,cdemandcode,cdemandmemo,iimid,ccorvouchtype,icorrowno,busecusbom,body_outid,bsaleprice,bgift,forecastdid,cdetailsdemandcode,cdetailsdemandmemo,cbsysbarcode,fappqty,cparentcode,cchildcode,fchildqty,fchildrate,icalctype,csocode) 
    select 
    	d.cinvcode,  --cinvcode, 
        d.dpredate,  --dpredate, 
        iquantity,  --iquantity, 
        null,        --inum,
        0,           --iquotedprice,
        iunitprice,  --iunitprice, 
        iunitprice,  --itaxunitprice, 
        iquantity * iunitprice,  --imoney, 
        0,  --itax, 
        iquantity * iunitprice,  --isum, 
        0,  --idiscount, 
        iunitprice * m.iExchRate,  --inatunitprice, 
        d.iquantity * iunitprice * m.iExchRate,  --inatmoney, 
        0,  --inattax, 
        d.iquantity * d.iunitprice * m.iExchRate,  --inatsum, 
        0,  --inatdiscount, 
        Null,  --ifhnum, 
        Null,  --ifhquantity, 
        Null,  --ifhmoney, 
        Null,  --ikpquantity, 
        Null,  --ikpnum, 
        Null,  --ikpmoney, 
        Null,  --cmemo, 
        Null,  --cfree1, 
        Null,  --cfree2, 
        d.isosid,  --isosid, 
        100,  --kl, 
        100,  --kl2, 
        i.cinvname,  --cinvname, 
        0,  --itaxrate, 
        d.shipto,  --cdefine22, 
        d.sono,  --cdefine23, 
        d.polineno,  --cdefine24, 
        d.pono,  --cdefine25, 
        Null,  --cdefine26, 
        Null,  --cdefine27, 
        Null,  --citemcode, 
        Null,  --citem_class, 
        Null,  --citemname, 
        Null,  --citem_cname, 
        Null,  --cfree3, 
        Null,  --cfree4, 
        Null,  --cfree5, 
        Null,  --cfree6, 
        Null,  --cfree7, 
        Null,  --cfree8, 
        Null,  --cfree9, 
        Null,  --cfree10, 
        Null,  --iinvexchrate, 
        Null,  --cunitid, 
        m.id,  --id, 
        Null,  --cdefine28, 
        Null,  --cdefine29, 
        Null,  --cdefine30, 
        d.timeset,  --cdefine31, 
        d.shipmethod,  --cdefine32, 
        Null,  --cdefine33, 
        Null,  --cdefine34, 
        Null,  --cdefine35, 
        Null,  --fpurquan, 
        0,  --fsalecost, 
        0,  --fsaleprice, 
        Null,  --cquocode, 
        Null,  --iquoid, 
        Null,  --cscloser, 
        d.dpremodate,  --dpremodate, 
        d.irowno,  --irowno, 
        Null,  --icusbomid, 
        Null,  --imoquantity, 
        Null,  --ccontractid, 
        Null,  --ccontracttagcode, 
        Null,  --ccontractrowguid, 
        Null,  --ippartseqid, 
        Null,  --ippartid, 
        Null,  --ippartqty, 
        Null,  --ccusinvcode, 
        Null,  --ccusinvname, 
        Null,  --iprekeepquantity, 
        Null,  --iprekeepnum, 
        Null,  --iprekeeptotquantity, 
        Null,  --iprekeeptotnum, 
        0,  --fcusminprice, 
        Null,  --fimquantity, 
        Null,  --fomquantity, 
        0,  --ballpurchase, 
        Null,  --finquantity, 
        Null,  --foutquantity, 
        Null,  --iexchsum, 
        Null,  --imoneysum, 
        Null,  --iaoids, 
        Null,  --cpreordercode, 
        Null,  --fretquantity, 
        Null,  --fretnum, 
        0,  --borderbom, 
        0,  --borderbomover, 
        5,  --idemandtype, 
        Null,  --cdemandcode, 
        Null,  --cdemandmemo, 
        Null,  --iimid, 
        Null,  --ccorvouchtype, 
        Null,  --icorrowno, 
        0,  --busecusbom, 
        Null,  --body_outid, 
        0,  --bsaleprice, 
        0,  --bgift, 
        Null,  --forecastdid, 
        Null,  --cdetailsdemandcode, 
        Null,  --cdetailsdemandmemo, 
        d.cbsysbarcode,  --cbsysbarcode, 
        Null,  --fappqty, 
        Null,  --cparentcode, 
        Null,  --cchildcode, 
        Null,  --fchildqty, 
        Null,  --fchildrate, 
        Null, --icalctype,
        m.csocode
    from #SoDetail d
    join So_SOMain m on m.id = d.id
    join Inventory i on i.cInvCode = d.cinvcode


    insert into SO_SODetails_ExtraDefine (iSOsID, cbdefine1)
    select iSOsID, backtext
    from #SoDetail

    -- invoke the trigger to populate actual quantity and amount
    update SO_SODetails
    set csocode = csocode
    where isosid in (select isosid from #SoDetail)
 
    update SO_SODetails
    set csocode = csocode
    where isosid in (select isosid from #SoDetail)

    delete from SO_SOMain_User 
    where user_id=@changer
    and contract_id=@mainId

    insert into SO_SOMain_User (user_id,is_self,contract_id) values (@changer, 1,@mainId)


    update bom_orderbom 
    set orderseq=irowno 
    from bom_orderbom 
    inner join so_sodetails on bom_orderbom.OrderDId=so_sodetails.isosid 
    where OrderType=1 
    and id= @mainId

    Update customer 
    set bCusState =1 
    where ccuscode=@ccuscode
    and bCusState=0


    exec Usp_U8_VariationServer 'SO',@mainId,@csocode, 26,@changer,'Usp_SA_SOSaveVariation',9

    commit transaction
end try
begin catch
    rollback transaction
end catch

end
go

drop table #SoDetail