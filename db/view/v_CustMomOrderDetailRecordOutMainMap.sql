
create view v_CustMomOrderDetailRecordOutMainMap
as
select distinct MoDId, AutoId as RecordOutDetailId
from v_sfc_stclckd_link