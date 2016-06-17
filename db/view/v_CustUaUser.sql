create view v_CustUaUser
as
select cPersonCode as cUser_Id, cPersonName as cUser_Name
from Person
union
select cUser_Id, cUser_Name
from UA_User
where not exists (select 1 from Person where cPersonCode = cUser_Id)
