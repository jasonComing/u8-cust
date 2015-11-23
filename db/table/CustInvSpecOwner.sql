create table CustInvSpecOwner
(
	cInvCode varchar(100) not null,
	Owner varchar(100) not null,
	LastModified datetime default getdate(),
	primary key (cInvCode, Owner)
)
