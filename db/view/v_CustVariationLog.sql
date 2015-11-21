create view v_CustVariationLog
as
select convert(int, Id)as Id,BillType,BillId,BillNo,Action,UserCode,Time,Analysis,Condition,BillName,OperationReason
from VariationLog