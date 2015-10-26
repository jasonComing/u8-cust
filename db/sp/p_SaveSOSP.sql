SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec p_SaveSOSP 'Body','aa','adsf','','601','�����������P���ϼ���','����','0.003',''

*/
ALTER PROCEDURE p_SaveSOSP
	@Lei varchar(50),@code varchar(50)='',@name nvarchar(50)='',
	@ID varchar(50)='',
	@Class [varchar](50)='',
	@ClassName [varchar](50)='',
	@ClassType [varchar](50)='',
	@Proportion [varchar](50)='',
	@Qty [varchar](50)=''
AS
BEGIN
	SET NOCOUNT ON;
	
		insert into a(Str,b) select 'exec p_SaveSOSP '''+@Lei+''','''+@code+''','''+@name+''','''+@ID+''','''+@Class+''','''+@ClassName+''','''+@ClassType+''','''+@Proportion+''','''+@Qty+'''',getdate()
	--	select * from a   delete a
	
	if @Lei='HeadAdd'
	begin
		if @code='' or @name=''
		begin
			select '��������ͷ������Ʋ���Ϊ��'
			return
		end;
		if exists(select top 1 1 from t_SOSP where SPcode=@code)
		begin
			select '����ʿơ��������'+@code+'�Ѵ��ڣ������ظ�¼��'
			return
		end;
		insert into t_SOSP(SPcode,SPname) values(@code,@name)
		select 'OK'
	end;
	if @Lei='HeadEdit'
	begin
		if @code='' or @name=''
		begin
			select '��������ͷ������Ʋ���Ϊ��'
			return
		end;
		update t_SOSP set SPname=@name where SPcode=@code
		select 'OK'
	end;
	if @Lei='Body'
	begin
		if @Class='' or @ClassName='' or @ClassType=''
		begin
			select '���ࡢ���ơ����� ����Ϊ��'
			return
		end;

		if @Proportion='' set @Proportion='0'
		if @Qty='' set @Qty='0'
		if @ClassType='����' set @Qty='0'
		if @ClassType='����' set @Proportion='0'

		--if @ClassType like '%[%]'
		--begin
		--	set @ClassType=0.01*replace(@ClassType,'%','')
		--end;

		if @ID='0' or @ID=''
		begin
			insert into t_SOSPs(SOSP,Class,ClassName,ClassType,Proportion,Qty)
			values(@code,@Class,@ClassName,@ClassType,@Proportion,@Qty)
		end
		else
		begin
			update t_SOSPs set Class=@Class,ClassName=@ClassName,ClassType=@ClassType,Proportion=@Proportion,Qty=@Qty where ID=@ID
		end;

		select 'OK'
	end;
	if @Lei='��ҳ'
	begin
		select min(SPcode) from t_SOSP
	end;
	if @Lei='ĩҳ'
	begin
		select max(SPcode) from t_SOSP
	end;
	if @Lei='��ҳ'
	begin
		if exists(select top 1 1 from t_SOSP where SPcode<@code)
		begin
			select max(SPcode) from t_SOSP where SPcode<@code
		end
		else
		begin
			select min(SPcode) from t_SOSP
		end;
	end;
	if @Lei='��ҳ'
	begin
		if exists(select top 1 1 from t_SOSP where SPcode>@code)
		begin
			select min(SPcode) from t_SOSP where SPcode>@code
		end
		else
		begin
			select max(SPcode) from t_SOSP
		end;
	end;
END
GO

