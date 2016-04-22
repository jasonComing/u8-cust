alter  PROCEDURE [dbo].[SP_PmcReport]
	 @Begindate  datetime =null ,
	 @Enddate   datetime =null
	  /*
	 ���ܣ�pmc���۶������ɹ�������Ϣ���ٱ���
	 auth:jams
	 ����ʵ����exec  SP_PmcReport '2016-01-01 00:00:01.000','2016-05-10 23:59:59.000'
	 */
AS
BEGIN
--����
	SET NOCOUNT ON
	if (@Begindate is null ) set @Begindate='2016-01-01 00:00:01.000'
	if (@Enddate is null ) set @Enddate=getdate()

	--ȡ��ʱ������Ҫ������������ж���,��������P��R���ȷ��õ��ݡ�ɢ������
	select SO_SOMain.cSocode 
	into #temptb1 
	from SO_SOMain left join  SO_SODetails on SO_SOMain.cSOCode=SO_SODetails.cSOCode
	where  (ddate between  @Begindate and  @Enddate)
	and (SO_SOMain.cSocode like 'J%') and(SO_SOMain.cSocode  not like '%SP')
	and (SO_SODetails.cInvCode  like 'D_%' OR SO_SODetails.cInvCode  like 'S_%')


 --ȡ�����۶�����Ҫ��Ϣ

	select  1 as 'RowType',Convert(varchar(10),a.dDate,23) as 'OrderDate',convert(varchar(10),b.dPreMoDate,23) as 'JobDate',
	convert(varchar(10),b.dPreDate,23) as 'ShipDate',e.cbdefine33 as 'CountryCode',b.cDefine22 as 'ShipWhere',b.cDefine23 as 'SapNO',
	b.cDefine25 as 'KePoNum',c.cCusAbbName as 'Custumer',d.cSTname as 'SaleType',f.chdefine9 as 'TeamName',
	f.chdefine26 as'SoType',b.csocode as 'OrderNum',b.iRowNo as 'RowNo', b.cinvCode as 'InvCode',
	h.cInvDefine1 as 'SkuNO',g.cidefine9 as 'Modle',h.cInvDefine9 as 'MoveMent',e.cbdefine1 as 'DiZi',
	b.cDefine32 as 'ShipWay',e.cbdefine30 as 'OrderQuantity',b.iKPQuantity  as 'KPQuantity'
	into #tbPMCmain
	from SO_SOMain a  left join SO_SODetails b on a.csoCode=b.csoCode
	left join Customer c on a.cCusCode=c.cCusCode
	left join SaleType d on a.cSTcode=d.cstcode
	left join SO_SODetails_extradefine e on b.isosid=e.isosid
	left join SO_SOMain_extradefine f on a.ID=f.ID
	left join Inventory_extradefine g on b.cinvCode=g.cinvCode
	left join Inventory h on b.cinvCode=h.cinvCode
	where a.csocode in(select cSocode  from #temptb1)
	and isnull(e.cbdefine30,0) > 0 
	order by a.dDate,c.cCusAbbName,a.csocode,b.cinvCode,b.iRowNo

 --select '���۶�������Ϣ', * from #tbPMCmain

 --�Զ����š��Ϻŷ���ͳ�ƶ�������
	select OrderNum,InvCode,sum(OrderQuantity)as OrderQuantity
	into #tbPMCmainSub
	from #tbPMCmain
	group by  OrderNum,InvCode order by OrderNum

	--�趨BOM�������(��о��������Ĵ�)
	create table #tb_order(
		CinvClass varchar(10),
		sortNum int,
		className varchar(10)
	)
	
 --ֻ�����������(��о���ǡ��桢�롢�ġ���)
	 insert into #tb_order(CinvClass,sortNum,className)
	 select '604',1,'�Cо' union
	 select '601',2,'��' union
	 select '607',3,'��' union
	 select '605',4,'��' union
	 select '603',5,'�' union
	 select '617',6,'�͵�' union
	 select '602',7,'��' union
	 select '619',8,'Ƥ��' union
	 select '622',9,'䓎�' union
	 select '658',9,'�W��' union
	 select '621',10,'�z��' union
	 select '623',11,'���C' union 
	 select '606',12,'��' union 
	 select '620',13,'����' union
	 select '609',14,'���w' 


 --ȡ��BOM��Ϣ,(���:�Hȡ�Cо���������,�Բɹ���Ա�����Ϻ�Ϊ׼.)
	select  h.InvCode as ParentInvCode, d.DInvCode as ChildInvCode, d.DInvName as ChildName,left(d.DInvCode,3) as invclass,tb.sortNum
	into #tb_bom
	from v_bom_head h
	join v_bom_detail_cust d on d.bomid = h.bomid
	left join Inventory_extradefine x on x.cInvCode = h.InvCode
	join  #tb_order tb on left(d.DInvCode,3)=tb.CinvClass
	where (h.InvCode in( select InvCode  from #tbPMCmain ))
	and d.DInvCode  like '604_%'
	order by h.InvCode,tb.sortNum

 --��������¼����BOM���ϲ�Ϊһ������ʾ
	select  a1.*,b2.ParentInvCode,b2.ChildInvCode,b2.ChildName,b2.sortNum
	into #tbPMCmainSubAndBom
	from #tbPMCmainSub a1 
	left join #tb_bom b2 on a1.InvCode=b2.ParentInvCode
	order by a1.InvCode,b2.ParentInvCode,b2.sortNum
	
	--select 'bom��',* from  #tbPMCmainSubAndBom

	--���ɹ�����+�Ϻ��г�PO�ɹ�����
	select a3.csocode,a3.cinvCode,a3.iQuantity,b3.cpoid ,a3.irowno,v3.cVenAbbName,left(a3.cinvCode,3) as 'invClass'
	into #tbPOmain
	from  PO_Podetails a3
	left join PO_Pomain b3 on  a3.poID=b3.poID
	left join #tb_order c3 on left(a3.cinvCode,3)=c3.CinvClass
	left join Vendor v3 on b3.cVenCode=v3.cVenCode
	where a3.csocode in(select cSocode from #temptb1)
	and (left(a3.cinvCode,3) in (select CinvClass  from #tb_order))
	order by a3.csocode,c3.sortNum
	
	--��ί�ⶩ��+�Ϻ��г�ί��ɹ�����
	select OM_MODetails.csocode as 'csocode',OM_MODetails.cinvCode as 'cinvCode',OM_MODetails.iquantity as 'iQuantity',
   OM_MOMain.cCode  as 'cpoid',OM_MODetails.iVouchRowNo as 'irowno' ,Vendor.cVenAbbName,left(OM_MODetails.cinvCode,3) as 'invClass'
	into #tbOMmain
	from OM_MODetails
	left join OM_MOMain on OM_MODetails.moid=OM_MOMain.moid
	left join Vendor on OM_MOMain.cVenCode=Vendor.cVenCode
	where (OM_MODetails.csocode in(select cSocode from #temptb1 ))
	and (left(OM_MODetails.cinvCode,3) in(select CinvClass  from #tb_order))
	order by OM_MODetails.csocode
	
	--�ϲ�PO�ɹ�����OMί�ⶩ����������ϼ�����
   select tbsub.csocode,tbsub.cinvCode,tbsub.cpoid,sum(iQuantity)as 'iQuantity',tbsub.cVenAbbName,left(tbsub.cinvCode,3) as 'invClass'
	into #tbPooMSum
	from (select * from #tbPOmain
		  union
		  select * from #tbOMmain
		  ) as tbsub
	group by tbsub.csocode,tbsub.cinvCode,tbsub.cpoid,tbsub.cVenAbbName,invClass
	
	--select'�ɹ�������Ϣ', * from #tbPooMSum order by csocode,cpoid
 

 --�г�JOB�����P�ϼ�(��JOB�Ų���,���������ѽ���PO�ε��ϼ�,ͬʱ,���ϻ�о)
	select OrderNum as 'jobNum',ChildInvCode as 'cinvcode' ,ChildName as 'cinvName',left(ChildInvCode,3) as 'classtype',sortNum  as 'sortNum'
	into #tbJobInvcode
	from #tbPMCmainSubAndBom 
	union
		select csocode as 'jobNum',Inventory.cinvCode  as 'cinvcode',Inventory.cInvName as 'cinvName',left(Inventory.cinvCode,3) as 'classtype',
				#tb_order.sortNum as 'sortNum'
		from  #tbPooMSum 
		left join Inventory on	#tbPooMSum.cinvCode=Inventory.cInvCode
		join #tb_order on left(#tbPooMSum.cinvCode,3)=#tb_order.CinvClass

	--select 'ӆ��������̖', * from  #tbJobInvcode
	--left join #tb_order on #tbJobInvcode.classtype=#tb_order.CinvClass 
	--order by jobNum,#tb_order.sortNum 

	--��ՁK���job̖�c���P��̖�P�B��,��ͬ��BOM��
	truncate table #tbPMCmainSubAndBom

	insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
	 select OrderNum,	InvCode,OrderQuantity,'',cinvcode,cinvName,sortNum
	 from #tbPMCmainSub
	 right join #tbJobInvcode on  #tbPMCmainSub.OrderNum=#tbJobInvcode.jobNum
	 order by #tbPMCmainSub.OrderNum,#tbJobInvcode.sortNum

  --select 'job�c��̖',* from  #tbPMCmainSubAndBom


 --���ɹ�����/ί�ⶩ��+�Ϻ��г� ��������0,�˴�����1��������2����ibilltype�� ��
	select a4.cordercode,b4.ccode,a4.cinvCode,a4.iquantity,b4.ibilltype
	into #tbArr
	from  PU_ArrivalVouchs a4
	left join PU_ArrivalVouch b4 on a4.ID=b4.ID
	where (left(a4.cinvCode,3) in(select CinvClass  from #tb_order))
	and (a4.cordercode in (select distinct cpoid from #tbPooMSum ))
	order by a4.cordercode
	
	 --select '��������Ϣ',* from  #tbArr

	 --���ɹ�����+�Ϻ��г��ɹ��������
	select a5.csocode,a5.cPOID,a5.cinvCode,a5.iquantity,b5.cCode  ---���۶�����PO���Ϻš���������ⵥ��
	into #tbRd
	from  RdRecords01 a5
	left join RdRecord01 b5  on a5.ID=b5.ID
	where (a5.cPOID  in (select distinct cpoid from #tbPooMSum))
	and  (left(a5.cinvCode,3)  in (select CinvClass  from #tb_order))
	
 --select '�ɹ������Ϣ',* from  #tbRd
	
	--�г�����������Ϣ
	--ȡ��ͷ������JOB��(�ڳ�����)
	select b6.define2 as 'socode',a6.invCode,a6.Qty,b6.MoCode,b6.CreateDate
	into #tbRD01
	from mom_orderdetail  a6
	left join  mom_order b6 on a6.moid=b6.moid
	where (b6.define2 in (select cSocode from #temptb1))
	and (a6.invCode like 'D_%' or a6.invCode like 'S_%')

 --ȡ������ٺŰ�����JOB��
 	select a6.SoCode as 'socode',a6.invCode,a6.Qty,b6.MoCode,b6.CreateDate
	into #tbRD02
	from mom_orderdetail  a6
	left join  mom_order b6 on a6.moid=b6.moid
	where (a6.SoCode in (select cSocode from #temptb1))
	and (a6.invCode like 'D_%' or a6.invCode like 'S_%')
	
 --�ϲ�RD����������
   select tbRd.* 
	into #tbRDsub
	from  (select * from  #tbRD01
	union
	select * from  #tbRD02) as tbRd
	
 --select '��������', * from #tbRDsub
 
	--����Ʒ�����Ϣ
	select a7.cmocode,a7.cinvCode,a7.iquantity,b7.cCode
	into #rdrecordin
	from rdrecords10 a7
	left join rdrecord10 b7 on  a7.ID=b7.ID
	where a7.cmocode in(select MoCode from #tbRDsub)
	and (a7.cinvCode like 'D_%' or a7.cinvCode like 'S_%')

 --select '����Ʒ�����Ϣ',* from #rdrecordin

  --���۶�����Ʊ
	select a8.cordercode,a8.iorderrowno,a8.cinvCode,a8.iquantity,b8.cSBVCode,a8.irowno,b8.dDate 
	into #tbSaleBillVouchSub
	from SaleBillVouchs a8
	left join SaleBillVouch  b8 on a8.SBVID=b8.SBVID
	where (a8.cordercode in (select cSocode from #temptb1))
	and (a8.cinvCode like 'D_%' or a8.cinvCode like 'S_%')
	order by b8.cSBVCode,a8.irowno
	
  --select '���۶�����Ʊ��Ϣ',* from #tbSaleBillVouchSub order by cordercode
 
 --����Ʒ���۳�����Ϣ
	 select a9.iordercode,a9.cInvCode,a9.iquantity,b9.cCode,b9.dDate
	 into #tbrdrecords
	 from rdrecords32 a9
	 left join rdrecord32 b9 on b9.id=a9.id
	 where a9.iordercode in (select cSocode from #temptb1)
	 order by a9.iordercode
 
	--select '���۶����߻���Ϣ',* from #tbrdrecords order by iordercode
  
 --���������

	 CREATE TABLE #tbResult(
		 ID [int] IDENTITY(1,1) NOT NULL,
		 RowType [varchar](10) NULL,
		 OrderDate [datetime] NULL,
		 JobDate [datetime] NULL,
		 ShipDate [datetime] NULL,
		 CountryCode [nvarchar](30) NULL,
		 ShipWhere [nvarchar](30) NULL,
		 SapNO [nvarchar](30) NULL,
		 KePoNum [nvarchar](30) NULL,
		 Custumer [nvarchar](60) NULL,
		 SaleType [nvarchar](20) NULL,
		 TeamName [nvarchar](30) NULL,
		 SoType [nvarchar](20) NULL,
		 OrderNum [nvarchar](30) NULL,
		 RowNo [int] NULL,
		 InvCode [nvarchar](30) NULL,
		 SkuNO [nvarchar](30) NULL,
		 Modle [nvarchar](20) NULL,
		 MoveMent [nvarchar](200) NULL,
		 DiZi [nvarchar](100) NULL,
		 ShipWay [nvarchar](120) NULL,
		 OrderQuantity [float] NULL,
		 KPQuantity [float] NULL,
		 ParentInvCode [nvarchar](30) NULL,
		 ChildInvCode [nvarchar](30) NULL,
		 InvName [nvarchar](300) NULL,
		 StockLock [float] NULL,
		 StockFree [float] NULL,
		 Venter [varchar](100) NULL,
		 PoNum [varchar](20) NULL,
		 PoQuantity [float] NULL,
		 ArrQuantitySum [float] NULL,
		 ArrReturSum [float] NULL,
		 RdInStoreSum [float] NULL,
		 RdUninSum [float] NULL,
		 ArrDate [datetime] NULL,
		 MDorderDate [datetime] NULL,
		 MDorderNum [varchar](20) NULL,
		 MDordeQuantity [float] NULL,
		 Qcdate [datetime] NULL,
		 Qcquantity [float] NULL,
		 QCpassQuantity [float] NULL,
		 QcreturnQuantity [float] NULL,
		 FinishedGoodSum [float] NULL,
		 UnshipQuantity [float] NULL,
		 ShipedQuantity [float] NULL,
		 ShipRecord [varchar](max) NULL,
		 SaleBillRecord [varchar](max) NULL
	)

	----����������Ϣ�����۶�����������Ϣ
	insert into #tbResult(RowType,OrderDate,JobDate,ShipDate,CountryCode,ShipWhere,SapNO,KePoNum,Custumer,
			SaleType,TeamName,SoType,OrderNum,RowNo,InvCode,SkuNO,Modle,MoveMent,DiZi,ShipWay,OrderQuantity,KPQuantity,
			ParentInvCode,ChildInvCode,InvName,StockLock,StockFree,Venter,PoNum,PoQuantity,ArrQuantitySum,ArrReturSum,RdInStoreSum,RdUninSum,ArrDate,
			MDorderDate,MDorderNum,MDordeQuantity,
			Qcdate,Qcquantity,QCpassQuantity,QcreturnQuantity,FinishedGoodSum,
			UnshipQuantity,ShipedQuantity,ShipRecord,
			SaleBillRecord)
		select #tbPMCmain.*,
		'','','','','','','','','','','','',null,
		null,'','',
		null,'','','','',
		'','','',
		''
		from #tbPMCmain

				
 ---����JOB���л��ܱ�,JOB+�Ϻŷ���ͳ��,
	 declare @orderdate date ,@custumer nvarchar(100)
	 declare @jobNum varchar(20),@invCode varchar(30),@iROWnum int
	 declare @jobNum2 varchar(20),@invCode2 varchar(30)
	 declare @QuantitySum int
	 declare @childInvcode varchar(20)
	 declare @childInvName Nvarchar(100)
	 declare my_cursor cursor for
			select distinct OrderNum,InvCode from #tbPMCmain  
	 open my_cursor
	 
	 fetch next from my_cursor into @jobNum, @invCode
	 set @jobNum2=@jobNum   
	 set @invCode2=@invCode
	 while @@FETCH_STATUS = 0
	 begin
	    if not ( @jobNum2=@jobNum and @invCode2=@invCode  )
		 begin
			
				--������,��Ʒ�Ϻ�,sum(������)as ��������
				select @QuantitySum =isnull(OrderQuantity,0) from #tbPMCmainSub where OrderNum=@jobNum2 and InvCode=@invCode2
				select top 1 @orderdate = kk.OrderDate,@custumer = kk.Custumer 
				from #tbPMCmain as kk where OrderNum=@jobNum2 and InvCode=@invCode2 and RowType=1

				--�����ߴ����
				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='601' or left(ChildInvCode,3)='607' ))
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'2-��','-','',2)
				
			   if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='605') )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'3-��','-','',3)

				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='603') )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'4-��','-','',4)

				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='617') )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'5-�͵�','-','',5)

				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='602' or left(ChildInvCode,3)='619' 
							or left(ChildInvCode,3)='622' or left(ChildInvCode,3)='658' or left(ChildInvCode,3)='621' or left(ChildInvCode,3)='623') )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'6-��','-','',6)

				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='606'  or left(ChildInvCode,3)='620' ) )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'7-��','-','',7)

				if not EXISTS(select * from #tbPMCmainSubAndBom 
							where OrderNum=@jobNum and  InvCode=@invCode  and ( left(ChildInvCode,3)='609') )
				insert into #tbPMCmainSubAndBom(OrderNum,InvCode,OrderQuantity,ParentInvCode,ChildInvCode,ChildName,sortNum)
				values(@jobNum,@invCode,@QuantitySum,'8-���w','-','',8)
	
				insert into #tbResult(RowType,OrderDate,ShipDate,ShipWhere,SapNO,kePoNum,Custumer,
				SaleType,TeamName,SoType,OrderNum,RowNo,InvCode,SkuNO,Modle,MoveMent,DiZi,ShipWay,OrderQuantity,KPQuantity,
				ParentInvCode,ChildInvCode,InvName,StockLock,StockFree,Venter,PoNum,PoQuantity,ArrQuantitySum,ArrReturSum,RdInStoreSum,RdUninSum,ArrDate,
				MDorderDate,MDorderNum,MDordeQuantity,
				Qcdate,Qcquantity,QCpassQuantity,QcreturnQuantity,FinishedGoodSum,
				UnshipQuantity,ShipedQuantity,ShipRecord,
				SaleBillRecord)
				select  2,@orderdate,null,'','','',@custumer,
				'','','',@jobNum2,'99',@invCode2,'','','','','',@QuantitySum,'',
				ParentInvCode,ChildInvCode,ChildName,'','','','','','','','','',NULL,
				NULL,'','',
				NULL,'','','','',
				'','','',
				''
				from #tbPMCmainSubAndBom
				where #tbPMCmainSubAndBom.OrderNum=@jobNum2 and #tbPMCmainSubAndBom.InvCode=@invCode2
				order by  #tbPMCmainSubAndBom.sortNum

				 set @jobNum2=@jobNum
				 set @invCode2=@invCode
			end
		fetch next from my_cursor into @jobNum, @invCode
	end
	close my_cursor
	deallocate my_cursor



 --���²ɹ���Ϣ
		update #tbResult set Venter=isnull(#tbPooMSum.cVenAbbName,''),
			PoNum=isnull(#tbPooMSum.cPOID,''),
			PoQuantity=isnull(#tbPooMSum.iQuantity,0),
			ArrQuantitySum=isnull(tbarrSub.iquantity,0),
			ArrReturSum=isnull(tbarrReturnSub.iquantity,0),
			RdInStoreSum=isnull(tbRdsub.iquantity,0),
			RdUninSum=isnull(#tbPooMSum.iQuantity - tbRdsub.iquantity,0) ,
			ArrDate=NULL
		from #tbResult
		left join #tbPooMSum on (#tbResult.OrderNum=#tbPooMSum.csocode and #tbResult.ChildInvCode=#tbPooMSum.cInvCode )
		left join (select cordercode,cinvCode,ibilltype,sum(iquantity) as 'iquantity' 
			from #tbArr
			where ibilltype=0
			group by cordercode,cinvCode,ibilltype) as tbarrSub
		on (#tbPooMSum.cPOID=tbarrSub.cordercode and #tbPooMSum.cInvCode= tbarrSub.cInvCode)
		left join (select cordercode,cinvCode,ibilltype,sum(iquantity) as 'iquantity' 
				from #tbArr
				where ibilltype=1 or ibilltype=2
				group by cordercode,cinvCode,ibilltype) as tbarrReturnSub
		on (#tbPooMSum.cPOID=tbarrReturnSub.cordercode and #tbPooMSum.cInvCode= tbarrReturnSub.cInvCode)
		left join (select #tbRd.csocode,#tbRd.cPOID,#tbRd.cinvCode,sum(iquantity) as 'iquantity'
				from #tbRd group by csocode,cPOID,cinvCode ) as tbRdsub
	on (tbRdsub.csocode=#tbPooMSum.csocode
	and tbRdsub.cInvCode=#tbPooMSum.cInvCode
	and tbRdsub.cPOID= #tbPooMSum.cpoid )
	where #tbResult.RowType=2
		
				 
 --ȡ��С��ID,��λ��������������λ��
	select min(id) as 'minid', OrderNum,InvCode into #tbidsub 
	from #tbResult where #tbResult.RowType=2 
	group by #tbResult.OrderNum,#tbResult.InvCode

 --������ʱ��,�������������¼������ID�������
   create table #tbRdrecord2
	(
	 id bigint,
	 jobno varchar(20),
	 invcode varchar(20),
	 Rdnum varchar(20),
	 RdQuantity float,
	 Rddate datetime
	  )


 declare @MinId bigint ,@RdNum varchar(20),@RdQuantity int,@Rddate datetime  --���������ţ�����
 declare @Reflowid int --���������м�¼��
 
 --����������۶�������������
   declare cursor2 cursor for
		select minid,OrderNum,InvCode from #tbidsub

	open cursor2
	fetch next from cursor2 into @MinId,@jobNum,@invCode
	while @@FETCH_STATUS = 0
	begin
			--LOOP��
		   set @Reflowid=0
			declare cursor3 cursor for
			    select MoCode,Qty,CreateDate from #tbRDsub where #tbRDsub.socode=@jobNum and invCode=@invCode
	      
			open cursor3
			fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			while @@FETCH_STATUS = 0
			begin
			    set @Reflowid=@Reflowid+1 --
				 insert into #tbRdrecord2(id,jobno,invcode,Rdnum,RdQuantity,Rddate)  
						select (@Reflowid+@MinId),@jobNum,@invCode,@RdNum,@RdQuantity,convert(varchar(10),@Rddate,23)
			
			fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			end
			
			close cursor3
			deallocate cursor3
	fetch next from cursor2 into @MinId,@jobNum,@invCode
	end

	close cursor2
	deallocate cursor2


 --������������
 
	 update #tbResult set MDorderDate=isnull(#tbRdrecord2.Rddate,''),
		 MDorderNum=isnull(#tbRdrecord2.Rdnum,''),
		 MDordeQuantity=cast(isnull(#tbRdrecord2.RdQuantity,0) as int)
	 from #tbResult
	 join #tbRdrecord2 on #tbResult.id=#tbRdrecord2.id
	 where #tbResult.OrderNum = #tbRdrecord2.jobno
	 and #tbResult.RowType=2
 

 ----������ʱ��,������۳����¼������ID�������
   create table #tbRdrecord3
	(
	 jobno varchar(20),
	 invcode varchar(20),
	 Rdrecodes varchar(max)
	  )


	--��ȡ���۳�����Ϣ,����ת��--������ʾ
	declare @strRecord varchar(2000)
	declare cursor2 cursor for
			select DISTINCT  iordercode,cInvCode 	from #tbrdrecords group by iordercode,cInvCode

	open cursor2
	fetch next from cursor2 into @jobNum,@invCode
	while @@FETCH_STATUS = 0
	begin
			--LOOP��
			set @strRecord =''
			declare cursor3 cursor for
			    select cCode,iquantity,dDate from #tbrdrecords where #tbrdrecords.iordercode=@jobNum and cInvCode=@invCode order by  dDate desc
			open cursor3
			fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			while @@FETCH_STATUS = 0
			begin
			    set @strRecord= stuff(', ; '+@strRecord, 1, 1, '����:'+@RdNum+'  ����:'+cast(@RdQuantity as varchar(10))+' ��������:'+Convert(varchar(10),@Rddate,23))

				fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			end
			close cursor3
			deallocate cursor3

			insert into #tbRdrecord3(jobno,invcode,Rdrecodes)  
						select @jobNum,@invCode,@strRecord

	fetch next from cursor2 into @jobNum,@invCode
	end

	close cursor2
	deallocate cursor2

  ---�����߻���Ϣ��¼
	update #tbResult set shiprecord=#tbRdrecord3.Rdrecodes
	from #tbResult
	join #tbRdrecord3 on( #tbResult.OrderNum=#tbRdrecord3.jobno and  #tbResult.InvCode=#tbRdrecord3.invcode)
	join #tbidsub on (#tbResult.OrderNum=#tbidsub.OrderNum and #tbResult.InvCode=#tbidsub.InvCode and #tbResult.ID= #tbidsub.minid)
	where #tbResult.RowType=2  
	
	--=========================
	truncate table #tbRdrecord3
	--��ȡ��Ʊ��Ϣ,����ת��--������ʾ
	declare cursor2 cursor for
			select DISTINCT  cordercode,cinvCode 	from #tbSaleBillVouchSub group by cordercode,cinvCode
	open cursor2
	fetch next from cursor2 into @jobNum,@invCode
	while @@FETCH_STATUS = 0
	begin
			--LOOP��
			set @strRecord =''
			declare cursor3 cursor for
			    select cSBVCode,iquantity,dDate from #tbSaleBillVouchSub where #tbSaleBillVouchSub.cordercode=@jobNum and cinvCode=@invCode order by  dDate desc
			open cursor3
			fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			while @@FETCH_STATUS = 0
			begin
			    set @strRecord= stuff(', ; '+@strRecord, 1, 1, '����:'+@RdNum+'  ����:'+cast(@RdQuantity as varchar(10))+' ����:'+Convert(varchar(10),@Rddate,23))

				fetch next from cursor3 into @RdNum,@RdQuantity,@Rddate
			end
			close cursor3
			deallocate cursor3

			insert into #tbRdrecord3(jobno,invcode,Rdrecodes)  
						select @jobNum,@invCode,@strRecord

	fetch next from cursor2 into @jobNum,@invCode
	end

	close cursor2
	deallocate cursor2

  ---���·�Ʊ��Ϣ��¼
	update #tbResult set saleBillrecord=#tbRdrecord3.Rdrecodes
	from #tbResult
	join #tbRdrecord3 on( #tbResult.OrderNum=#tbRdrecord3.jobno and  #tbResult.InvCode=#tbRdrecord3.invcode)
	join #tbidsub on (#tbResult.OrderNum=#tbidsub.OrderNum and #tbResult.InvCode=#tbidsub.InvCode and #tbResult.ID= #tbidsub.minid)
	where #tbResult.RowType=2

  --���¿����/���ɿ����
  --step1,ȡ�����ɿ��
	select cInvCode,sum(iQuantity)as 'iQuantity' 
	into #StockFree	
	from CurrentStock
	where  cWhCode in('03','04','06','07','08','14','21')     --�ų����Ͽ����
	and len(iSodid)=0
	and isnull(iQuantity,0) > 0
	group by cInvCode
	
	--Step2,ȡ�������󶨵Ŀ����
	select iSodid,cInvCode,sum(iQuantity)  as 'iQuantity'
	into #StockLock  	
	from CurrentStock
	where  cWhCode in('03','04','06','07','08','14','21')
	and len(iSodid) > 0
	and isnull(iQuantity,0) > 0
	group by iSodid,cInvCode

	--��������-�󶨵Ŀ��
	update #tbResult 
			set StockLock=#StockLock.iQuantity
	from #tbResult	
	join #StockLock on #tbResult.OrderNum = #StockLock.iSodid and #tbResult.ChildInvCode = #StockLock.cInvCode
	where #tbResult.RowType=2

	--��������-���ɿ��
	update #tbResult 
			set  StockFree=#StockFree.iQuantity
	from #tbResult join  #StockFree	on  #tbResult.ChildInvCode = #StockFree.cInvCode
	where #tbResult.RowType=2

	--�г�D_GENERAL��̖�Ă��]�f��
	update #tbResult set #tbResult.InvName=SO_SODetails.cMemo
	from #tbResult 
	join SO_SODetails on(#tbResult.OrderNum=SO_SODetails.csocode and #tbResult.RowNo=SO_SODetails.iRowNo )
	where #tbResult.RowType=1 and #tbResult.InvCode='D_GENERAL'

	--��ȡ�ϼ���������,���
	update #tbResult 
			set #tbResult.ParentInvCode=(
				CASE WHEN (left(ChildInvCode,3) = '604' ) THEN '1-�Cо'
				WHEN (left(ChildInvCode,3) = '601' or left(ChildInvCode,3) = '607' ) THEN '2-��'
				WHEN (left(ChildInvCode,3) = '605' ) THEN '3-��'
				WHEN (left(ChildInvCode,3) = '603' ) THEN '4-�'
				WHEN (left(ChildInvCode,3) = '617' ) THEN '5-�͵�'
				WHEN (left(ChildInvCode,3) = '602' or left(ChildInvCode,3) = '619' or left(ChildInvCode,3) = '622'
								or left(ChildInvCode,3) = '658' or left(ChildInvCode,3)='621' or left(ChildInvCode,3) = '623') THEN '6-��'
				WHEN (left(ChildInvCode,3) = '606' or left(ChildInvCode,3) = '620' ) THEN '7-��'
				WHEN (left(ChildInvCode,3) = '609' ) THEN '8-���w'
				ELSE '' END)
	from #tbResult 
	where #tbResult.RowType=2 and #tbResult.ChildInvCode like '6%'

 --��ѯ��ʾ�����
 select * from #tbResult  order by OrderNum,RowNo,ParentInvCode

SET NOCOUNT OFF

END

