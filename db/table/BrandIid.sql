create table CustBrandIid (
	Brand varchar(100) not null,
	iid int not null
)
go
create unique clustered index idx_CustBrandIid on CustBrandIid(Brand)
go


insert CustBrandIid values ('ADIDAS', 6)
insert CustBrandIid values ('BULOVA', 1)
insert CustBrandIid values ('CARAVELLE', 1)
insert CustBrandIid values ('chico’s', 1)
insert CustBrandIid values ('CITIZEN', 7)
insert CustBrandIid values ('FOSSIL', 6)
insert CustBrandIid values ('FOSSIL-AX', 6)
insert CustBrandIid values ('FOSSIL-CHAPS', 6)
insert CustBrandIid values ('FOSSIL-DIESEL', 6)
insert CustBrandIid values ('FOSSIL-DKNY', 6)
insert CustBrandIid values ('FOSSIL-FOSSIL', 6)
insert CustBrandIid values ('FOSSIL-JEWELRY', 6)
insert CustBrandIid values ('FOSSIL-Kate Spade', 6)
insert CustBrandIid values ('FOSSIL-KL', 6)
insert CustBrandIid values ('FOSSIL-MICHAEL KORS', 6)
insert CustBrandIid values ('FOSSIL-WOMEN', 6)
insert CustBrandIid values ('Hour Business', 1)
insert CustBrandIid values ('HUGO ORANGE', 3)
insert CustBrandIid values ('ICE', 2)
insert CustBrandIid values ('ICE-MAN', 2)
insert CustBrandIid values ('KARL LAGERFELD', 6)
insert CustBrandIid values ('Kate Spade', 5)
insert CustBrandIid values ('LACOSTE', 3)
insert CustBrandIid values ('LEGO', 1)
insert CustBrandIid values ('MarCo', 6)
insert CustBrandIid values ('PERSONA', 1)
insert CustBrandIid values ('REEBOK', 1)
insert CustBrandIid values ('TOMMY HILFIGER', 3)
insert CustBrandIid values ('WITTNAUER', 1)

go