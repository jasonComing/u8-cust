
 Create proc SetSoCode
 /*
 功能:将采购订单的JOB号,写入表体扩展表中cbdefine3列
		以便开采购发票时,可以带出JOB号
 */
 as
 begin
	  update  e  set cbdefine3 = p.csocode
	  from PO_Podetails_ExtraDefine e
	  inner join PO_Podetails  p on e.ID =P.ID
	  where (e.cbdefine3 is null or e.cbdefine3 = '')
	  and  p.csocode is not null
 end