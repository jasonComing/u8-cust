use master
go
CREATE DATABASE [Cust001]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Cust001', FILENAME = N'C:\Databases\Cust001.MDF' )
 LOG ON 
( NAME = N'Cust001_LOG', FILENAME = N'C:\Databases\Cust001.LDF' )
go
create user f8report for login f8report;
go
