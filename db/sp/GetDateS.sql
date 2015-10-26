SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION  [dbo].[GetDateS](@Str datetime)
RETURNS varchar(50)
AS  
BEGIN 
	if @Str is null return ''
	return  cast(year(@str) as varchar(4))+'-'+right('00'+cast(month(@str) as varchar(2)),2)+'-'+right('00'+cast(day(@str) as varchar(2)),2)
END


GO


