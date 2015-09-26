USE [UFDATA_003_2015]
GO

/****** Object:  StoredProcedure [dbo].[Usp_MP_MrpGenComponentDemand]    Script Date: 2015-09-26 10:20:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

/******展开BOM，获得子件需求********/
create procedure [dbo].[Usp_MP_MrpGenComponentDemand]
		 @v_llc int,
		 @v_Plan tinyint = 0, /**0-全部 1-MPS/MRP, 2-SRP,3－BRP****/
		 @v_ProjectId int = 0,
		 @v_ProjectId1 int = 0
--           WITH ENCRYPTION

as
   declare  @l_qty UDT_Qty,
   			@l_rate UDT_rate,
				@l_rate1 decimal(38,16),
   			@l_row int,
				@l_date datetime,
				@l_ordertype tinyint,
				@l_orderdid int,
            @l_wkpartid int,
            @l_partid int,
            @l_scale int,
				@l_mpsprojid int,
			 	@l_mrpprojid int,
				@l_mpsflag tinyint,
   	      @l_error int, 
            @l_procname nvarchar(30),
            @l_trancnt int,
            @l_r int

	exec Usp_GetScale @l_scale output 

	delete #mps_supply where ReplaceRelFlag = 2

	select @l_mpsprojid = @v_ProjectId, @l_mrpprojid = @v_ProjectId

	if @v_ProjectId = 0 
	begin
		if @v_Plan = 0
		begin
			select @l_mpsprojid = ProjectId
			  from #mps_planproject a
			 where a.ActiveFlag = 1 and a.PlanType = 1
			select @l_mrpprojid = ProjectId
			  from #mps_planproject a
			 where a.ActiveFlag = 1 and a.PlanType = 2
			select @l_mpsflag = 0
		end
	end
	if @v_Plan = 1 
		select @l_mpsflag = PlanType, @l_mpsprojid = case PlanType when 1 then 0 else isnull(a.MpsProjectId, @l_mpsprojid) end
		  from #mps_planproject a
		 where a.ProjectId = @v_ProjectId
	else if @v_Plan in (2, 3)
		select @l_mpsprojid = @v_ProjectId, @l_mrpprojid = @v_ProjectId1
   
/*****展MRP时须将MPS料读入**************/
	if @l_mpsflag = 2 or @v_Plan = 2
	begin
		insert into mps_temppart(PartId, SupplyType, MpsFlag, LLC)
		select distinct p.PartId, 
				 i.PlanSupplyType,1,p.llc
		  from mps_supply b, bas_part p, v_fc_inventory i
	    where p.PartId = b.PartId and p.llc = @v_llc and p.Invcode = i.cInvCode and i.bmps = 1 and 
				 (b.SupplyType > 1 or i.bPlanInv = 1)
	end
	if @l_mpsflag in (1,2) or @v_Plan = 2
	begin
		insert into #mps_supply (PartId,StartDate,DemType,SoType,SoDId,SoCode,SoSeq,RefDId,RefCode,Qty,DemDate,LUSD,LUCD,SupplyType,BomSequence,DemandCode,SupplyingRCode)
	   select b.PartId,b.AuditDate,b.DemType,b.BillType,b.DemSourceDId,b.SoCode,b.SoSeq, b.BillId,b.BillCode,b.DemQty,b.DemDate,b.LUSD,b.LUCD,b.SupplyType,0,b.DemandCode,b.SupplyingRCode
	     from mps_supply b, mps_temppart p
	    where p.PartId = b.PartId and p.llc = @v_llc and
	          b.DemQty > 0 and b.DemType in (9,10)
	end

