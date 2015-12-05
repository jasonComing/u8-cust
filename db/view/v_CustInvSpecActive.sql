create view v_CustInvSpecActive
as
select cInvCode,Version,CreatedBy,ClosedBy,CreatedDate,LastModified,ClosedDate,Memo,ApprovedBy,ApprovedDate,Status
from CustInvSpec
where Status = 1
