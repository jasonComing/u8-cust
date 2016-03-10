create table CustFoaOwnerHKConfig
(
	Id int identity,
	Brand varchar(200) not null,
	Owner varchar(50) not null,
	LastModified datetime default getdate() not null
)
go
grant select on CustFoaOwnerHKConfig to f8report
go


insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Armani Exchange', 'Wallis')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Chaps', 'Dennis')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('DKNY', 'Janet')
--insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Fossil', '')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Karl Lagerfeld', 'Janet')
--insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Private Label', '')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('Michael Kors', 'Janet')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('ADIADS', 'Grace')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('DIESEL', 'Grace')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('RELIC', 'Wallis')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('KATE SPADE', 'Grace')
insert into CustFoaOwnerHKConfig(Brand, Owner) values ('MBM', 'Janet')






