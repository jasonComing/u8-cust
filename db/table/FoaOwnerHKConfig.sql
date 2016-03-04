create table FoaOwnerHKConfig
(
	Id int identity,
	Brand varchar(200) not null,
	Owner varchar(50) not null,
	LastModified datetime default getdate() not null
)
go
grant select on FoaOwnerHKConfig to f8report
go


insert into FoaOwnerHKConfig(Brand, Owner) values ('Armani Exchange', 'Wallis')
insert into FoaOwnerHKConfig(Brand, Owner) values ('Chaps', 'Dennis')
insert into FoaOwnerHKConfig(Brand, Owner) values ('DKNY', 'Janet')
--insert into FoaOwnerHKConfig(Brand, Owner) values ('Fossil', '')
insert into FoaOwnerHKConfig(Brand, Owner) values ('Karl Lagerfeld', 'Janet')
--insert into FoaOwnerHKConfig(Brand, Owner) values ('Private Label', '')
insert into FoaOwnerHKConfig(Brand, Owner) values ('Michael Kors', 'Janet')
insert into FoaOwnerHKConfig(Brand, Owner) values ('ADIADS', 'Grace')
insert into FoaOwnerHKConfig(Brand, Owner) values ('DIESEL', 'Grace')
insert into FoaOwnerHKConfig(Brand, Owner) values ('RELIC', 'Wallis')
insert into FoaOwnerHKConfig(Brand, Owner) values ('KATE SPADE', 'Grace')
insert into FoaOwnerHKConfig(Brand, Owner) values ('MBM', 'Janet')






