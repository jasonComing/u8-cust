create table CustInvSpec
(
	cInvCode varchar(100),
	Version  int,
	CreatedBy varchar(100) not null,
	ClosedBy varchar(100),
	CreatedDate datetime default getdate(),
	LastModified datetime default getdate(),
	ClosedDate datetime null,
	Memo varchar(450),
	primary key (cInvCode, Version)
)

alter table CustInvSpec add	ApprovedBy varchar(100) null
alter table CustInvSpec add	ApprovedDate datetime null


update CustInvSpec
set ApprovedBy = CreatedBy, ApprovedDate = getdate()
