create view Cust_VariationLog
as
select convert(int, Id)as Id,BillType,BillId,BillNo,Action,UserCode,Time,Analysis,Condition,BillName,OperationReason
from VariationLog