alter proc SP_ApproveWPI_TQ
/*
功能：取出TQ號做審核加庫存量
*/
as
begin
	declare @cCode varchar(50)

	declare mycursor cursor for
		select cCode from Rdrecord01 where cCode like '%_TQ' and dVeriDate is null

	open mycursor
	fetch next from mycursor into @cCode

	while @@FETCH_STATUS = 0
	begin
		print @cCode

		exec SP_ApproveWPINO @cCode,0
		fetch next from mycursor into @cCode
	end

	close mycursor
	deallocate mycursor

end