use master
go
CREATE DATABASE [Cust004]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Cust004', FILENAME = N'C:\Databases\Cust004.MDF' )
 LOG ON 
( NAME = N'Cust004_LOG', FILENAME = N'C:\Databases\Cust004.LDF' )
go
create user f8report for login f8report;
go