/*****非采购件并且非ATO的销售订单或者ATO的预测订单****/
	update #mps_supply set OrderBomFlag = 0
     from #mps_supply t ,
          mps_currentstock c
    where c.ProjectId in (@l_mpsprojid, @l_mrpprojid) and t.PartId = c.PartId and
          t.SupplyType > 1 and
          (c.ATO = 0 or t.SoType in (2,0))

	update #mps_supply set OrderBomFlag = 1
     from #mps_supply t inner join bom_orderbom o on t.SoType in (1,3) and t.SoType = o.OrderType and t.SoDId = convert(nvarchar(30),o.OrderDId)
								inner join bom_parent p on o.BomId = p.BomId and t.PartId = p.ParentId 
          inner join mps_currentstock c on t.PartId = c.PartId 
    where c.ProjectId in (@l_mpsprojid, @l_mrpprojid) and 
          t.SupplyType > 1 and
          (c.ATO = 0 or t.SoType in (2,0))

	if exists(select 1 from #mps_supply where OrderBomFlag = 1)
	begin
		update #mps_supply set OrderBomFlag = 0
		  from #mps_supply t inner join so_sodetails s on convert(nvarchar(30),s.iSosId) = t.SoDId
		 where t.SoType = 1 and t.OrderBomFlag = 1 and s.bOrderBom = 0
		update #mps_supply set OrderBomFlag = 0
		  from #mps_supply t inner join ex_orderdetail s on convert(nvarchar(30),s.AutoId) = t.SoDId
		 where t.SoType = 3 and t.OrderBomFlag = 1 and s.bOrderBom = 0
	end

   select distinct t.PartId, t.StartDate, OrderType = case when t.OrderBomFlag = 0 then 0 else t.SoType end, OrderDId = case when t.OrderBomFlag = 1 then convert(int,isnull(t.SoDId,0)) else 0 end
     into #tmp_bompart
     from #mps_supply t left outer join bom_orderbom o on t.SoType in (1,3) and t.SoType = o.OrderType and t.SoDId = convert(nvarchar(30),o.OrderDId)
								left outer join bom_parent p on o.BomId = p.BomId and t.PartId = p.ParentId ,
          mps_currentstock c
    where c.ProjectId in (@l_mpsprojid, @l_mrpprojid) and t.PartId = c.PartId and
          t.SupplyType > 1 and
          (c.ATO = 0 or t.SoType in (2,0))

	create index ti_tmp on #tmp_bompart (PartId, StartDate, OrderType, OrderDId)

   select @l_trancnt = @@trancount
--   if @l_trancnt = 0
--      begin tran tran_MP_MrpGenComponentDemand

   truncate table #mps_demand

	select VersionEffDate,VersionEndDate,ComponentId = @l_row, BaseQtyN = @l_qty,BaseQtyD = @l_qty,
		  Scrap = @l_rate1,EffBegDate = VersionEffDate, EffEndDate = VersionEffDate,
		  ByproductFlag = 0, WIPType = 0, Offset = @l_row, seq = @l_row, FVFlag = 0, PlanFactor = @l_rate, WhCode = space(10),OpComponentId = BomId,OrderFlag = 0
	  into #tmp_bom
	 from bom_bom where 1 = 2

	create index idx_t_tmp_bom on #tmp_bom(WIPType,ComponentId)

   while ( 1 = 1)           
   begin
      select @l_partid = PartId,
             @l_date = StartDate,
				 @l_ordertype = OrderType,
				 @l_orderdid = OrderDId
        from #tmp_bompart
      if @@rowcount = 0 break   
     
      if exists (select 1 from mps_bomtemp where @l_date >= StartDate and @l_date < EndDate and ParentId = @l_partid and SoType = @l_ordertype and SoDId = case when @l_orderdid = 0 then '' else convert(nvarchar(30),@l_orderdid) end) 
         select @l_r = @l_r
      else
         begin
            exec @l_r = Usp_MP_MrpBom @l_partid, @l_date, @l_ordertype, @l_orderdid
				select @l_error = @@error
				if @l_r <> 0 or @l_error <> 0
				begin
--					if @l_trancnt = 0
--						rollback tran tran_MP_MrpGenComponentDemand
					return 1019999
				end
				delete #tmp_bom
         end
      
      delete #tmp_bompart where PartId = @l_partid and StartDate = @l_date and OrderType = @l_ordertype and OrderDId = @l_orderdid
   end

   insert into #mps_demand (PartId,DemDate,DemType,SoType,SoDId,SoCode,SoSeq,RefDId,RefCode,SupplyingRCode,Qty,Offset,IsRem,LUCD,ByproductFlag,FVFlag,DPFlag,OpComponentId,DemandCode)
   select b.ComponentId,case when b.ByproductFlag = 0 then s.StartDate else s.DemDate end ,20,
/*			 case when c1.MergeType  = 0 then '' when c1.MergeType  = 3 then DemandCode
					when s.SoType in (0,4) or c1.MergeType = 2 then s.SoDId when c1.MergeType = 1 then s.SoCode end,
			 case when c1.MergeType  = 3 then DemandCode else s.SoCode end,
			 case when c1.MergeType = 2 then s.SoSeq else null end,*/
			 s.SoType,s.SoDId,s.SoCode,s.SoSeq,s.RefDId,s.RefCode,isnull(s.SupplyingRCode,s.RefCode),
          round((case when b.FVFlag = 1 then convert(float,s.Qty) * b.BaseQtyN / b.BaseQtyD * b.Scrap * b.PlanFactor / 100 else b.BaseQtyN / b.BaseQtyD * b.Scrap end),@l_scale),
          		b.Offset,case when c1.IsRem = 1 or c.IsRem = 1 then 1 else 0 end ,case when b.ByproductFlag = 0 then s.LUSD else s.LUCD end,b.ByproductFlag,b.FVFlag,
			 case when c1.SupplyType < 3 or c1.IsRem = 1 then 0 else b.DPFlag end,b.OpComponentId,
			 s.DemandCode
     from #mps_supply s, mps_bomtemp b, mps_currentstock c, mps_temppart c1
    where s.SupplyType > 1 and s.PartId = b.ParentId and s.OrderBomFlag = b.OrderBomFlag and (s.SoType = b.SoType and s.SoDId = b.SoDId and b.OrderBomFlag = 1 or b.OrderBomFlag = 0 and b.SoType = 0 and b.SoDId = '') and
          s.StartDate >= b.StartDate and s.StartDate < b.EndDate and
			 s.StartDate >= b.EffBegDate and s.StartDate < b.EffEndDate and
          s.PartId = c.PartId and 
       	(c.ATO = 0 or s.SoType in (2,0)) and 
			b.ComponentId = c1.PartId and c.ProjectId in (@l_mpsprojid, @l_mrpprojid)

	if @v_plan < 3
	begin
		update #mps_demand
			set SoType = d.SoType + 10
		  from #mps_demand d inner join bom_parent p on d.PartId = p.ParentId inner join bom_orderbom o on p.BomId = o.BomId
		 where d.SoType in (1,3) and d.SoType = o.OrderType and d.SoDId = convert(nvarchar(30),o.OrderDId)
		update #mps_demand
			set SoType = case when d.SoType > 10 then d.SoType - 10 
									when c1.MergeType = 0 or d.SoType = 0 then 0 
									when c1.MergeType  = 3 then case when d.SoType = 0 then 0 else 4 end 
									when d.SoType = 4 then case when c1.MergeType  = 3 then 4 else 9 end 
									when c1.MergeType = 2 then d.SoType
									when d.SoType in (1,5) and c1.MergeType = 1 then 5
									when d.SoType in (3,6) and c1.MergeType = 1 then 6	end
		  from #mps_demand d inner join mps_temppart c1 on d.PartId = c1.PartId
	end

   select  @l_error = @@error

	if  @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

   insert into mps_error (PartId, PlanCode, DemDate, ErrorId, ProjectId)
   select distinct s.PartId, s.RefCode, s.StartDate, 2, case when @v_Plan in (1,2) then @v_ProjectId else case when c.MpsFlag = 1 then @l_mpsprojid else @l_mrpprojid end end
    from #mps_supply s, mps_currentstock c
	where s.SupplyType > 1 and s.PartId = c.PartId and c.SupplyType > 1 and (c.ATO = 0 or s.SoType in (2,0)) and c.ProjectId in (@l_mpsprojid, @l_mrpprojid) and 
			not exists (select 1 from mps_bomtemp b where s.PartId = b.ParentId and 
          s.StartDate >= b.StartDate and s.StartDate < b.EndDate and
			 s.StartDate >= b.EffBegDate and s.StartDate < b.EffEndDate)
   
   /***ATO件的销售订单的子件来自于客户BOM****/
   insert into #mps_demand (BomSequence,PartId,DemDate,DemType,SoType,SoDId,SoCode,SoSeq,RefDId,RefCode,SupplyingRCode,Qty,Offset,IsRem,LUCD,ByproductFlag,FVFlag,DPFlag,OpComponentId,DemandCode)
      select b.Sequence,b.ComponentId,case when b.ByproductFlag = 0 then s.StartDate else s.DemDate end,20,
				 case when @v_Plan = 3 then s.SoType when c1.MergeType  = 0 or s.SoType = 0 then 0 
						when c1.MergeType  = 3 then case when s.SoType = 0 then 0 else 4 end
						when s.SoType = 4 then case when c1.MergeType  = 3 then 4 else 9 end
						when c1.MergeType  = 2 then s.SoType 
						when s.SoType in (1,5) and c1.MergeType = 1 then 5
						when s.SoType in (3,6) and c1.MergeType = 1 then 6	end,
				 s.SoDId,s.SoCode,s.SoSeq,s.RefDId,s.RefCode,isnull(s.SupplyingRCode,s.RefCode),
             round((case when b.FVFlag = 1 then s.Qty * b.RelBaseQtyN / b.RelBaseQtyD * (1 + b.RelCompScrap / 100) / (1 - b.RelParentScrap / 100) else b.RelBaseQtyN / b.RelBaseQtyD * (1 + b.RelCompScrap / 100) end) *(case when b.ByproductFlag = 0 then 1 else -1 end),@l_scale),
             b.Offset,case when c1.IsRem = 1 or c.IsRem = 1 then 1 else 0 end,case when b.ByproductFlag = 0 then s.LUSD else s.LUCD end,b.ByproductFlag,b.FVFlag,case when b.WIPType = 5 then 1 else 0 end,b.OpComponentId,s.DemandCode
        from #mps_supply s, SO_SODetails d, mps_currentstock c, bom_cbomcomponent b, mps_temppart c1
       where s.SupplyType > 1 and s.PartId = c.PartId and 
          	(c.ATO = 1 and s.SoType = 1) and d.iSosId = convert(int,s.SoDId) and
          	d.iCusBomId = b.CustBomId and s.BomSequence = b.PSequence and 
				b.ComponentId = c1.PartId and c.ProjectId in (@l_mpsprojid, @l_mrpprojid)
					
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end
				
	insert into mps_bomtemp (SoType,SoDId,ParentId,StartDate,EndDate,ComponentId,BaseQtyN,BaseQtyD,Scrap,EffBegDate,EffEndDate,Offset,FVFlag,PlanFactor,ByproductFlag,DPFlag,OpComponentId,OrderBomFlag) 
      select s.SoType,s.SoDId,s.PartId,'1900-1-1','1900-1-1',b.ComponentId, b.RelBaseQtyN,b.RelBaseQtyD,b.RelCompScrap,'1900-1-1','1900-1-1',b.Offset,b.FVFlag,0,b.ByproductFlag,case when b.WIPType = 5 then 1 else 0 end,b.OpComponentId,0
        from #mps_supply s, SO_SODetails d, mps_currentstock c, bom_cbomcomponent b, mps_temppart c1
       where s.SupplyType > 1 and s.PartId = c.PartId and 
          	(c.ATO = 1 and s.SoType = 1) and d.iSosId = convert(int,s.SoDId) and
          	d.iCusBomId = b.CustBomId and s.BomSequence = b.PSequence and 
				b.ComponentId = c1.PartId and c.ProjectId in (@l_mpsprojid, @l_mrpprojid)
				

   insert into #mps_demand (BomSequence,PartId,DemDate,DemType,SoType,SoDId,SoCode,SoSeq,RefDId,RefCode,SupplyingRCode,Qty,Offset,IsRem,LUCD,ByproductFlag,FVFlag,DPFlag,OpComponentId,DemandCode)
      select b.Sequence,b.ComponentId,case when b.ByproductFlag = 0 then s.StartDate else s.DemDate end,20,
				 case when @v_Plan = 3 then s.SoType when c1.MergeType  = 0 or s.SoType = 0 then 0 
						when c1.MergeType  = 3 then case when s.SoType = 0 then 0 else 4 end 
						when s.SoType = 4 then case when c1.MergeType  = 3 then 4 else 9 end 
						when c1.MergeType = 2 then s.SoType
						when s.SoType in (1,5) and c1.MergeType = 1 then 5
						when s.SoType in (3,6) and c1.MergeType = 1 then 6	end,
				 s.SoDId,s.SoCode,s.SoSeq,s.RefDId,s.RefCode,isnull(s.SupplyingRCode,s.RefCode),
             round((case when b.FVFlag = 1 then convert(float,s.Qty) * b.RelBaseQtyN / b.RelBaseQtyD * (1 + b.RelCompScrap / 100) / (1 - b.RelParentScrap / 100) else b.RelBaseQtyN / b.RelBaseQtyD * (1 + b.RelCompScrap / 100) end) *(case when b.ByproductFlag = 0 then 1 else -1 end),@l_scale),
             b.Offset,case when c1.IsRem = 1 or c.IsRem = 1 then 1 else 0 end,case when b.ByproductFlag = 0 then s.LUSD else s.LUCD end,b.ByproductFlag,b.FVFlag,case when b.WIPType = 5 then 1 else 0 end, b.OpComponentId,s.DemandCode
        from #mps_supply s, ex_orderdetail d, mps_currentstock c, bom_cbomcomponent b, mps_temppart c1
       where s.SupplyType > 1 and s.PartId = c.PartId and 
          	(c.ATO = 1 and s.SoType = 3) and d.AutoId = convert(int,s.SoDId) and
          	d.iCusBomId = b.CustBomId and s.BomSequence = b.PSequence and 
				b.ComponentId = c1.PartId and c.ProjectId in (@l_mpsprojid, @l_mrpprojid)
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

	update #mps_demand
		set BalQty = Qty,
			 NetQty = Qty

/****偏置期, 不调整非工作日******/   
   update #mps_demand 
      set CalSeq = case when v.WkHours > 0 then v.Seq + d.Offset else v.Seq + d.Offset + 1 end
     from #mps_demand d, v_bas_calendar_sys v,  mps_bomtemp t, mps_temppart c
    where d.Offset <> 0 and d.OpComponentId = t.OpComponentId and t.ParentId = c.PartId and c.SupplyType = 3 and d.DemDate = v.CalDate
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

   update #mps_demand 
      set DemDate = v.CalDate
     from #mps_demand d, v_bas_calendar_sys v, mps_bomtemp t, mps_temppart c
    where d.Offset <> 0 and d.OpComponentId = t.OpComponentId and t.ParentId = c.PartId and c.SupplyType = 3 and d.CalSeq = v.Seq and v.WkHours > 0
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

   update #mps_demand 
      set DemDate = dateadd(day, d.Offset, d.DemDate)
     from #mps_demand d, mps_bomtemp t, mps_temppart c
    where d.Offset <> 0 and d.OpComponentId = t.OpComponentId and t.ParentId = c.PartId and c.SupplyType < 3 
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

	if @l_mpsflag = 2	delete mps_temppart where MpsFlag = 1

	if @v_Plan < 3    
	begin
	   update #mps_demand 
	      set CalSeq = case when v.WkHours > 0 then v.Seq + d.Offset else v.Seq + d.Offset + 1 end
	     from #mps_demand d, v_bas_calendar_sys v
	    where d.Offset <> 0 and d.IsRem = 1 and d.LUCD = v.CalDate 
		select @l_error = @@error
		if @l_error <> 0
		begin
--			if @l_trancnt = 0
--				rollback tran tran_MP_MrpGenComponentDemand
			return 1019999
		end
	   
	   update #mps_demand 
	      set LUCD = v.CalDate
	     from #mps_demand d, v_bas_calendar_sys v
	    where d.Offset <> 0 and d.IsRem = 1 and d.CalSeq = v.Seq and v.WkHours > 0
		select @l_error = @@error
		if @l_error <> 0
		begin
--			if @l_trancnt = 0
--				rollback tran tran_MP_MrpGenComponentDemand
			return 1019999
		end
	end
    
    insert into mps_demand
  	(PartId,DemDate,DemType,BillType,DemSourceDId,SoCode,SoSeq,BillId,BillCode,SupplyingRCode,DemBillQty,DemQty,NetQty,ByproductFlag,Police,FVFlag,OpComponentId,ReplaceRelFlag,DocType,Status,DPFlag,DemandCode,BomSequence)  
   select d.PartId,d.DemDate,d.DemType,
			 case when @v_Plan < 3 and d.SoType = 4 and isnull(d.DemandCode,'')='' then 0 when @v_Plan < 3 and d.SoType = 9 then 4 else d.SoType end,
			 case when @v_Plan = 3 then d.SoDId
			 		when d.SoType = 0 then '' when d.SoType in (1,3,9) then d.SoDId when d.SoType in (5,6) then d.SoCode else isnull(d.DemandCode,'') end,
			 case when @v_Plan = 3 then d.SoCode when d.SoType = 0 then null when d.SoType in (1,3,5,6) then d.SoCode when d.SoType = 9 then d.SoDId else isnull(d.DemandCode,'') end,
			 case when @v_Plan = 3 then d.SoSeq when d.SoType in (1,3) then d.SoSeq else null end,
			 d.RefDId,d.RefCode,d.SupplyingRCode,d.Qty,d.Qty,d.Qty,d.ByproductFlag,c.Police,d.FVFlag,d.OpComponentId,
			 case when isnull(d.ReplaceRelFlag,0) = 0 then 0 else 2 end,20,1,d.DPFlag,case when d.SoType = 0 then null else d.DemandCode end,d.BomSequence
    FROM #mps_demand d, mps_temppart c
   where (d.IsRem = 0 or @v_Plan = 3) and d.PartId = c.PartId
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

    insert into mps_demand
  	(PartId,DemDate,DemType,BillType,DemSourceDId,SoCode,SoSeq,BillId,BillCode,SupplyingRCode,DemBillQty,ByproductFlag,Flag,Police,FVFlag,OpComponentId,ReplaceRelFlag,DocType,Status,DPFlag)  
   select d.PartId,v.CalDate,d.DemType,
			 case when @v_Plan = 3 then d.SoType else 0 end,
			 case when @v_Plan = 3 then d.SoDId else '' end,
			 case when @v_Plan = 3 then d.SoCode else null end,
			 case when @v_Plan = 3 then d.SoSeq else 0 end,d.RefDId,d.RefCode,d.SupplyingRCode,
   		 round(d.Qty/(select count(v1.CalDate) from v_bas_calendar_sys v1 where v1.CalDate between d.DemDate and d.LUCD and v1.WkHours > 0),@l_scale),
   		 d.ByproductFlag,1, c.Police,d.FVFlag,d.OpComponentId,
 			 case when isnull(d.ReplaceRelFlag,0) = 0 then 0 else 2 end,20,1,0
    FROM #mps_demand d, v_bas_calendar_sys v, mps_temppart c
   where d.IsRem = 1 and v.CalDate between d.DemDate and d.LUCD and v.WkHours > 0 and @v_Plan < 3 and d.PartId = c.PartId
	select @l_error = @@error
	if @l_error <> 0
	begin
--		if @l_trancnt = 0
--			rollback tran tran_MP_MrpGenComponentDemand
		return 1019999
	end

   update mps_demand 
   	set DemQty = DemBillQty,
   		 Netqty = DemBillQty
    where Flag = 1
    
   update mps_demand
      set Flag = 0
    where Flag = 1
	
   
/****BRP展开时删除#mps_supply*****/
--	if @v_MpsFlag = 3 delete #mps_supply

--   delete mps_bomtemp
   
--if @l_trancnt = 0
--     commit tran

return 0  



GO


