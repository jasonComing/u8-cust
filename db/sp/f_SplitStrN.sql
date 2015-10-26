SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION f_SplitStrN
(
	@Long_str NVARCHAR(MAX),@split_str NVARCHAR(100),@n int
)
RETURNS varchar(max)
AS
BEGIN
	declare @s varchar(max)

	if exists(select top 1 1 from dbo.f_SplitStr(@Long_str,@split_str) a where i=@n)
	begin
		select @s=s from dbo.f_SplitStr(@Long_str,@split_str) a where i=@n
	end
	else
	begin
		set @s=''
	end;
	
	RETURN @s

END
GO

