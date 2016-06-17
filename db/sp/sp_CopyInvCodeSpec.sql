create proc CopyInvCodeSpec
@newInvCode varchar(50)=null,
@oldInvCode varchar(50)=null
/*
功能：拷贝料件规格信息
调用实例:exec CopyInvCodeSpec '000_tt','D_007226'
*/
as
begin

	if (@newInvCode is null or @oldInvCode is null ) return

	set nocount on

	begin tran t1
	if not exists(select * from CustInvSpec  where  cinvcode  =@newInvCode )
	 begin
		insert into  CustInvSpec([cInvCode],[Version] ,[CreatedBy],[ClosedBy],[CreatedDate],[LastModified],
										[ClosedDate],[Memo],[ApprovedBy] ,[ApprovedDate],[Status])

		select @newInvCode,[Version] ,[CreatedBy],[ClosedBy],[CreatedDate],[LastModified],
										[ClosedDate],[Memo],[ApprovedBy] ,[ApprovedDate],[Status] from  CustInvSpec where cinvcode =@oldInvCode
	 end


	 if not exists( select * from CustInvSpecDetail  where  cinvCode =@newInvCode )
	 begin
		insert into  CustInvSpecDetail([cInvCode],[Version],[PropertyId],
									[SpecValue],[LastModified],[cVenCode])

		select @newInvCode,[Version],[PropertyId],
									[SpecValue],[LastModified],[cVenCode]
									from  CustInvSpecDetail where cInvCode =@oldInvCode
	 end

	 if @@ERROR=0
			commit tran t1
	 else
			rollback tran t1

	set nocount off

end
