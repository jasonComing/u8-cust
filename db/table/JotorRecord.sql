Create table CustJotorRecord
(
	Id int identity primary key,
	Year int not null,
	JobSeed int not null,
	RequestedBy varchar(50) not null,
	RequestedAt datetime not null default getdate(),
	ReturnedBy varchar(50) null,
	ReturnedAt datetime null,
	ReusedById int null,
	ReusedAt datetime null
)
go
create index idx_JotorRecord on CustJotorRecord(Year, JobSeed)
go
grant select,insert,update,delete on CustJotorRecord to f8report
go

insert CustJotorRecord (Year, JobSeed, RequestedBy, RequestedAt, ReturnedBy, ReturnedAt, ReusedById, ReusedAt)
values (16, 2074, 'system', getdate(), null, null, null, null)