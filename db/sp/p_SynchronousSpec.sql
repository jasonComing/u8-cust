
CREATE proc  sp_SynchronousSpec 
/*
功能：以D产成品规格信息同步S产成品
Auth:JAMS
调用实例：exec sp_SynchronousSpec 'D_2010854'
*/
@cInvCode_D varchar(30)
as 
begin
	declare @versionNun_D  int			---最高版本号 ，对D号
	declare @cInvCode_S varchar(30)
	declare @versionNum_S int			---最高版本号 ，对S号
   set nocount on
	
	if (@cInvCode_D is null or @cInvCode_D='') return
	SET @cInvCode_S='S'+RIGHT(@cInvCode_D,LEN(@cInvCode_D)-1)
	--取最高版本号
	select top 1  @cInvCode_D=cInvCode,@versionNun_D= max(version)  from CustInvSpecDetail 
	where cInvCode=@cInvCode_D	group by cInvCode

	select top 1  @cInvCode_S=cInvCode,@versionNum_S= max(version) from CustInvSpecDetail 
	where cInvCode=@cInvCode_S group by cInvCode
	-- 核查
	if (@versionNum_S is null )  set @versionNum_S=0
	if (@versionNun_D is null )  set @versionNun_D=0
	if (@versionNun_D=0  or  @versionNum_S >= @versionNun_D ) return

	--复制数据CustInvSpecDetail
	insert into CustInvSpecDetail(cinvCode,version,propertyid,specvalue,Lastmodified,cvencode)
	select @cInvCode_S,version,propertyid,specvalue,Lastmodified,cvencode 
	from  CustInvSpecDetail where (cinvCode=@cInvCode_D) and (version > @versionNum_S )
	
	--复制数据CustInvSpec
	delete from CustInvSpec where cinvCode=@cInvCode_S and status=1
	insert into CustInvSpec(cInvCode,Version,CreatedBy,ClosedBy,CreatedDate,LastModified,ClosedDate,Memo,ApprovedBy,ApprovedDate,Status)
	select @cInvCode_S,Version,CreatedBy,ClosedBy,CreatedDate,LastModified,ClosedDate,Memo,ApprovedBy,ApprovedDate,Status
	from CustInvSpec where (cinvCode=@cInvCode_D) and (version > @versionNum_S-1 )
	set nocount off
end 