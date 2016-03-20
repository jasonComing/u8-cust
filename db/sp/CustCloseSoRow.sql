--close 1 row
create procedure CustCloseSoRow
    @isosid int,
    @cUser_Id nvarchar(40)
as
begin

begin transaction
begin try

	Update SO_Sodetails 
	Set dbclosedate=convert(date, getdate()),dbclosesystime=getdate()  
	from SO_SOMain 
	Inner join SO_SODetails on SO_SOMain.id=so_Sodetails.id 
	Where isosid=@isosid
	And isnull(csCloser,N'')=N'' 

	Update SO_Sodetails 
	Set cSCloser=
		(select cUser_Name from ufsystem..UA_User where cUser_Id = @cUser_Id),
		iPreKeepTotQuantity=null,
		iPreKeepQuantity=null,
		iPreKeepTotNum=null,
		iPreKeepNum=null,
		finquantity=null 
	from SO_SOMain 
	Inner join SO_SODetails on SO_SOMain.id=so_Sodetails.id  
	Where isosid=@isosid

	Update dispatchlists 
	Set bmpforderclosed=1 
	from dispatchlists 
	inner join SO_SODetails on dispatchlists.isosid=SO_SODetails.isosid 
	where isnull(SO_SODetails.forecastdid,0)<>0 
	and SO_SODetails.isosid=@isosid

	Update dispatchlist 
	Set dispatchlist.dlid=dispatchlist.dlid 
	from dispatchlist 
	inner join  dispatchlists on dispatchlist.dlid=dispatchlists.dlid 
	inner join SO_SODetails on dispatchlists.isosid=SO_SODetails.isosid 
	where isnull(SO_SODetails.forecastdid,0)<>0 
	and SO_SODetails.isosid=@isosid

	Update SaleBillVouchs 
	Set bmpforderclosed=1 
	from SaleBillVouchs 
	inner join SO_SODetails on SaleBillVouchs.isosid=SO_SODetails.isosid 
	where isnull(SO_SODetails.forecastdid,0)<>0 
	and SO_SODetails.isosid=@isosid

	Update SaleBillVouch 
	Set SaleBillVouch.sbvid=SaleBillVouch.sbvid 
	from SaleBillVouch 
	inner join  SaleBillVouchs on SaleBillVouch.sbvid=SaleBillVouchs.sbvid 
	inner join SO_SODetails on SaleBillVouchs.isosid=SO_SODetails.isosid 
	where isnull(SO_SODetails.forecastdid,0)<>0 
	and SO_SODetails.isosid=@isosid

    commit transaction
end try
begin catch
    rollback transaction
end catch

end
go