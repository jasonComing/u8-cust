drop table Temp_ScrapRatio
create table Temp_ScrapRatio
(
	Id int,
	SortSeq int,
	FromQty Udt_QTY,
	ToQty Udt_QTY null,
	CompScrap decimal,
	CONSTRAINT pk_Temp_ScrapRatio PRIMARY KEY (Id, FromQty)
)

drop table Temp_ScrapComponent
create table Temp_ScrapComponent
(
	ScrapRatioId int,
	OpComponentId int,
	constraint pk_Temp_ScrapComponent primary key (ScrapRatioId, OpComponentId)
)

-- Insert Ratio
insert Temp_ScrapRatio values (1, 10, 0, 500, 10)
insert Temp_ScrapRatio values (1, 20, 501, 1000, 5)
insert Temp_ScrapRatio values (1, 30, 1001, 3000, 3)
insert Temp_ScrapRatio values (1, 40, 3001, 5000, 2)
insert Temp_ScrapRatio values (1, 50, 5001, 99999999999, 1)
insert Temp_ScrapRatio values (1, 50, 99999999999, null, 1)

insert into Temp_ScrapComponent
select 1, d.OpComponentId, hpp.InvCode
from bom_opcomponent d
join bas_part p on p.partid = d.componentid
join inventory i on i.cInvCode = p.invcode
join bom_bom h on h.bomid = d.bomid
join bom_parent hp on hp.bomid = h.bomid
join bas_part hpp on hpp.partid = hp.parentid
where hpp.InvCode in ('D_1513214','D_1513215','D_1513222','D_1513305','S_1513305','S_1513306','D_1513306','D_1513307','S_1513307','S_1513308','D_1513308','D_1700164','S_1700164','S_1710289','D_1710289')
and i.cInvCode like '607_%'

-- Temp Table
drop table #temp

-- Populate the Temp table
select 0 as Id, OpComponentId, SortSeq, FromQty, isnull(ToQty, 999999999999999999999.999999) as ToQty, CompScrap, 0 as isDefault, CURRENT_TIMESTAMP as TimeStamp
into #temp
from Temp_ScrapRatio r
join Temp_ScrapComponent c on c.ScrapRatioId = r.Id

-- use cursor to populate the Id column
declare @id int
select @id = max(OpComponentScrapId) + 1
from bom_opcomponentscrap
print @id

declare @OpComponentId int
declare @FromQty Udt_QTY

DECLARE id_cursor CURSOR FOR 
  select OpComponentId, FromQty from #temp order by OpComponentId, SortSeq

  OPEN id_cursor
  FETCH NEXT FROM id_cursor INTO @OpComponentId, @FromQty

  WHILE @@FETCH_STATUS = 0
  BEGIN	
	update #temp
	set Id = @id
	where OpComponentId = @OpComponentId
	and FromQty = @FromQty

	set @id = @id + 1

    FETCH NEXT FROM id_cursor INTO @OpComponentId, @FromQty
  END
CLOSE id_cursor

-- delete existing records
delete from bom_opcomponentscrap
where OpComponentId in (select OpComponentId from #temp)

-- Insert
insert into bom_opcomponentscrap (OpComponentScrapId, OpComponentId, SortSeq, FromQty, ToQty, CompScrap, DefaultFlag)
select Id, OpComponentId, SortSeq, FromQty, ToQty, CompScrap, isDefault from #temp

-- Reset identity
update UFSystem..UA_Identity   
set iChildId = (select max(OpComponentScrapId) from bom_opcomponentscrap)
where cAcc_Id = '003'
and cVouchType = 'bom_opcomponentscrap'
