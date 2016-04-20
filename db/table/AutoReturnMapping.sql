create table AutoReturnMapping
(
	RdsAutoId bigint,
	AvsAutoId int,
	LastModified datetime default getdate()
)
go
create unique index Idx_AutoReturnMapping on AutoReturnMapping(RdsAutoId, AvsAutoId)
go

insert into AutoReturnMapping (RdsAutoId, AvsAutoId)
select rd.AutoId, vd.AutoId
from PU_ArrivalVouch vm
join PU_ArrivalVouchs vd on vm.Id = vd.Id
left join rdrecords01 rd on rd.cbarvcode = left(vm.cCode, len(vm.cCode) - 3)
left join rdrecords01_extradefine rdx on rdx.AutoID = rd.AutoId and rdx.cbdefine26 is not null and rdx.cbdefine26 != 0
where cCode like '%_RT'
and rdx.cbdefine26 = vd.iQuantity * -1
and rd.cInvCode = vd.cInvCode
go
