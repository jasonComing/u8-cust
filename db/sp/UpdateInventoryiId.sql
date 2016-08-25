CREATE procedure UpdateInventoryiId
        @cInvCode nvarchar(24) = null,
        @debug int = 0
as
begin
        declare @row int

		update Inventory
		set Inventory.iId = CustBrandIid.Iid, dModifyDate = getdate()
		from Inventory
		join CustBrandIid on CustBrandIid.Brand = Inventory.cInvDefine4
		and Inventory.cInvCCode in (1, 4)
		and Inventory.iId = 4

		set @row = @@rowcount

        if @debug > 0
        begin
            select convert(varchar(20), @row) + ' rows are updated for completed watch'
        end

		select cInvCode
        into #invs
        from Inventory
        where cInvCode = isnull(@cInvCode, cInvCode)
        and iId = 4
        and Inventory.cInvCCode not in ('604', '640', '1', '4')
        and Inventory.cInvCCode not like '8%'

        if @debug > 0
        begin
                select '#invs', *
                from #invs
        end

        select dInvCode as cInvCode, min(iId) as iId
        into #iId
        from (
            select d.dInvCode, isnull(h2i.iId, hi.iId) as iId
            from v_bom_detail_cust d
            join v_bom_head h on h.bomid = d.bomid
            join Inventory hi on hi.cInvCode = h.InvCode
            join Inventory di on di.cInvCode = d.dInvCode
            left join v_bom_detail_cust d2 on hi.cInvCode = d2.dInvCode
            left join v_bom_head h2 on h2.bomid = d2.bomid
            left join Inventory h2i on h2i.cInvCode = h2.InvCode
            where di.cInvCode in (select cInvCode from #invs)
            and isnull(h2i.iId, hi.iId) != 4) t
        group by dInvCode

        if @debug > 0
        begin
                select '#iId', *
                from #iId
        end

        update Inventory
        set iId = #iId.iId, dModifyDate = getdate()
        from Inventory
        join #iId on #iId.cInvCode = Inventory.cInvCode

		set @row = @@rowcount
		
        if @debug > 0
        begin
            select convert(varchar(20), @row) + ' rows are updated'
        end
end