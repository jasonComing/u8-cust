
CREATE TRIGGER [dbo].[tri_AddProjectNOToDiZi]
/*
���ܣ�ᘌ�����ICE�ͻ��Ĳɹ������������ُ�Γ����е��w�ϼ�,
		�׃���һ�ڼ��� project̖
�{�÷�ʽ:������ُ�Εr,���r�|�l����.
*/
   ON  [dbo].[PO_PODetails_extradefine]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	--cbdefine24 �׃���
	--cbdefine25 ������
	--ȡ����ُӆ�ε����P���w��̖,�Ҟ�ICE�͑���ӆ��(id,jobno,d_xxx,projectno)
	--select i.ID,m.cSOCode,m.cInvCode,spectb.SpecValue
	--into #temp 
	--from Inserted i join PO_PODetails  p on i.ID =p.ID
	--left join v_CustSoInventoryMap m on m.cSOCode= p.csocode
	--left join SO_SOMain so on m.cSOCode=so.cSOCode
	--join (select  cuS.cinvCode,cuS.Version,cuS.status,cuD.PropertyId,cuD.SpecValue
	--		from CustInvSpec cuS
	--		join  CustInvSpecDetail cuD on (cuS.cInvCode = cuD.cInvCode and cuS.Version = cuD.Version)
	--		where cuS.status=1
	--		and cuD.PropertyId=218
	--		and (cuD.cInvCode like 'D%' or  cuD.cInvCode like 'S%')
	--		) spectb  on m.cInvCode=spectb.cinvCode
	--where p.cinvCode like '609%' 
	--and so.cCusCode ='1008'
	--and i.cbdefine25 is null
	 select i.ID,cuD.SpecValue
	 into #temp 
	 from Inserted i
	 join PO_PODetails p on i.ID =p.ID
	 join v_CustSoInventoryMap m on m.cSOCode= p.csocode
	 join SO_SOMain so on m.cSOCode=so.cSOCode
	 join CustInvSpec cuS on cuS.cInvCode = m.cInvCode
	 join CustInvSpecDetail cuD on (cuS.cInvCode = cuD.cInvCode and cuS.Version = cuD.Version)
	 where cuS.status=1
	 and cuD.PropertyId=218
	 and p.cinvCode like '609%' 
	 and so.cCusCode ='1008'
	 and i.cbdefine25 is null
	
	--������	
	update b set b.cbdefine25 = #temp.SpecValue
	from PO_PODetails_extradefine b
	join #temp on b.ID=#temp.ID

END