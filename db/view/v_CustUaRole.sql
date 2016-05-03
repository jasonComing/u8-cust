create view v_CustUaRole
as
select cGroup_Id, cUser_Id
from UFSystem..UA_Role

go

create view v_CustAuthByDepartment
as
select AutoId, cUserId, cBusObId, cACCode, isUserGroup, cClassCode, cFuncId, isDefault, pubufts
from aa_holdauth
where cBusObId=N'department' 
And isUserGroup=1 

go
