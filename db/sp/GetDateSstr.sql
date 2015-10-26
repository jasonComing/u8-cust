SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION  [dbo].[GetDateSstr](@Str varchar(50))
RETURNS varchar(50)
AS  
BEGIN 
	if isnull(@Str,'')='' return ''
	return  dbo.GetDateS(@Str)
END


GO


