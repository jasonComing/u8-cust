alter proc SP_ApproveWPI_TQ
/*
功能：取出TQ號做審核加庫存量
調用：exec SP_ApproveWPI_TQ 'WPI16100002_TQ'

*/
	@cCode varchar(60) = null
as
begin
		exec SP_ApproveWPINO @cCode,0
end