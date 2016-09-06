create login f8report
	with password = '1Punch@Hero;';

use master
go
create user f8report for login f8report;
go
use UFDATA_004_2015
go
create user f8report for login f8report;
go

use master
go
GRANT CONNECT SQL TO "f8report";
GRANT CONNECT ON ENDPOINT::"TSQL Default TCP" TO "f8report";
GRANT SELECT ON Schema::dbo TO f8report;
go


/*
SELECT 
	'grant ' + permission_name + ' on ' + OBJECT_NAME(major_id) + ' to ' + user_name(grantee_principal_id) + ';'
	class,
    class_desc 
  , CASE WHEN class = 0 THEN DB_NAME()
         WHEN class = 1 THEN OBJECT_NAME(major_id)
         WHEN class = 3 THEN SCHEMA_NAME(major_id) END [Securable]
  , USER_NAME(grantee_principal_id) [User]
  , permission_name
  , state_desc
FROM sys.database_permissions
where user_name(grantee_principal_id) = 'f8report'
and class = 1
*/

grant DELETE on CustInvClassMetaData to f8report;
grant INSERT on CustInvClassMetaData to f8report;
grant UPDATE on CustInvClassMetaData to f8report;
grant DELETE on CustSpecProperty to f8report;
grant INSERT on CustSpecProperty to f8report;
grant UPDATE on CustSpecProperty to f8report;
grant DELETE on CustSpecPropertyOption to f8report;
grant INSERT on CustSpecPropertyOption to f8report;
grant UPDATE on CustSpecPropertyOption to f8report;
grant DELETE on CustInvSpec to f8report;
grant INSERT on CustInvSpec to f8report;
grant UPDATE on CustInvSpec to f8report;
grant DELETE on CustFoaOrderFeed to f8report;
grant INSERT on CustFoaOrderFeed to f8report;
grant SELECT on CustFoaOrderFeed to f8report;
grant UPDATE on CustFoaOrderFeed to f8report;
grant DELETE on CustInvSpecDetail to f8report;
grant INSERT on CustInvSpecDetail to f8report;
grant UPDATE on CustInvSpecDetail to f8report;
grant EXECUTE on SP_PmcReport to f8report;
grant DELETE on CustInvSpecOwnerOption to f8report;
grant INSERT on CustInvSpecOwnerOption to f8report;
grant UPDATE on CustInvSpecOwnerOption to f8report;
grant SELECT on CustFoaTimeSetConfig to f8report;
grant SELECT on CustFoaShipMethodConfig to f8report;
grant DELETE on CustJotorRecord to f8report;
grant INSERT on CustJotorRecord to f8report;
grant SELECT on CustJotorRecord to f8report;
grant UPDATE on CustJotorRecord to f8report;
grant SELECT on CustFoaOwnerHKConfig to f8report;
grant DELETE on CustPoVersionVerify to f8report;
grant INSERT on CustPoVersionVerify to f8report;
grant SELECT on CustPoVersionVerify to f8report;
grant UPDATE on CustPoVersionVerify to f8report;
grant DELETE on CustMoVersionVerify to f8report;
grant INSERT on CustMoVersionVerify to f8report;
grant SELECT on CustMoVersionVerify to f8report;
grant UPDATE on CustMoVersionVerify to f8report;
grant UPDATE on PO_POMain to f8report;
grant UPDATE on OM_MOMain to f8report;
grant EXECUTE on Usp_U8_VariationServer to f8report;
grant EXECUTE on Usp_PU_POSaveVariation to f8report;
grant INSERT on PO_PomainHistory_extradefine to f8report;
grant INSERT on PO_PodetailsHistory_extradefine to f8report;