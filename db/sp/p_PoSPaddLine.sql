SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec p_PoSPaddLine ',,,,,|617_000029,33.000,1700164,,Ture,JOB150200016'
exec p_PoSPaddLine '617_000029,33.000   ,1700164,    ,Ture,JOB150200016'
exec p_PoSPaddLine '609_020119,18000.000,NY2403 ,款号,Ture,JOB150300025'
exec p_PoSPaddLine '609_020119,18000.000,NY2403,款号,Ture,JOB150300025'

*/
ALTER PROCEDURE p_PoSPaddLine  --  exec p_PoSPaddLine '602_000007,2000.000,,,,'
	@AllLineStr varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	
	--insert into a(Str,b) select 'exec p_PoSPaddLine '''+@AllLineStr+'''',getdate()  --  select * from a   delete a

	select   dbo.f_SplitStrN(s,',',1) as Item
			,cast(cast(dbo.f_SplitStrN(s,',',2) as decimal(16,4))*cast(b.cInvDefine13 as decimal(16,4)) as int) as Qty
			,dbo.f_SplitStrN(s,',',3) as cDefine29--'客号' as cDefine29
			,dbo.f_SplitStrN(s,',',4) as cDefine33--'款号' as cDefine33
			,dbo.f_SplitStrN(s,',',5) as cDefine30--'是否MRP' as cDefine30
			,dbo.f_SplitStrN(s,',',6) as csocode--'csocode' as csocode 
	into #a 
	from dbo.f_SplitStr(@AllLineStr,'|') a left join Inventory b on dbo.f_SplitStrN(a.s,',',1)=b.cInvCode and isnull(b.cInvDefine13,'')!=''
	where dbo.f_SplitStrN(s,',',1)!=''

	
    
	select Item as 存货编码,Qty as 数量,cDefine29,cDefine33,cDefine30,csocode from #a a
	

END
GO
