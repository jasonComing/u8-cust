create login f8report with password = '1Punch@Hero';
go

use UFDATA_001_2015
create user f8report for login f8report;
go
grant select on SCHEMA::dbo to f8report
go
grant insert,update,delete on CustInvClassMetaData to f8report
grant insert,update,delete on CustInvSpec to f8report
grant insert,update,delete on CustInvSpecDetail to f8report
grant insert,update,delete on CustSpecProperty to f8report
grant insert,update,delete on CustSpecPropertyOption to f8report

use UFSystem
go
create user f8report for login f8report;
grant select on SCHEMA::dbo to f8report;
go