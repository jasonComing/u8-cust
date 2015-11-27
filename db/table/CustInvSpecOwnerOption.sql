create table CustInvSpecOwnerOption
(
	cUser_Id varchar(120) primary key,
	LastModified datetime default getdate()
)
go
grant insert,update,delete on CustInvSpecOwnerOption to f8report

insert CustInvSpecOwnerOption (cUser_Id) values ('A13949')
insert CustInvSpecOwnerOption (cUser_Id) values ('A15268')
insert CustInvSpecOwnerOption (cUser_Id) values ('A5291')
insert CustInvSpecOwnerOption (cUser_Id) values ('A6575')
insert CustInvSpecOwnerOption (cUser_Id) values ('A6586')
insert CustInvSpecOwnerOption (cUser_Id) values ('jason')