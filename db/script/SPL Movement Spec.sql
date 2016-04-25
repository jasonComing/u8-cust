alter table CustInvClassMetaData
add cVenCode nvarchar(40)
go

update CustInvClassMetaData
set cVenCode = 1015
where PropertyId = 170