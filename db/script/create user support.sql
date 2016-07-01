/*
use UFDATA_004_2015
drop user support;
go
use master
drop user support;
drop login support;
go
*/

create login support
  with password = 'u8123456.';

--use master
--create user support for login support;
--go

use UFDATA_004_2015
create user support for login support
  WITH DEFAULT_SCHEMA = UFDATA_004_2015;
go

use master
GRANT CONNECT SQL TO "support";
GRANT CONNECT ON ENDPOINT::"TSQL Default TCP" TO "support";
grant CREATE DATABASE to support;
go

USE UFDATA_004_2015
GRANT insert, update, delete, select ON Schema::dbo TO support;
grant BACKUP DATABASE, BACKUP LOG, CREATE DEFAULT, CREATE FUNCTION, CREATE PROCEDURE, CREATE RULE, CREATE TABLE, CREATE VIEW to support
GO

use msdb
create user support for login support;
sp_addrolemember 'SQLAgentUserRole', 'support';
sp_addrolemember 'SQLAgentReaderRole', 'support';
sp_addrolemember 'SQLAgentOperatorRole', 'support';
go

use UFSystem
create user support for login support;
GRANT insert, update, delete, select ON Schema::dbo TO support;
go



exec sp_defaultdb 'support ', 'UFDATA_004_2015'

go