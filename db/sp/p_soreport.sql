SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sysobjects where id = object_id('dbo.p_SOprint') )
        drop procedure dbo.p_SOprint
go

CREATE PROCEDURE [dbo].[p_SOprint]   --   exec p_SOprint 'JOB160200006'    exec p_SOprint 'J160200002'
	@DocNo varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	insert into a(Str,b) select 'exec p_SOprint '''+@DocNo+'''',getdate()  --  select * from a     delete a

	declare @ModelName varchar(500)
	declare @PicPath varchar(500)
	set @PicPath='C:\U8Print\Pic\P'

	if ''='测试用'
	begin
		select @ModelName as ModelName,'T' as Lei,1 as X,1 as Y,'asdfasdf1' as S,null as P,'' as PicName,0 as W union all
		select @ModelName as ModelName,'T' as Lei,1 as X,2 as Y,'asdfasdf2' as S,null as P,'' as PicName,0 as W union all
		select @ModelName as ModelName,'T' as Lei,1 as X,3 as Y,'asdfasdf3' as S,null as P,'' as PicName,0 as W union all
		select @ModelName as ModelName,'T' as Lei,1 as X,4 as Y,'aaaaaaaaa' as S,null as P,'' as PicName,0 as W union all
		select @ModelName as ModelName,'P' as Lei,0 as X,100 as Y,'' as S,Picture as P,@PicPath+replace(cast(newid() as varchar(50)),'-','')+'.jpg' as PicName,40 as W from AA_Picture where cGUID='E845615A-92C5-4E7B-B926-7B5ECB1BFA77' union all
		select @ModelName as ModelName,'P' as Lei,100 as X,100 as Y,'' as S,Picture as P,@PicPath+replace(cast(newid() as varchar(50)),'-','')+'.jpg' as PicName,40 as W from AA_Picture where cGUID='60D83BF2-1C25-43FC-A914-A60DE49E54A7'
    end

	if ''!='变量'
	begin
		declare @t table(ModelName varchar(50),Lei varchar(1),X int,Y int,S varchar(1000),P Image,PicName varchar(100),W int,Xall varchar(50))
		declare @i int
		declare @rowNo int
		declare @id int
		declare @cMaker varchar(500)--制单人
		declare @SP varchar(500)--士啤
		declare @JobNo varchar(500)--JobNo
		declare @IsNew varchar(500)--是否新品
		declare @shoukuan varchar(500)--收款
		declare @Cur varchar(500)--客户
		declare @bq varchar(500)--辦期
		declare @Date varchar(500)--开单日期
		declare @Edit varchar(500)--修改说明文字
		declare @Memo varchar(1000)--备注
		declare @bzMemo varchar(1000)--包装备注
		declare @CreateTime varchar(500)--建立时间
		declare @cInvCode varchar(500)--存货编码
		declare @cInvName varchar(500)--存货名称
		declare @iQuantity varchar(500)--数量
		declare @BomStr varchar(8000)--BOM描述
		declare @ResponsibleBy varchar(100)--負責人
	end
	if ''!='普通直填文字赋值与填写'
	begin
		select   @cMaker=a.cMaker
				,@SP=a.cDefine11--'士啤文字待定'
				,@JobNo=a.cSOCode
				,@IsNew=a.cDefine8--'否待定'
				,@Cur=d.cCusAbbName--a.cCusName
				,@bq=a.cDefine13--'辦期文字待定'
				,@Date=convert(varchar(100),a.dDate,23) 
				,@Edit=b.chdefine3
				,@Memo=a.cMemo
				,@bzMemo=b.chdefine2--'包装备注文字待定'
				,@CreateTime=convert(varchar(100),a.dDate,105)
				,@id=a.ID
				,@shoukuan=c.cName
				,@ResponsibleBy=b.chdefine9
		from SO_SOMain a left join SO_SOMain_extradefine b on a.ID=b.ID
		left join AA_Agreement c on a.cgatheringplan=c.cCode
		left join Customer d on a.cCusCode=d.cCusCode
		where a.cSOCode=@DocNo

		select @cInvCode=min(cInvCode),@cInvName=min(cInvName),@iQuantity=sum(iQuantity)
		from SO_SODetails where ID in(select ID from SO_SOMain where cSOCode=@DocNo)


		--直接填写文字
		insert into @t(Lei,X,Y,S) select 'T',4 ,1,@cMaker --制单人
		insert into @t(Lei,X,Y,S) select 'T',7 ,1,@SP --士啤
		insert into @t(Lei,X,Y,S) select 'T',11,1,@JobNo --JobNo
		insert into @t(Lei,X,Y,S) select 'T',2 ,2,@IsNew --是否新品
		insert into @t(Lei,X,Y,S) select 'T',2 ,3,@shoukuan --收款
		insert into @t(Lei,X,Y,S) select 'T',4 ,2,@Cur --客户
		insert into @t(Lei,X,Y,S) select 'T',7 ,2,@bq --辦期
		insert into @t(Lei,X,Y,S) select 'T',11,3,@ResponsibleBy --負責人
		insert into @t(Lei,X,Y,S) select 'T',11,2,@Date --开单日期
		insert into @t(Lei,X,Y,S) select 'T',1,29,@Memo --备注
		insert into @t(Lei,X,Y,S) select 'T',7,29,@bzMemo --包装备注
		insert into @t(Lei,X,Y,S) select 'T',7,60,@CreateTime --建立时间
		insert into @t(Lei,X,Y,S) select 'T',6, 5,@cInvCode --存货编码
		insert into @t(Lei,X,Y,S) select 'T',11,5,@iQuantity --数量
	end
	if ''!='BOM相关'
	begin
		if ''!='缓存BOM资料'
		begin
			--第一层BOM
			select left(f.cInvCode,3) as Class,f.cInvCode,f.cInvName,g.cInvCName,
				-- change \n to line break
				replace(ff.cidefine3, '\n', char(13)+char(10)) as Lz,
				ff.cidefine13 as Ms,h.Picture
			into #a
			from bas_part a 
			inner join bom_parent b on b.parentid=a.PartId and a.InvCode=@cInvCode--'D_NY2402'
			inner join bom_bom c on b.BomId=c.BomId
			inner join Bom_opcomponent d on d.BomId=c.BomId
			inner join bas_part e on d.ComponentId=e.PartID
			inner join Inventory f on e.InvCode=f.cInvCode --and f.cInvCCode in('604','602','609','605','603','617')                  --and (f.cInvCode like '605%' or f.cInvCode like '609%') --and (f.cInvName like '%面%' or f.cInvName like '%底蓋%')
			left join Inventory_extradefine ff on f.cInvCode=ff.cInvCode
			left join InventoryClass g on f.cInvCCode=g.cInvCCode
			left join AA_Picture h on f.PictureGUID=h.cGUID
			where c.CloseDate is null;
			--第二层BOM
			select aa.cInvCode as PcInvCode,aa.cInvName as PcInvName,f.cInvCode,f.cInvName,g.cInvCName
			into #b
			from bas_part a inner join #a aa on a.InvCode=aa.cInvCode and aa.cInvCode not like 'P_%'
			inner join bom_parent b on b.parentid=a.PartId
			inner join bom_bom c on b.BomId=c.BomId
			inner join Bom_opcomponent d on d.BomId=c.BomId
			inner join bas_part e on d.ComponentId=e.PartID
			inner join Inventory f on e.InvCode=f.cInvCode
			left join InventoryClass g on f.cInvCCode=g.cInvCCode
			where c.CloseDate is null;
		end
		if ''!='层级BOM字符串组装与填写'
		begin
			set @BomStr='第一層'+dbo.f_hr()+@cInvCode--'D_AX2100'--
			select @BomStr=@BomStr+dbo.f_hr()+cInvCode+'  '+cInvName from #a where cInvCode not like 'P_%'
			set @BomStr=@BomStr+dbo.f_hr()+'第二層'
			set @i=1
			select row_number() over(order by PcInvCode) as i,PcInvCode,PcInvName into #c from (select distinct PcInvCode,PcInvName from #b) aa
			while exists(select top 1 1 from #c where i=@i)
			begin
				if @i>1 set @BomStr=@BomStr+dbo.f_hr()
				select @BomStr=@BomStr+dbo.f_hr()+PcInvCode+'  '+PcInvName from #c where i=@i
				select @BomStr=@BomStr+dbo.f_hr()+cInvCode+'  '+cInvName from #b where PcInvCode in(select PcInvCode from #c where i=@i)
				set @i=@i+1
			end;
			insert into @t(Lei,X,Y,S) select 'T',10,32,@BomStr --BOM展示填写
		end;
		if ''!='图片填写'
		begin
			if exists(select b.Picture from Inventory a inner join AA_Picture b on a.PictureGUID=b.cGUID where a.cInvCode=@cInvCode)
			begin
				insert into @t(Lei,X,Y,P,W,PicName) select 'P',  10,1250-300,b.Picture,180,@PicPath+replace(cast(newid() as varchar(50)),'-','')+'.jpg' from Inventory a inner join AA_Picture b on a.PictureGUID=b.cGUID where a.cInvCode=@cInvCode
			end;
			if exists(select Picture from #a where cInvCode like'605%' and Picture is not null)
			begin
				insert into @t(Lei,X,Y,P,W,PicName) select 'P', 350,1250-300,  Picture,180,@PicPath+replace(cast(newid() as varchar(50)),'-','')+'.jpg' from #a where cInvCode like'605%'
			end;
			if exists(select Picture from #a where cInvCode like'609%' and Picture is not null)
			begin
				insert into @t(Lei,X,Y,P,W,PicName) select 'P', 700,1250-300,  Picture,180,@PicPath+replace(cast(newid() as varchar(50)),'-','')+'.jpg' from #a where cInvCode like'609%'
			end;
		end
		if ''!='产品规格表格数据填写'
		begin
			--cInvCode,cInvName,cInvCName,Lz,Ms
			set @rowNo=33
			select @rowNo+ROW_NUMBER() OVER(order by case when Class='604' then 2 when Class='607' then 3 when Class='602' then 4 when Class='609' then 5 when Class='605' then 6 when Class='603' then 7 when Class='617' then 8 else 9 end) AS OrderByNo
				,cInvCode,cInvCName,cInvName,Lz,Ms
			into #d
			from #a where Class in('604','607','602','609','605','603','617')

			update a set a.Ms= case when isnull(b.cidefine4,'')='' then '' else '物料:'+isnull(b.cidefine4,'')+dbo.f_hr() end
							  +case when isnull(b.cidefine5,'')='' then '' else '光令:'+isnull(b.cidefine5,'')+dbo.f_hr() end
							  +case when isnull(b.cidefine6,'')='' then '' else '打沙:'+isnull(b.cidefine6,'')+dbo.f_hr() end
							  +case when isnull(b.cidefine7,'')='' then '' else '蚀字:'+isnull(b.cidefine7,'')+dbo.f_hr() end
							  +case when isnull(b.cidefine8,'')='' then '' else '打字:'+isnull(b.cidefine8,'')+dbo.f_hr() end
							  +isnull(Ms,'') 
			from #d a inner join Inventory_extradefine b on a.cInvCode=b.cInvCode and a.cInvCode like '609%'

			insert into #d(OrderByNo,cInvCode,cInvCName,cInvName,Lz,Ms) select @rowNo,@cInvCode,'产成品',@cInvName,cidefine3
				,'防水:'+isnull(b.cidefine2,'')+',Grade:'+isnull(b.cidefine1,'')+','+isnull(cidefine13,'')
			from Inventory a left join Inventory_extradefine b on a.cInvCode=b.cInvCode where a.cInvCode=@cInvCode

			--select * from #d order by OrderByNo   --   exec p_SOprint 'JOB160200006'

			insert into @t(Lei,X,Y,Xall,S) select 'T',1 ,OrderByNo,'1'		,isnull(cInvCode,'')	from #d order by OrderByNo --存货编码
			insert into @t(Lei,X,Y,Xall,S) select 'T',2 ,OrderByNo,'2'		,isnull(cInvCName,'')	from #d order by OrderByNo --类别
			insert into @t(Lei,X,Y,Xall,S) select 'T',3 ,OrderByNo,'3,4'	,isnull(cInvName,'')	from #d order by OrderByNo --名称
			insert into @t(Lei,X,Y,Xall,S) select 'T',5 ,OrderByNo,'5'		,isnull(Lz,'')			from #d order by OrderByNo --内字
			insert into @t(Lei,X,Y,Xall,S) select 'T',6 ,OrderByNo,'6,7,8,9',isnull(Ms,'')			from #d order by OrderByNo --描述

			

		end
	end
	if ''!='单体数据填写'
	begin
		set @rowNo=7
		select row_number() over(order by AutoID) as OrderByNo,iQuantity,cDefine22 as Zouhuodi,isnull(b.cbdefine1,'') as Dz,cDefine31 as TimeSet,cDefine36 as JobDate,cDefine25 as CurrPoNo,cDefine24 as CurrPoLineNo into #dd from SO_SODetails a left join SO_SODetails_extradefine b on a.iSOsID=b.iSOsID where a.ID=@ID--1000000043
		--select row_number() over(order by AutoID) as OrderByNo,iQuantity,cDefine22 as Zouhuodi,'底字' as Dz,cDefine31 as TimeSet,cDefine36 as JobDate,cDefine23 as CurrPoNo,cDefine24 as CurrPoLineNo from SO_SODetails where ID=1000000043

		insert into @t(Lei,X,Y,S) select 'T',1 ,OrderByNo+@rowNo,isnull(OrderByNo,0)		from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',2 ,OrderByNo+@rowNo,isnull(iQuantity,0)		from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',3 ,OrderByNo+@rowNo,isnull(Zouhuodi,'')		from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',4 ,OrderByNo+@rowNo,isnull(Dz,'')				from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',5 ,OrderByNo+@rowNo,isnull(TimeSet,'')			from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',6 ,OrderByNo+@rowNo,dbo.GetDateSstr(JobDate)	from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',7 ,OrderByNo+@rowNo,isnull(CurrPoNo,'')		from #dd order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',8 ,OrderByNo+@rowNo,isnull(CurrPoLineNo,'')	from #dd order by OrderByNo

	end
	if ''!='JOB期 以及模板名称和修改说明文字'
	begin
		set @rowNo=7
		select ROW_NUMBER() OVER(order by JobDate) as OrderByNo,* into #JobDate from (select JobDate,sum(iQuantity) as Qty from #dd group by JobDate) aa
		
		insert into @t(Lei,X,Y,S) select 'T',10 ,OrderByNo+@rowNo,dbo.GetDateSstr(JobDate)	from #JobDate order by OrderByNo
		insert into @t(Lei,X,Y,S) select 'T',11 ,OrderByNo+@rowNo,isnull(Qty,0)				from #JobDate order by OrderByNo

		select @ModelName='C:\U8Print\SOPrint'+cast(count(*) as varchar(50))+'.xlsx' from #JobDate
		update @t set ModelName=@ModelName

		insert into @t(Lei,X,Y,S) select 'T',10,10+(select count(*) from #JobDate),@Edit --修改说明文字
	end

	update @t set S='' where S is null
	update @t set Xall='' where Xall is null
	update @t set PicName='',W=0 where PicName is null
	select * from @t
END

GO


